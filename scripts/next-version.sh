#!/usr/bin/env bash

set -euo pipefail

branch="${1:-}"

if [[ -z "$branch" ]]; then
  echo "Usage: $0 <develop|main>"
  exit 1
fi

if [[ "$branch" != "develop" && "$branch" != "main" ]]; then
  echo "Unsupported release branch: $branch"
  exit 1
fi

latest_tag="$(git tag --list | grep -E '^v[0-9]+\.[0-9]+$' | sort -V | tail -n1 || true)"

if [[ -z "$latest_tag" ]]; then
  if [[ "$branch" == "main" ]]; then
    echo "v1.0"
  else
    echo "v0.1"
  fi
  exit 0
fi

version="${latest_tag#v}"
major="${version%%.*}"
minor="${version##*.}"

if [[ "$branch" == "main" ]]; then
  echo "v$((major + 1)).0"
else
  echo "v${major}.$((minor + 1))"
fi
