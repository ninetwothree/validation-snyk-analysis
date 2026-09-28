# Usage

This repository is intended to be called from an application repository through a thin wrapper workflow, either standalone or as a job next to the deploy job.

## Why use a wrapper

The wrapper keeps project-specific concerns in the application repository:

- triggers
- branch-to-environment mapping
- Snyk project attributes and tags
- whether findings should block the pipeline

The reusable workflow repository keeps only the analysis logic itself.

## Minimal wrapper

See `examples/wrapper.yml`.

It runs `snyk test` on pull requests and `snyk test` + `snyk monitor` on pushes to `develop`, `uat`, and `main`.

## Wrapper next to a deploy

See `examples/wrapper-with-branches.yml`.

The `snyk` job runs in parallel with `deploy`, so the report appears in the same workflow run as the deployment without delaying or blocking it. To gate the deploy on Snyk, add `snyk` to `deploy.needs` and set `fail_on_issues: true`.

## Recommended caller configuration

Store this as a GitHub repository or organization secret:

- `SNYK_TOKEN`

Store these as GitHub repository or organization variables when needed:

- `SNYK_ORG` — required when the token has access to more than one Snyk organization
- `SNYK_API` — required only for non-US Snyk tenants

Pass the secret explicitly:

```yaml
secrets:
  SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
```

## How projects appear in Snyk

- Targets are named after the caller repository (`--remote-repo-url`).
- Every detected manifest becomes a separate Snyk project.
- Branches are separated through `--target-reference`, so `develop`, `uat`, and `main` are visible as separate project groups in the same target.
- Project attributes (`project_environment`, `project_lifecycle`, `project_business_criticality`) and `project_tags` are applied on every monitor run.

## Ecosystems that need installed dependencies

JavaScript lockfiles (npm, Yarn, pnpm) and Go modules are analysed directly from the lockfile.

Python projects need a `python` command on the runner, even for `poetry.lock`. The workflow uses the runner Python by default; pin a version when the project requires a specific one.

pip `requirements.txt` projects additionally need installed dependencies:

```yaml
with:
  python_version: "3.12"
  install_command: pip install -r requirements.txt
```

The runner already has Node.js, so a JavaScript project without a lockfile only needs `install_command: npm install`.

## Monorepos

Call the workflow once per directory and give every call a unique `artifact_name`:

```yaml
jobs:
  snyk-api:
    uses: ninetwothree/validation-snyk-analysis/.github/workflows/analyze.yml@v1.0
    with:
      working_directory: api
      artifact_name: snyk-results-api
    secrets:
      SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}

  snyk-web:
    uses: ninetwothree/validation-snyk-analysis/.github/workflows/analyze.yml@v1.0
    with:
      working_directory: web
      artifact_name: snyk-results-web
    secrets:
      SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
```

A single call from the repository root with `--all-projects` is usually enough; split only when directories need different toolchains.

## Runner behavior

By default, the reusable workflow selects the runner automatically:

- `ninetwothree/*` caller repositories use `ubuntu-24-arm-runner`
- all other caller repositories use GitHub-hosted `ubuntu-24.04-arm`

Use the optional `runner` input only when you intentionally need to override that default, for example when a Gradle or Maven build requires an x64 runner.
