# Contributing

## Workflow

1. Make changes on a feature branch.
2. Update `CHANGELOG.md` if behavior, contract, defaults, or supported repository layout changed.
3. Update `docs/inputs.md` and `examples/` when caller-facing configuration changed.
4. Open a pull request into `develop` or `main` and ensure `validate.yml` passes.
5. Merge into `develop` for the next iterative release line.
6. Merge into `main` for the next stable major release line.

## Validation

Run the same checks locally before opening a pull request when practical:

```bash
bash scripts/validate-action-refs.sh
```

The GitHub Actions validation workflow is the source of truth for workflow syntax and action reference policy.

## Versioning

- The repository uses branch-based tags in the form `vX.Y`.
- A push to `develop` creates the next `vX.(Y+1)` prerelease tag.
- A push to `main` creates the next `v(X+1).0` stable tag.
- The latest existing `vX.Y` tag is the source of truth for the next version calculation.
