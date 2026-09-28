# Security Policy

## Scope

This is a public repository that contains reusable security analysis automation. Callers pass their Snyk token into this workflow, so treat workflow changes as changes with access to caller credentials.

## Expectations

- Never commit Snyk tokens, organization IDs, customer names, or any other caller-specific configuration to this repository.
- Store `SNYK_TOKEN` as a GitHub repository or organization secret in the caller repository and pass it explicitly instead of `secrets: inherit`.
- Prefer Snyk service account tokens scoped to a single Snyk organization over personal tokens.
- Rotate the Snyk token when access changes or when a token is exposed.
- Keep the Snyk CLI pinned to an exact version with checksum verification.
- Keep permissions minimal in GitHub Actions; the workflow needs only `contents: read`.
- Review all changes to workflow files and scripts before release.
- Prefer immutable release refs in consumer repositories.
- Job summaries and uploaded artifacts list vulnerable packages; they are visible to anyone who can read the caller repository's Actions runs.
