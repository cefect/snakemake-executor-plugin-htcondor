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

The current local runner has the default `self-hosted`, `Linux`, and `X64` labels only.
Set the repository Actions variable `SELF_HOSTED_RUNNER_LABEL` to `self-hosted`.

use:

```bash
/home/cefect/LS/09_REPOS/04_TOOLS/gh_runner/actions-runner-htcondor/run.sh
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
