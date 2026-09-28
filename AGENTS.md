# Snyk Analysis Notes For Agents

This repository contains the reusable Snyk analysis workflow:

```text
ninetwothree/validation-snyk-analysis/.github/workflows/analyze.yml
```

Use this file when an agent needs to decide whether a project fits this analysis model and how to call it correctly.

## What this workflow does

- Installs a pinned Snyk CLI and verifies its SHA-256 checksum
- Optionally sets up Node.js / Python and installs dependencies
- Runs `snyk test --all-projects` and collects JSON and SARIF results
- Runs `snyk monitor --all-projects` on non-PR events so projects appear in the Snyk UI, grouped by branch through `--target-reference`
- Optionally runs `snyk code test` (SAST)
- Writes a Markdown report to the GitHub Actions job summary and uploads raw results as an artifact
- Fails only on Snyk CLI errors, or on blocking issues when `fail_on_issues` is true

## How agents should call it

Preferred wrapper pattern:

```yaml
jobs:
  snyk:
    uses: ninetwothree/validation-snyk-analysis/.github/workflows/analyze.yml@v1.0
    secrets:
      SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
```

Rules:

- Keep triggers and branch mapping in the caller repository.
- Pass `SNYK_TOKEN` explicitly instead of `secrets: inherit`; this repository is public and needs only that one secret.
- Run the Snyk job in parallel with deploy jobs (no `needs` from deploy to snyk) unless the caller intentionally gates deploys on it.
- Prefer release tags or commit SHAs for stable consumers.
- Never add tokens, Snyk organization IDs, or customer names to this repository.

Optional inputs agents may override:

- `snyk_org`
- `monitor`
- `target_reference`
- `severity_threshold`
- `fail_on_issues`
- `enable_code_scan`
- `working_directory`
- `exclude`
- `detection_depth`
- `additional_args`
- `project_environment`
- `project_lifecycle`
- `project_business_criticality`
- `project_tags`
- `node_version`
- `enable_corepack`
- `python_version`
- `install_command`
- `snyk_cli_version`
- `summary_max_issues`
- `artifact_name`
- `runner`

## Required caller GitHub secret and variables

Required GitHub secret:

- `SNYK_TOKEN`

Optional GitHub variables:

- `SNYK_ORG`
- `SNYK_API`

## Repository prerequisites agents must verify

Agents should only use this workflow when all of the following are true:

- The repository contains at least one manifest supported by Snyk Open Source (for example `package.json` with a lockfile, `requirements.txt`, `pyproject.toml` with `poetry.lock`, `build.gradle(.kts)`, `pom.xml`, `go.mod`).
- Ecosystems that need installed dependencies to resolve the dependency tree (pip `requirements.txt`, Gradle, Maven) have the matching toolchain on the runner or through `node_version` / `python_version` / `install_command`.
- The caller repository has `SNYK_TOKEN` configured.

## When agents should not use this workflow

Do not use this workflow when any of these are true:

- The goal is container image or IaC scanning only; this workflow covers Snyk Open Source and Snyk Code.
- The repository has no supported dependency manifests and Snyk Code is not enabled for the organization.
- The project is already imported into Snyk through the SCM integration and duplicated CLI projects are not wanted.

For more detail, see:

- [README.md](./README.md)
- [docs/inputs.md](./docs/inputs.md)
- [docs/compatibility.md](./docs/compatibility.md)
