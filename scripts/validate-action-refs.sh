#!/usr/bin/env bash

set -euo pipefail

declare -A expected_major=(
  ["actions/checkout"]="v5"
  ["actions/setup-node"]="v5"
  ["actions/setup-python"]="v6"
  ["actions/upload-artifact"]="v5"
)

has_errors=0

while IFS= read -r match; do
  file="${match%%:*}"
  rest="${match#*:}"
  line="${rest%%:*}"
  ref="${match#*uses: }"
  ref="${ref#"${ref%%[![:space:]]*}"}"

  case "$ref" in
    ./*|docker://*)
      continue
      ;;
  esac

  if [[ "$ref" != *@* ]]; then
    echo "$file:$line: action reference must include an explicit @ref: $ref"
    has_errors=1
    continue
  fi

  action="${ref%@*}"
  version="${ref##*@}"

  if [[ "$version" =~ ^(main|master|HEAD|latest)$ ]]; then
    echo "$file:$line: mutable action ref is not allowed: $ref"
    has_errors=1
    continue
  fi

  if [[ "$version" =~ ^refs/ ]]; then
    echo "$file:$line: raw refs/* action references are not allowed: $ref"
    has_errors=1
    continue
  fi

  if [[ "$version" =~ ^[0-9a-f]{40}$ ]]; then
    continue
  fi

  if [[ ! "$version" =~ ^v[0-9]+(\.[0-9]+){0,2}$ ]]; then
    echo "$file:$line: action ref must use a semver tag or full commit SHA: $ref"
    has_errors=1
    continue
  fi

  expected="${expected_major[$action]:-}"
  if [[ -n "$expected" ]]; then
    actual_major="${version%%.*}"
    if [[ "$actual_major" != "$expected" ]]; then
      echo "$file:$line: expected $action@$expected.x but found $ref"
      has_errors=1
    fi
  fi
done < <(grep -RhonE '^[[:space:]]*uses:[[:space:]]*[^[:space:]]+' .github/workflows examples 2>/dev/null || true)

if [[ "$has_errors" -ne 0 ]]; then
  exit 1
fi

echo "Action reference validation passed"
