# validation-snyk-analysis

[![Validate](https://github.com/ninetwothree/validation-snyk-analysis/actions/workflows/validate.yml/badge.svg)](https://github.com/ninetwothree/validation-snyk-analysis/actions/workflows/validate.yml)
[![Release](https://github.com/ninetwothree/validation-snyk-analysis/actions/workflows/release.yml/badge.svg)](https://github.com/ninetwothree/validation-snyk-analysis/actions/workflows/release.yml)

Reusable GitHub Actions workflow for Snyk security analysis of application repositories.

This workflow installs a pinned and checksum-verified Snyk CLI, runs `snyk test --all-projects` against the caller repository, publishes a snapshot to the Snyk UI with `snyk monitor` (so every repository and branch shows up as a Snyk project), optionally runs Snyk Code (SAST), and renders the results into the GitHub Actions job summary.

The workflow is report-only by default: it does not fail the caller pipeline because of found vulnerabilities unless `fail_on_issues` is enabled.

Runner selection is automatic by default:

- caller repositories owned by `ninetwothree` use `ubuntu-24-arm-runner`
- other caller repositories use GitHub-hosted `ubuntu-24.04-arm`

You can still override the runner explicitly through the optional `runner` input.

This repository is public. It contains no tokens, organization IDs, or other credentials. All Snyk configuration is supplied by the caller repository.

## What this repository contains

- `.github/workflows/analyze.yml`: reusable Snyk analysis workflow consumed by application repositories
- `.github/workflows/validate.yml`: CI checks for workflow syntax and action reference policy
- `.github/workflows/release.yml`: automatic branch-based release flow for `develop` and `main`
- `docs/`: caller contract, compatibility notes, and release process
- `examples/`: example wrapper workflows for application repositories
- `scripts/`: local scripts reused by CI and release jobs

## Quick start

In the caller repository:

```yaml
jobs:
  snyk:
    uses: ninetwothree/validation-snyk-analysis/.github/workflows/analyze.yml@v1.0
    secrets:
      SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
```

Required GitHub secret (repository or organization level):

- `SNYK_TOKEN`

Optional GitHub variables (repository or organization level):

- `SNYK_ORG` — Snyk organization slug or ID; falls back to the default organization of the token
- `SNYK_API` — Snyk API endpoint for non-US tenants, for example `https://api.eu.snyk.io`

## Documentation

- `docs/usage.md`: integration guidance and wrapper patterns
- `docs/inputs.md`: full workflow contract
- `docs/compatibility.md`: supported ecosystems and Snyk-side prerequisites
- `docs/release-process.md`: release flow and tagging rules
- `docs/changelog-policy.md`: changelog and versioning policy

## Release policy

- Use branch-based tags in the form `vX.Y`.
- Pushes to `develop` create the next iterative prerelease tag.
- Pushes to `main` create the next stable major tag.
- Test on branch refs only during development.
- Use tags or commit SHAs in consumer repositories.
- Never point production callers to `main`.
