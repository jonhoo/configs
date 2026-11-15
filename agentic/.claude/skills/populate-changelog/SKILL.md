---
description: Audit and finalize the [Unreleased] section of CHANGELOG.md before a release
allowed-tools: Bash(jj show:*), Bash(jj log:*), Bash(jj diff:*), Bash(jj file annotate:*), Bash(jj root:*), Bash(git show:*), Bash(git --no-pager show:*), Bash(git blame:*), Bash(git log:*), Bash(git diff:*), Bash(git rev-parse:*), Bash(git symbolic-ref:*), Bash(git tag:*), Bash(git describe:*), Task, Read, Grep, Glob, LSP
---

# Unreleased Changelog Review

Audit and finalize the `[Unreleased]` section of `CHANGELOG.md` before
cutting a new release. This is a content-quality workflow — it validates
existing entries, finds missing ones, tightens wording, and verifies
commit references. It does **not** bump the version, update compare
links, modify `Cargo.toml`, or create tags.

Read the project's `CLAUDE.md` (or equivalent) for any project-specific
changelog conventions before starting. The project may define additional
rules beyond Keep a Changelog.

## Agent management

This workflow uses sub-agents extensively. Follow these rules:

- **All sub-agents are blocking** (not background), so you can review
  their output before proceeding to the next step. Never launch the
  next step's agents until the current step's agents have all completed
  and you have applied their findings.
- **Why sub-agents:** Even for single-review steps, delegate the work
  to a sub-agent so the orchestrator's context stays clean. The
  orchestrator's job is to read agent output, decide what to apply,
  edit `CHANGELOG.md`, and re-read the file before the next step.
- **Fan-out:** Steps 1 and 2 launch multiple agents in parallel (one
  per entry or per category). If there are more than ~10 entries in a
  fan-out step, batch 2–3 per agent to keep agent count manageable.
  Each agent should still evaluate each entry independently and produce
  a separate verdict per entry.
- **Re-read between steps:** After applying changes from any step,
  always re-read `CHANGELOG.md` before starting the next step. The
  file may have changed.

## Changelog entry quality rules

These rules apply throughout. Pass them to sub-agents.

**Mood:** Imperative ("Validate ...", "Reject ..."), not declarative
("Validates ...", "now rejects ..."). Each entry should complete the
sentence "This release will ..." naturally.

**Content:** Describe the user-visible effect, not the implementation
technique.

**Categories** — classify by what the change *is*:
- **Added** — new features, new validations, new warnings, new CLI
  flags. New validations/warnings are Added (new capabilities), not
  Fixed.
- **Changed** — changes to existing functionality.
- **Deprecated** — soon-to-be removed features.
- **Removed** — removed features.
- **Fixed** — actual bug corrections (something was wrong and is now
  right).
- **Security** — vulnerability fixes.

**User-facing filter:** Every entry must earn its place. The changelog
is for users of the library and binary, not for contributors. The
litmus test: "would a user deciding whether to upgrade care about
this?" The following do **not** belong:
- Refactors with no user-visible effect
- Test infrastructure or test-only changes
- CI/CD pipeline changes
- Developer-facing documentation (CLAUDE.md, workflow prompts,
  contributing guides, etc.)
- Issue tracking or project management housekeeping
- Code formatting, clippy/lint fixes, dependency version bumps (unless
  they fix a user-facing bug)
- Changes that only touch non-shipping files (test fixtures, issue
  trackers, dev scripts, etc.)

If an entry mixes user-visible and internal changes, it should be
reworded to focus on the user-visible part only.

**Commit hashes:** Each entry ends with a 7-char short hash in
parentheses: `(abcdef0)`. The hash should be the primary commit — the
one with the most substantive code change, not a follow-up or cleanup.

**Granularity:** One entry per user-visible change. Several commits
may unify under one entry. One commit may produce multiple entries if
it introduces unrelated user-visible changes.

## Procedure

### Step 0: Determine the commit range

The commit range defines "since last release" — the set of commits
whose changes should be reflected in `[Unreleased]`.

1. Read `CHANGELOG.md` and extract the tag from the `[Unreleased]`
   compare link at the bottom. The line looks like:
   ```
   [Unreleased]: https://github.com/.../compare/TAG...HEAD
   ```
   Extract `TAG` (everything between `compare/` and `...HEAD`).

2. Check if the tag exists locally: `git tag -l 'TAG'`

3. **If the tag exists**, the range is `TAG..HEAD`.

4. **If the tag does not exist**, find the boundary commit:
   - Try the most recent "Release" commit:
     `git log --oneline --grep="^Release" --format="%H %s" -1`
   - Or fall back to the latest existing tag:
     `git describe --tags --abbrev=0`
   - The range is then `<boundary>..HEAD`.

5. Verify the range: `git log --oneline RANGE`. Every commit hash
   already cited in `[Unreleased]` entries should appear.

6. Store two values for the rest of the workflow:
   - `RANGE` — the range string (e.g., `v0.1.4+1.12.1..HEAD`)
   - `LOG` — the full `git log --oneline RANGE` output

### Step 1: Validate existing entries

For every entry in the `[Unreleased]` section that has content, launch
one blocking sub-agent to investigate whether the entry accurately
summarizes the change it references.

Skip categories with no entries — step 2 will check for missing ones.

**Sub-agent prompt template:**

> You are validating a single changelog entry.
>
> **Entry under review (from the `SECTION` section):**
> ```
> ENTRY_TEXT
> ```
>
> **Commit hash referenced:** `HASH` (or "none" if no hash present)
>
> **Commit range for this release:** `RANGE`
> **Full commit log for this range:**
> ```
> LOG
> ```
>
> Read the project's `CLAUDE.md` for changelog conventions (if it
> exists).
>
> Your task:
> 1. If a hash is present, run `git show HASH` to read the full
>    commit message and diff.
> 2. Determine whether the entry text accurately summarizes the
>    user-visible effect of that commit.
> 3. Check whether the entry is in the correct category (Added,
>    Changed, Fixed, etc.). New validations and warnings are **Added**
>    (new capabilities), not Fixed. Actual bug corrections are
>    **Fixed**.
> 4. Check whether the entry uses imperative mood.
> 5. Check whether the entry describes the user-visible effect, not
>    the implementation technique.
> 6. If the commit touches several unrelated things, verify the entry
>    accurately describes the part it claims to.
>
> **Output format:**
> ```
> ### Entry: "FIRST_LINE_OF_ENTRY..."
> - **Section:** SECTION
> - **Verdict:** ACCURATE | NEEDS-REWORDING | WRONG-SECTION | INACCURATE
> - **Issues found:** (list, or "none")
> - **Suggested replacement:** (full entry text if verdict is not ACCURATE)
> - **Suggested section:** (if WRONG-SECTION)
> - **Reasoning:** (brief explanation)
> ```

**After agents complete:** Review all outputs. For each entry with a
verdict other than ACCURATE, evaluate the suggestion and apply it to
`CHANGELOG.md` if you agree. Use judgment — the agent may be wrong.
Re-read `CHANGELOG.md` before proceeding.

### Step 2: Find missing entries

For each of the 6 changelog categories, launch one blocking sub-agent
to find commits in the range that represent user-visible changes not
covered by existing entries. Launch all 6 in parallel.

**Sub-agent prompt template:**

> You are looking for missing changelog entries in the **SECTION**
> category.
>
> **Category definition (per Keep a Changelog):**
> - **Added**: new features
> - **Changed**: changes in existing functionality
> - **Deprecated**: soon-to-be removed features
> - **Removed**: now removed features
> - **Fixed**: bug fixes
> - **Security**: vulnerability fixes
>
> **Current entries in this category:**
> ```
> EXISTING_ENTRIES (or "none")
> ```
>
> **Commit range:** `RANGE`
>
> Read the project's `CLAUDE.md` for changelog conventions (if it
> exists). Key rules:
> - Only user-facing changes belong. Internal changes (test infra, CI,
>   issue tracking, formatting, dev scripts) do not.
> - The litmus test: "would a user deciding whether to upgrade care?"
> - Entries need not map 1:1 to commits.
> - Each entry references a primary commit hash at the end.
>
> Your task:
> 1. Run `git log --oneline RANGE` to see all commits.
> 2. For each commit, run `git show --stat HASH` to see what files
>    changed. Skip commits that only touch test-only files, CI
>    configs, issue trackers, documentation, or dev scripts — unless
>    the change reflects a user-visible behavior change.
> 3. For commits that touch source code, config files, or build
>    manifests, run `git show HASH` to read the full diff and message.
> 4. Determine whether any of these commits represent user-visible
>    changes in the **SECTION** category not already covered.
> 5. Draft entries in imperative mood with the primary commit hash.
>
> **Output format:**
> ```
> ### Category: SECTION
> - **Missing entries found:** N
> - **Entry 1:** "Draft entry text (HASH)"
>   - **Commits:** HASH1, HASH2, ...
>   - **Reasoning:** why this belongs in SECTION
> - **Entry 2:** ...
> (or "No missing entries found.")
> ```
>
> Remember: refactors, test additions, CI changes, documentation
> updates, and housekeeping are NOT user-facing.

**After agents complete:** Review all suggestions. Add entries you
agree with. Reject entries that are not genuinely user-facing. If an
agent suggests an entry that overlaps with an existing one, consider
expanding the existing entry rather than adding a new one. Re-read
`CHANGELOG.md` before proceeding.

### Step 3: Deduplicate, re-sort, and filter

Delegate to one blocking sub-agent.

> Review the `[Unreleased]` section of `CHANGELOG.md` for
> deduplication, sorting, and filtering.
>
> Read `CHANGELOG.md` and the project's `CLAUDE.md` (if it exists).
>
> Check for:
>
> 1. **Duplicate entries**: Two entries describing the same change,
>    possibly worded differently or referencing different commits from
>    the same logical change. Recommend merging them, keeping the best
>    wording and most representative commit hash.
>
> 2. **Misplaced entries**: An entry in Fixed that is really a new
>    capability (belongs in Added), or in Added that is really a
>    change to existing behavior (belongs in Changed).
>
> 3. **Entries that don't earn their place**: Flag any entry that
>    describes a refactor with no user-visible effect, test-only
>    changes, CI/CD changes, developer documentation, issue tracking,
>    code formatting, or lint fixes. The changelog is for users, not
>    contributors. Apply the litmus test: "would a user deciding
>    whether to upgrade care about this?" Also flag entries that mix
>    user-visible and internal changes — recommend rewording to focus
>    on the user-visible part.
>
> 4. **Sort order within categories**: Entries should be ordered by
>    significance (most important first), not chronologically. Group
>    related entries together.
>
> 5. **Entry granularity**: Multiple small entries describing facets
>    of the same user-visible change should be unified. One entry
>    describing multiple unrelated changes should be split.
>
> For each recommendation, state what to change (merge, move, remove,
> reorder, split), the current entry text(s), the suggested result,
> and reasoning. If no changes are needed, say so explicitly.

**After the agent completes:** Apply agreed changes. Re-read before
proceeding.

### Step 4: Consistency and style check

Delegate to one blocking sub-agent.

> Review the `[Unreleased]` section of `CHANGELOG.md` for consistency
> with the rest of the changelog and with Keep a Changelog.
>
> Read the full `CHANGELOG.md` and the project's `CLAUDE.md` (if it
> exists).
>
> Compare the `[Unreleased]` section against the released versions
> for:
> 1. **Capitalization and punctuation** — entries start with a capital
>    letter? No trailing period? Consistent with prior releases?
> 2. **Level of detail** — roughly the same length and depth as prior
>    releases?
> 3. **Imperative mood** — "Validate ...", not "Validates ..."?
> 4. **Commit hash format** — `(abcdef0)` at end of each line, 7 hex
>    characters, in parentheses?
> 5. **Entry length** — not wildly longer or shorter than prior
>    releases?
> 6. **Section headings** — all 6 categories present under
>    `[Unreleased]`?
> 7. **Backward references** — when an entry fixes a regression from
>    or improves a feature in a recent release, does it include a
>    brief parenthetical reference like "(introduced in 0.1.3)"?
>    Only recommend these when they genuinely help the reader.
>
> List observations with what was observed, which entries it affects,
> and suggested fixes. If the section is consistent, say so.

**After the agent completes:** Apply style fixes. Re-read before
proceeding.

### Step 5: Validate commit hashes

For every entry in `[Unreleased]` that ends with a commit hash, launch
one blocking sub-agent to verify the hash. For entries missing hashes,
launch an agent to find the primary commit.

**Sub-agent prompt for hash validation:**

> You are validating that a commit hash is appropriate for its
> changelog entry.
>
> **Entry (from the `SECTION` category):**
> ```
> ENTRY_TEXT
> ```
>
> **Commit hash:** `HASH`
>
> **Commit range for this release:** `RANGE`
> **Full commit log for this range:**
> ```
> LOG
> ```
>
> Your task:
> 1. Run `git show HASH` to read the full commit.
> 2. Verify the hash resolves to a real commit.
> 3. Verify the commit falls within the release range.
> 4. Verify the commit's changes match the entry. It should be the
>    *primary* commit — the most substantive code change, not a
>    follow-up or cleanup.
> 5. If the hash is wrong, search the range for a better candidate.
>
> **Output format:**
> ```
> ### Entry: "FIRST_LINE_OF_ENTRY..."
> - **Hash:** HASH
> - **Verdict:** VALID | WRONG-COMMIT | OUT-OF-RANGE | INVALID-HASH
> - **Issues found:** (list, or "none")
> - **Suggested replacement:** HASH (if verdict is not VALID)
> - **Reasoning:** (brief explanation)
> ```

**Sub-agent prompt for finding missing hashes:**

> You are finding the primary commit hash for a changelog entry.
>
> **Entry (from the `SECTION` category):**
> ```
> ENTRY_TEXT
> ```
>
> **Commit range:** `RANGE`
> **Full commit log for this range:**
> ```
> LOG
> ```
>
> Your task:
> 1. Search the commit log for the commit that best represents this
>    entry.
> 2. Use `git log --all --grep="KEYWORD"` for keyword searches, and
>    `git show HASH` to inspect candidates.
> 3. The "primary commit" is the one that most fully represents the
>    change. If the change spans multiple commits, pick the one with
>    the most substantive code change.
>
> **Output format:**
> ```
> ### Entry: "FIRST_LINE_OF_ENTRY..."
> - **Primary commit:** HASH
> - **Commit subject:** (the commit's subject line)
> - **Confidence:** HIGH | MEDIUM | LOW
> - **Reasoning:** why this commit was chosen
> ```

**After agents complete:** For VALID hashes, no action needed. For
WRONG-COMMIT, evaluate the suggestion and swap if appropriate. For
OUT-OF-RANGE, investigate whether the entry belongs in a prior
release. For INVALID-HASH, find the correct hash. For missing-hash
agents, add the hash for HIGH/MEDIUM confidence; investigate manually
for LOW. Re-read `CHANGELOG.md`.

### Step 6: Final verification

Run this checklist after all steps are complete:

1. **Every entry has a commit hash** — each bullet ends with
   `(HASH)`, 7 hex characters.
2. **Every commit hash is valid** — `git rev-parse --short HASH`
   resolves for each.
3. **Every commit hash is in range** —
   `git log --oneline RANGE | grep HASH` matches for each.
4. **All 6 category headings present** under `[Unreleased]`, even if
   empty.
5. **Imperative mood** — re-read each entry. Does it complete "This
   release will ..." naturally?
6. **User-facing** — for each entry, "would a user deciding whether
   to upgrade care?" If no, remove it.
7. **Compare link is correct** — the `[Unreleased]` link at the
   bottom points to `compare/TAG...HEAD` where TAG is the most recent
   release tag.
8. **Coherent release note** — read the final section as a whole.
   Does it tell a clear story? Are the most important changes
   prominent?
