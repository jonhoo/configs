---
name: append-to-changelog
description: Updates a project's CHANGELOG.md to reflect noteworthy user-facing changes
allowed-tools: Bash(jj show:*), Bash(jj log:*), Bash(jj diff:*), Bash(jj file annotate:*), Bash(jj root:*), Bash(git show:*), Bash(git --no-pager show:*), Bash(git blame:*), Bash(git log:*), Bash(git diff:*), Bash(git rev-parse:*), Bash(git symbolic-ref:*), Task, Read, Grep, Glob, LSP
---

# Changelog Entry Writer

Write changelog entries for the current change, following
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) conventions and
any project-specific guidelines (check `CLAUDE.md` or equivalent).

## Procedure

### Step 1: Determine VCS and inspect the change

Detect jj vs git:
```bash
jj root 2>/dev/null && echo "jj" || echo "git"
```

Read the diff and commit message for the change in question. If the user
passed arguments to the skill (e.g., a commit hash or revision), use those.
Otherwise default to the most recent change:

**jj:** `jj show --git --no-pager -r @-`
**git:** `git show HEAD` (or `git diff --staged` for uncommitted work)

### Step 2: Decide if the change is user-facing

Apply the "earn their place" filter. The changelog is for **users of the
library and binary**, not for contributors. The litmus test: "would a user
deciding whether to upgrade care about this?"

The following categories of changes do **not** get entries:
- Refactors with no user-visible effect
- Test infrastructure or test-only changes
- CI/CD pipeline changes
- Developer-facing documentation (README contributing guides,
  workflow prompts, CLAUDE.md, etc.)
- Issue tracking or project management housekeeping
- Code formatting, clippy/lint fixes, dependency version bumps
  (unless they fix a user-facing bug)
- Changes that only touch non-shipping files (test fixtures, issue
  trackers, dev scripts, etc.)

If the change mixes user-visible and internal work, write the entry about
the user-visible part only.

If the change is purely internal, tell the user it does not warrant a
changelog entry and explain why. Stop here.

### Step 3: Check existing [Unreleased] entries

Read `CHANGELOG.md` and examine the `[Unreleased]` section. Check whether
an existing entry already describes this change. If so:
- Suggest **expanding** the existing entry rather than adding a duplicate.
- If multiple existing entries describe facets of the same user-visible
  change, suggest **unifying** them into one.

### Step 4: Draft the entry

Write the entry following these rules:

**Mood:** Imperative ("Validate ...", "Reject ..."), not declarative
("Validates ...", "now rejects ..."). The entry should complete the
sentence "This release will ..." naturally.

**Content:** Describe the **user-visible effect**, not the implementation
technique. E.g., "Render all errors with colored, annotated source
excerpts" rather than "Use miette diagnostic rendering for all error
output".

**Category:** Place the entry under the correct heading based on what the
change *is*, not what code it touches:
- **Added** — new features, new validations, new warnings, new CLI flags.
  Note: new validations and warnings count as Added (they are new
  capabilities), not Fixed.
- **Changed** — changes to existing functionality.
- **Deprecated** — soon-to-be removed features.
- **Removed** — removed features.
- **Fixed** — actual bug corrections (something was wrong before and is
  now right).
- **Security** — vulnerability fixes.

**Granularity:** One entry per user-visible change. Several commits may
unify under one entry when they contribute to a single change. Conversely,
if a commit introduces multiple unrelated user-visible changes, write
separate entries.

**Commit hash:** End the entry with the primary commit's 7-char short hash
in parentheses: `(abcdef0)`. The "primary commit" is the one with the most
substantive code change for this entry, not a follow-up or cleanup.

**Backward references:** When the change fixes a regression from or
improves a feature introduced in a recent version, consider a brief
parenthetical reference like "(introduced in 0.1.3)" to help readers
understand the context. Only add these when they genuinely help — most
entries will not need them.

### Step 5: Place and consistency-check the entry

**Placement:** Within a category, order entries by significance (most
important first), not chronologically. Place the new entry where it
belongs relative to existing entries — don't just append to the end.

**Consistency:** Compare the drafted entry against existing entries in
`CHANGELOG.md` for:
- Capitalization — entries start with a capital letter
- Punctuation — no trailing period
- Detail level — roughly the same length and depth as existing entries
- Commit hash format — `(abcdef0)` at end of line, 7 hex characters,
  in parentheses

Adjust if the new entry is stylistically inconsistent with the rest of
the changelog.

### Step 6: Apply the edit

Add the entry to `CHANGELOG.md` under the appropriate heading in the
`[Unreleased]` section. Preserve all 6 category headings even if empty
(the `[Unreleased]` section always retains all six).
