# Changelog policy

This repository uses a human-maintained changelog.

## Rules

- Keep an `Unreleased` section at the top of `CHANGELOG.md`.
- Add entries for any change that affects caller behavior, required inputs, outputs, defaults, or compatibility assumptions.
- Do not block releases on manually cutting versioned changelog sections.
- Use GitHub Releases as the source of truth for published versions.

## Versioning guide

- Tags use the format `vX.Y`.
- The next tag is calculated automatically from the latest existing `vX.Y` tag.
- Pushes to `develop` increment `Y`.
- Pushes to `main` increment `X` and reset `Y` to `0`.
