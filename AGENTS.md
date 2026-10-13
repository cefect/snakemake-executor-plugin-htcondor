# GitHub Actions workflows

- Before dispatching a GitHub Actions workflow, confirm that this repository's local self-hosted runner is online.
- If the runner is offline, try to start it with `/home/cefect/LS/09_REPOS/04_TOOLS/gh_runner/actions-runner-htcondor/run.sh` before dispatching the workflow.
- Confirm that the runner reports as online after the startup attempt, and do not dispatch the workflow if the runner could not be started.
- Managed sandbox network restrictions can cause `gh api` connection failures even when the host network works.
  Retry the runner status check with approved host execution before diagnosing a network outage.
- Starting the runner writes helper files and logs outside this repository, so use approved host execution for `run.sh`.
- Detached `nohup` runner processes may be stopped when a managed command exits.
  Use a persistent terminal session (`tty=true`) for `run.sh` and verify GitHub reports the runner online.
- If `gh pr edit` fails on deprecated `projectCards` fields, update PR title/body/labels through `gh api --method PATCH repos/cefect/snakemake-executor-plugin-htcondor/issues/<number>` with a JSON input file.

# Pre-commit validation

- Before committing or pushing changes, run `pre-commit run --all-files` using the repository's configured environment.
- Do not treat syntax compilation, focused tests, or `git diff --check` as substitutes for the full pre-commit suite.
- If pre-commit is unavailable, do not install it automatically; use an existing project environment or container, or report the limitation before committing or pushing.

# Local test environment

- Project skills live in `.agents/skills`, with `.claude/skills` symlinked there.
  The managed sandbox may expose `.agents` as read-only even when the host directory is writable; use approved host execution for authorized skill-directory changes.
- `github_scripts/.snakemake` may be owned by a container user and unwritable locally.
  For isolated dry-run probes, pass the absolute `github_scripts/Snakefile` path with `--snakefile` and a fresh writable directory with `--directory` instead of changing its ownership.
- Conda env `htcondor-plugin` (Python 3.11) has the project installed editable with dev deps (pytest, snakemake, pre-commit, coverage).
- Unit tests: `conda run -n htcondor-plugin python -m pytest tests/`. `integration_tests/` need a live HTCondor AP; rely on CI.
- The default `~/.cache/pre-commit` hook envs are broken (missing `libpython3.11.so`); run pre-commit with a separate cache:
  `PRE_COMMIT_HOME=$HOME/.cache/pre-commit-htcondor-plugin conda run -n htcondor-plugin pre-commit run --all-files`
- If Black stalls in the managed sandbox, stop that run and retry the full suite with approved host execution; the existing hook environments work there.
