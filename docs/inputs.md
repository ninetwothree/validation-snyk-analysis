# Workflow contract

Reusable workflow path:

```text
.github/workflows/analyze.yml
```

## Inputs

| Name | Required | Default | Description |
| --- | --- | --- | --- |
| `snyk_org` | no | `SNYK_ORG` variable | Snyk organization slug or ID. Falls back to the `SNYK_ORG` variable, then to the default organization of the token |
| `monitor` | no | `true` | Whether to publish a snapshot to the Snyk UI with `snyk monitor`. Always skipped for `pull_request` events |
| `target_reference` | no | branch name | Snyk target reference used to group projects by branch |
| `severity_threshold` | no | `high` | Minimum severity counted as blocking: `low`, `medium`, `high`, `critical` |
| `fail_on_issues` | no | `false` | Whether to fail the job when issues at or above `severity_threshold` are found |
| `enable_code_scan` | no | `false` | Whether to run Snyk Code (SAST). Requires Snyk Code to be enabled for the Snyk organization |
| `working_directory` | no | `.` | Directory in the caller repository where the analysis runs |
| `exclude` | no | none | Comma-separated directory or file names excluded from project detection |
| `detection_depth` | no | CLI default | How many subdirectory levels to search for manifests |
| `additional_args` | no | none | Extra arguments appended to both `snyk test` and `snyk monitor` |
| `project_environment` | no | none | Snyk project environment attribute, for example `backend`, `frontend`, `mobile` |
| `project_lifecycle` | no | none | Snyk project lifecycle attribute: `production`, `development`, `sandbox` |
| `project_business_criticality` | no | none | Snyk project business criticality attribute: `critical`, `high`, `medium`, `low` |
| `project_tags` | no | none | Comma-separated `key=value` tags set on Snyk projects |
| `python_version` | no | runner Python | Python version to install. When empty, the runner Python is used |
| `install_command` | no | none | Dependency installation command executed in `working_directory` before the analysis |
| `snyk_cli_version` | no | `1.1307.4` | Exact Snyk CLI version to install |
| `force_legacy_cli` | no | `true` | Force the legacy Snyk Open Source test flow (`SNYK_FORCE_LEGACY_CLI`) instead of the Unified Test API |
| `scan_timeout_minutes` | no | `10` | Maximum duration of each Snyk command in minutes |
| `summary_max_issues` | no | `50` | Maximum number of issues listed in the job summary |
| `artifact_name` | no | `snyk-results` | Name of the uploaded artifact with raw Snyk results |
| `runner` | no | auto | Optional runner override |

## Secrets

| Name | Required | Description |
| --- | --- | --- |
| `SNYK_TOKEN` | yes | Snyk API token. A service account token scoped to one Snyk organization is recommended |

The secret is declared as optional in the workflow contract so that a missing value produces a clear configuration error instead of a generic GitHub error.

## Variables

Optional GitHub repository or organization variables read by the workflow:

- `SNYK_ORG` — Snyk organization slug or ID
- `SNYK_API` — Snyk API endpoint for regional tenants, for example `https://api.eu.snyk.io`

## Outputs

| Name | Description |
| --- | --- |
| `issues_count` | Number of unique Snyk Open Source issues |
| `critical_count` | Number of unique critical Snyk Open Source issues |
| `high_count` | Number of unique high Snyk Open Source issues |
| `medium_count` | Number of unique medium Snyk Open Source issues |
| `low_count` | Number of unique low Snyk Open Source issues |
| `code_issues_count` | Number of Snyk Code issues, `0` when the code scan is disabled |
| `blocking_issues_count` | Number of Open Source and Code issues at or above `severity_threshold` |

## Artifact

The workflow uploads `artifact_name` with:

- `snyk-open-source.json`, `snyk-open-source.sarif`, `snyk-open-source.txt`
- `snyk-monitor.json` when `snyk monitor` ran
- `snyk-code.sarif`, `snyk-code.txt` when the code scan ran
- `summary.md` — the same report written to the job summary

## Compatibility notes

- Standard usage requires no `with:` inputs; only `SNYK_TOKEN` is required.
- The workflow is report-only by default and fails only when a Snyk CLI command errors out or times out.
- `SNYK_TOKEN` is verified with `snyk whoami` before any scan, so an invalid token fails fast with troubleshooting hints.
- `force_legacy_cli` defaults to `true`: for organizations where Snyk has enabled the Unified Test API rollout, `snyk test` polls a server-side test job that may never complete. Set it to `false` only after confirming the new flow finishes for the organization.
- Project attributes and tags require the Snyk token to have the `Edit project attributes` / `Edit project tags` permissions. Without them Snyk rejects the whole monitor call with a misleading `Use snyk auth to authenticate` error; the workflow then retries once without attributes and tags and emits a warning.
- Snyk resolves Python projects, including `poetry.lock`, through the `python` command. When the runner only has `python3`, the workflow links `python` to it automatically.
- `snyk monitor` runs on `push`, `workflow_dispatch`, and other non-PR events; pull requests only get `snyk test`.
- Issues are counted once per vulnerability ID, package, and version across all detected manifests.
- Snyk Code severity is mapped from SARIF levels: `error` → `high`, `warning` → `medium`, `note` → `low`.
- If `runner` is omitted, repositories owned by `ninetwothree` use `ubuntu-24-arm-runner`, all other repositories use `ubuntu-24.04-arm`.
