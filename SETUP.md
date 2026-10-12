# Self-hosted GitHub Actions runner setup

## Decision

Keep this project's self-hosted GitHub Actions runner on CEFTOP25M.

Do not deploy a runner for this project on `linstat1`.

The project workflows require Docker Engine, Docker Compose, and Docker Buildx.

CEFTOP25M is the intended Docker-capable host.

`linstat1` currently provides Podman but not the required `docker`, `docker compose`, or `docker buildx bake` interfaces.

Do not repurpose the existing `linstat1-usf-lin1` runner.

That runner is repository-scoped to `cefect/USFloods_inference` and should remain isolated from this project.

## Repository behavior

The `CI` and `Torture Test` workflows use the repository variable `SELF_HOSTED_RUNNER_LABEL` for push and manual runs.

Pull-request runs remain on `ubuntu-latest`.

The repository variable is currently set to `self-hosted`.

The repository currently reports no registered self-hosted runner, so manual runs that select `self-hosted` remain queued until the CEFTOP25M runner is online.

## CEFTOP25M runner location

The existing project documentation identifies this runner launcher:

```text
/home/cefect/LS/09_REPOS/04_TOOLS/gh_runner/actions-runner-htcondor/run.sh
```

Use that existing installation instead of creating another runner on `linstat1`.

This session cannot inspect or change CEFTOP25M directly.

## CEFTOP25M verification

Start Docker Desktop before starting the runner.

Do not install or modify Windows software without a separate review and explicit approval.

From the established CEFTOP25M Linux environment, verify all workflow-required Docker interfaces.

```bash
# Verify the Docker engine and required plugins.
docker version
docker buildx version
docker compose version
```

Confirm that the existing runner remains registered to this repository.

```bash
# Inspect the local registration without printing credentials.
RUNNER_DIR="/home/cefect/LS/09_REPOS/04_TOOLS/gh_runner/actions-runner-htcondor"
cd "$RUNNER_DIR"
sed -n -e '/"agentName"/p' -e '/"gitHubUrl"/p' -e '/"workFolder"/p' .runner

# Inspect GitHub's registration status and labels.
gh api repos/cefect/snakemake-executor-plugin-htcondor/actions/runners \
  --jq '.runners[] | {name, status, busy, labels: [.labels[].name]}'
```

If `.runner` is missing or GitHub reports no runner, obtain a new repository registration token from the repository's **Settings > Actions > Runners** page and follow the displayed commands from the existing runner directory.

Do not paste the registration token into project files, issue comments, or chat.

## Start the CEFTOP25M runner

Use the established launcher documented in `README-cef.md`.

```bash
# Start the existing repository runner.
/home/cefect/LS/09_REPOS/04_TOOLS/gh_runner/actions-runner-htcondor/run.sh
```

Keep the terminal open while the runner is expected to accept jobs.

The runner should report that it is connected and listening for jobs.

## Validate the workflows

Run the workflows sequentially because one runner listener handles one job at a time.

```bash
# Run and watch CI first.
gh workflow run CI \
  --repo cefect/snakemake-executor-plugin-htcondor \
  --ref main
gh run watch \
  --repo cefect/snakemake-executor-plugin-htcondor

# Run and watch the Docker-based torture test after CI passes.
gh workflow run "Torture Test" \
  --repo cefect/snakemake-executor-plugin-htcondor \
  --ref main
gh run watch \
  --repo cefect/snakemake-executor-plugin-htcondor
```

## Rejected `linstat1` setup

The unregistered runner files staged during investigation must be removed after reviewing the deletion preview.

The exact cleanup roots are:

```text
/home/s/sbryant8/LS/09_REPOS/gh_runners/htcon-plugin-lin1
/tmp/sbryant8/actions-runner-linux-x64-2.338.0.tar.gz
/tmp/sbryant8/gh_runners-work/htcon-plugin-lin1
```

No existing registered runner is included in these roots.
