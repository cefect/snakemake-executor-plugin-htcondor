---
name: upstream-sync-check
description: Check this HTCondor executor plugin fork against upstream/main and summarize commits/PRs not yet merged into our main, with a merge recommendation for each. Use when asked to check upstream, review upstream changes, or see what's new upstream.
---

# Upstream sync check

Compares this fork's `main` branch against `upstream/main` (htcondor/snakemake-executor-plugin-htcondor)
and reports what upstream has that we don't, with a recommendation on whether to merge each item.

## Steps

1. Confirm no worktrees would be affected: `git worktree list`.
2. Fetch upstream: `git fetch upstream`.
3. List commits upstream has that we lack: `git log --oneline main..upstream/main`.
   Also check the reverse (`git log --oneline upstream/main..main`) to note our own divergent commits for context.
4. Group commits into logical units (a PR merge commit + its constituent commits count as one row;
   standalone commits are their own row). Use `git log --format='%H %ad %s' --date=short main..upstream/main`
   to get dates, and `git show --stat <sha>` or `git show <sha>` on a sampling of commits to understand
   the actual change (not just the commit title).
5. For each row, determine:
   - **Date**: commit/merge date.
   - **Description**: concise summary of what changed (feature, fix, refactor, CI-only, etc).
   - **Recommendation**: Merge / Consider / Skip, with a one-line reason. Favor "Merge" for bug fixes and
     safety-relevant changes; "Consider" for features that may conflict with our customizations; "Skip" for
     CI-only, cosmetic, or upstream-infra-specific changes (e.g. their self-hosted runner setup) that don't
     apply to our fork.
6. Cross-reference against our own recent commits (`git log --oneline -10`) and any `README-cef.md` notes
   describing our fork's customizations, to flag anything that would conflict.
7. Output ONLY a markdown table: columns Date | Description | Recommendation. No preamble, no per-PR prose
   outside the table — keep it scannable. Add a one-line note below the table only if something upstream
   looks like it might conflict with our customizations.

## Notes

- Do not merge, rebase, or modify branches as part of this skill — it is read-only/reporting.
- Do not fetch/push to `origin` or make any git history changes.
