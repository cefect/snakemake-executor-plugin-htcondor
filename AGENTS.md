# GitHub Actions workflows

- Before dispatching a GitHub Actions workflow, confirm that this repository's local self-hosted runner is online.
- If the runner is offline, try to start it with `/home/cefect/LS/09_REPOS/04_TOOLS/gh_runner/actions-runner-htcondor/run.sh` before dispatching the workflow.
- Confirm that the runner reports as online after the startup attempt, and do not dispatch the workflow if the runner could not be started.
