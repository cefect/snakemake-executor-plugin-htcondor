# GitHub Actions workflows

- Before dispatching a GitHub Actions workflow, confirm that this repository's local self-hosted runner is online.
- If the runner is offline, try to start it with `/home/cefect/LS/09_REPOS/04_TOOLS/gh_runner/actions-runner-htcondor/run.sh` before dispatching the workflow.
- Confirm that the runner reports as online after the startup attempt, and do not dispatch the workflow if the runner could not be started.

# Pre-commit validation

- Before committing or pushing changes, run `pre-commit run --all-files` using the repository's configured environment.
- Do not treat syntax compilation, focused tests, or `git diff --check` as substitutes for the full pre-commit suite.
- If pre-commit is unavailable, do not install it automatically; use an existing project environment or container, or report the limitation before committing or pushing.

# Local test environment

- Conda env `htcondor-plugin` (Python 3.11) has the project installed editable with dev deps (pytest, snakemake, pre-commit, coverage).
- Unit tests: `conda run -n htcondor-plugin python -m pytest tests/`. `integration_tests/` need a live HTCondor AP; rely on CI.
- The default `~/.cache/pre-commit` hook envs are broken (missing `libpython3.11.so`); run pre-commit with a separate cache:
  `PRE_COMMIT_HOME=$HOME/.cache/pre-commit-htcondor-plugin conda run -n htcondor-plugin pre-commit run --all-files`
