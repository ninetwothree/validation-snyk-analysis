# Release process

## Release rules

- Releases are created automatically on pushes to `develop` and `main`.
- Consumer repositories should reference tags such as `v1.2` or a full commit SHA.
- Use branch refs only for temporary testing.

## Branch behavior

- `develop` creates the next iterative prerelease in the form `vX.Y`
- `main` creates the next stable release in the form `v(X+1).0`

## Standard flow

1. Open a pull request into `develop` or `main`.
2. Let `validate.yml` pass.
3. Merge the pull request.
4. The `release.yml` workflow runs on the resulting push.
5. The workflow calculates the next `vX.Y` tag, pushes it, and creates the GitHub Release automatically.

## Version calculation

- If no release tags exist yet:
  - first push to `develop` creates `v0.1`
  - first push to `main` creates `v1.0`
- Otherwise the latest existing `vX.Y` tag is used as the base:
  - `develop` keeps `X` and increments `Y`
  - `main` increments `X` and resets `Y` to `0`

## Release type

- Releases created from `develop` are published as GitHub prereleases.
- Releases created from `main` are published as normal GitHub releases.
