# Compatibility and prerequisites

## Expected caller repository layout

The reusable workflow detects projects with `snyk test --all-projects` starting from `working_directory`. At least one supported manifest must exist, for example:

- `package.json` with `package-lock.json`, `yarn.lock`, or `pnpm-lock.yaml`
- `requirements.txt`, `pyproject.toml` with `poetry.lock`, or `Pipfile.lock`
- `build.gradle`, `build.gradle.kts`, or `pom.xml`
- `go.mod`
- `*.csproj` / `packages.config`

Use `exclude` to skip directories such as `examples`, `test-fixtures`, or vendored code.

## Snyk-side prerequisites

- A Snyk organization for the caller projects.
- A Snyk token with permission to test and monitor projects in that organization. Service account tokens are recommended.
- When `project_environment`, `project_lifecycle`, `project_business_criticality`, or `project_tags` are passed, the token also needs the `Edit project attributes` and `Edit project tags` permissions (for example the Org Admin role or a custom role). The default Org Collaborator role does not include them.
- Snyk Code enabled for the organization when `enable_code_scan` is true.

## GitHub-side prerequisites

- The caller repository must define `SNYK_TOKEN` as a GitHub repository or organization secret and pass it to the workflow.
- `SNYK_ORG` must be defined as a variable (or passed as `snyk_org`) when the token can access more than one Snyk organization.
- The caller workflow needs `contents: read` permission.
- The selected runner must be Linux x64 or arm64 with `curl` and `sha256sum` available. `jq` is installed automatically when missing.
- Pull requests from forks do not receive secrets, so the workflow fails the configuration step for them.

## When this workflow is the wrong fit

This repository is a fit for Snyk Open Source dependency analysis and optional Snyk Code analysis of source repositories.

It does not cover:

- container image scanning (`snyk container`)
- infrastructure-as-code scanning (`snyk iac`)

If those are needed, extend the workflow in a new minor version or create a separate validation product.
