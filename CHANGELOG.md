# Changelog

All notable changes to this repository will be documented in this file.

GitHub Releases are the authoritative record for published versions in this repository. This file tracks unreleased notes between automated branch-based releases.

## [Unreleased]

### Added
- Initial repository scaffold for the reusable Snyk analysis workflow.
- `snyk test --all-projects` with a Markdown job summary (severity counts, scanned manifests, top issues with fix hints) and uploaded JSON/SARIF results.
- `snyk monitor --all-projects` on non-PR events so caller repositories appear in the Snyk UI, grouped by branch through `--target-reference`.
- Optional Snyk Code (SAST) scan through `enable_code_scan`.
- Optional report gating through `fail_on_issues` and `severity_threshold`.

### Changed
- Reused the validation, release automation, runner selection, and repository structure established for the deployment workflow repositories.
- Installed the Snyk CLI from pinned, checksum-verified binaries instead of the mutable `snyk/actions` refs.
