# Changelog

All notable changes to this repository will be documented in this file.

GitHub Releases are the authoritative record for published versions in this repository. This file tracks unreleased notes between automated branch-based releases.

## [Unreleased]

### Added
- `Verify Snyk authentication` step (`snyk whoami`) that fails fast with troubleshooting hints when `SNYK_TOKEN` is rejected.
- `scan_timeout_minutes` input (default `10`) that bounds every Snyk command.
- `force_legacy_cli` input (default `true`) that sets `SNYK_FORCE_LEGACY_CLI`. Fixes `snyk test` hanging indefinitely for organizations in the Snyk Unified Test API rollout.
- `snyk monitor` retries once without project attributes and tags when the token lacks permission to edit them, instead of failing with a misleading `snyk auth` error.
- Automatic `python` -> `python3` link when the runner has no `python` command, required by Snyk for Python projects including `poetry.lock`.

### Removed
- `node_version` and `enable_corepack` inputs. JavaScript lockfiles are analysed without Node.js setup, and the runner Node.js covers `install_command`. **Breaking** for callers that pass these inputs.

### Changed
- Snyk command output is written to a file and printed afterwards instead of being piped through `tee`.

## v1.0

### Added
- Initial repository scaffold for the reusable Snyk analysis workflow.
- `snyk test --all-projects` with a Markdown job summary (severity counts, scanned manifests, top issues with fix hints) and uploaded JSON/SARIF results.
- `snyk monitor --all-projects` on non-PR events so caller repositories appear in the Snyk UI, grouped by branch through `--target-reference`.
- Optional Snyk Code (SAST) scan through `enable_code_scan`.
- Optional report gating through `fail_on_issues` and `severity_threshold`.

### Changed
- Reused the validation, release automation, runner selection, and repository structure established for the deployment workflow repositories.
- Installed the Snyk CLI from pinned, checksum-verified binaries instead of the mutable `snyk/actions` refs.
