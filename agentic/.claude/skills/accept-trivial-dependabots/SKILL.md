---
name: accept-trivial-dependabots
description: Finds and merges dependabot PRs that do not change anything major or surprising. Well suited to run in a loop.
allowed-tools: Bash(gh:*), Bash(jq:*), Bash(grep:*), Agent, ScheduleWakeup, ToolSearch, Read, Write, PushNotification
---

Check my GitHub notifications for dependabot PRs that only do
minor/patch version bumps and that are not currently awaiting a
dependabot rebase. 0.x -> 0.y should be considered a major bump. Include
any repositories that I own, as well as any PRs that appear in my
notifications that I also have merge permissions on.

Ignore the following projects as they are not actively maintained:

- msql-srv
- griddle
- rust-imap


For each project, pick one of those PRs where all CI jobs pass (there
must be at least one CI job) and start a sub-agent for it. That agent
should look through the changes noted by dependabot in depth and if
there is nothing surprising or controversial in there, leave a comment
saying

> I asked Claude to approve and merge dependabot MRs with only minor
> updates and no 'surprising' changes, and this matches, so 🚀

Then approve and squash-merge the PR.

Here are a few things *not* considered surprising, blocking, or major:

- Bumping the MSRV of a dev-dependency.
- Bumping the hash of dtolnay/rust-toolchain.

If an agent sees CI jobs fail due to `dist plan` complaining about a
diff, this is because dependabot is trying to update a GitHub action
that is used in a GitHub workflow that is managed by
https://axodotdev.github.io/cargo-dist/. If all the PR changes are in
the files managed by `dist`, close the PR with a comment saying

> This GitHub Action is used in a workflow managed by dist, so should
> only be updated by virtue of updating dist.

You may then inform the user that they should update their version of
dist if what's listed as `cargo-dist-version` in `dist-workspace.toml`
is out of date. If some PR changes are in dist-managed files and others
are not, highlight to the user that they will need to manually split
that update.


If this prompt is used in a loop, it is because when one dependabot PR
is merged for a given project, any other dependabot PRs on the same
project will need to be rebased and re-run CI, so only a later scan will
find more PRs worth addressing.

At the end (if in loop mode: at the end of each loop), give a concise
overview of dependabot PRs that were deemed surprising (and why), that
have failing (or missing) CI, or that involve major version bumps.

Prefer using the GitHub MCP over `gh` where possible, though note that
it is usually only feasible to use for read-only operations. Make
sub-agents aware that `gh` cannot be run inside the sandbox.
