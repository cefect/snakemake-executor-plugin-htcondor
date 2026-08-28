# GitHub Actions workflows

- Before dispatching a GitHub Actions workflow, confirm that this repository's local self-hosted runner is online.
- If the runner is offline, try to start it with `/home/cefect/LS/09_REPOS/04_TOOLS/gh_runner/actions-runner-htcondor/run.sh` before dispatching the workflow.
- Confirm that the runner reports as online after the startup attempt, and do not dispatch the workflow if the runner could not be started.

# Pre-commit validation

- Before committing or pushing changes, run `pre-commit run --all-files` using the repository's configured environment.
- Do not treat syntax compilation, focused tests, or `git diff --check` as substitutes for the full pre-commit suite.
- If pre-commit is unavailable, do not install it automatically; use an existing project environment or container, or report the limitation before committing or pushing.
