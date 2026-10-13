# cef's README
.gitignored

cef's fork of the snakemake-executor-plugin-htcondor plugin

switched to working on `main` for workflows

- CHTC's fork [upstream](https://github.com/htcondor/snakemake-executor-plugin-htcondor)

list branches:
```bash
git branch -r --list 'upstream/*'
```

compare changes of upstream/main against ours (deploy)
```bash
git fetch upstream main
git diff upstream/main
```

synchronize upstream main against origin/main
```bash
git fetch upstream main

git merge upstream/main
```

## setup

### GH Actions

This fork has four workflows: `CI`, `Torture Test`, `Tag -> prerelease -> TestPyPI`, and `Publish to PyPI`.
`CI` and `Torture Test` use the local runner only when the `SELF_HOSTED_RUNNER_LABEL` repository variable is set; otherwise they use `ubuntu-latest`.

- `CI`: Runs pre-commit checks, submits a basic HTCondor job, and runs the unit and integration tests with coverage.
- `Torture Test`: Builds a central manager, Access Point, and Execution Point pool to test file transfer and partial shared-filesystem behavior.
- `Tag -> prerelease -> TestPyPI`: Validates a version tag, creates a prerelease, builds the package, and publishes it to TestPyPI.
- `Publish to PyPI`: Builds the package and publishes it to PyPI when a prerelease is promoted to a release.

setup: see `/home/cefect/LS/09_REPOS/04_TOOLS/gh_runner/readme.md`

Runner configuration adds the default `self-hosted`, `Linux`, and `X64` labels.
Set the repository Actions variable `SELF_HOSTED_RUNNER_LABEL` to `self-hosted`.

use:

```bash
/home/cefect/LS/09_REPOS/04_TOOLS/gh_runner/actions-runner-htcondor/run.sh
```

Keep that terminal open while workflows run.
Wait for `Listening for Jobs` before dispatching workflows.

If startup reports `The runner registration has been deleted from the server`, re-register the existing installation.
GitHub can [remove inactive runners automatically](https://docs.github.com/en/actions/how-tos/manage-runners/self-hosted-runners/remove-runners).
The installed runner version `2.337.0` supports `config.sh remove --local` to clear stale local configuration.

1. Preview the local configuration files and review the paths before clearing configuration:

```bash
# Inspect paths only; do not display credential contents.
cd /home/cefect/LS/09_REPOS/04_TOOLS/gh_runner/actions-runner-htcondor
find .runner .credentials .credentials_rsaparams -depth -type f -print
```

2. After reviewing those paths, clear the stale local configuration:

```bash
# Clear local registration; preserve the installed runner and work directory.
./config.sh remove --local
```

3. Open [repository runner settings](https://github.com/cefect/snakemake-executor-plugin-htcondor/settings/actions/runners/new), select Linux / x64, and obtain a fresh registration token.
Use the existing installation; enter the token at the interactive prompt below rather than storing it in this README.

```bash
# Register interactively, accepting the default name and work directory.
./config.sh --url https://github.com/cefect/snakemake-executor-plugin-htcondor
# Start the runner and keep this terminal open.
./run.sh
```

4. In another terminal, verify that GitHub reports `online`:

```bash
# Confirm registration and online status before dispatching workflows.
gh api repos/cefect/snakemake-executor-plugin-htcondor/actions/runners \
  --jq '.runners[] | {name,status,busy,labels:[.labels[].name]}'
```

Trigger the test workflows from the repository default branch with:

```bash
gh workflow run CI --repo cefect/snakemake-executor-plugin-htcondor --ref main
gh workflow run "Torture Test" --repo cefect/snakemake-executor-plugin-htcondor --ref main
```

Watch the newest run with:

```bash
gh run watch --repo cefect/snakemake-executor-plugin-htcondor
```
 
## publish a new tag

get the name of all tags on the repo:
```bash
git tag -l
```
create and push a new tag:
```bash
git tag -a v2026.08.28 -m "v2026.08.28"
git push origin v2026.08.28
```
