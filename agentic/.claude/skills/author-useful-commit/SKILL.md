---
name: author-useful-commit
description: Write effective commit messages that explain why changes were made. Use when creating commits, reviewing commit quality, or writing PR descriptions.
---

# Writing effective commit messages

Good commit messages are force multipliers for maintainability.
When you return to code months later—or when a teammate encounters a confusing change—a well-crafted commit message explains not just _what_ changed,
but _why_ it changed and what implications that creates.
When in doubt,
ask yourself:
"If I encountered this change while debugging in six months,
what would I want to know?"
Then write that.

## Apply this guidance to permanent history commits

These guidelines target commits that become part of the permanent, shared history of the main branch of your repository.
They're for when someone inevitably runs `git blame`
in the hopes of understanding some piece of the code,
with most of the context and MR discussion lost to time.

This guidance is _not_ intended for the small checkpoint commits as you iterate on a feature or fix.
There, you should write whatever helps you keep track of progress and remaining work.
It's when you squash those commits into a change intended for merging that you should make use of this guide.
The resulting commit should then also be able to serve as your MR description.

## Commit messages answer "why would I care?"

The fundamental shift in thinking is that
your commit message isn't primarily documentation of what you did.
It's an explanation to your future self (or a confused teammate)
about why this change exists and what they need to know about it.

**Consequences of good commit messages:**
- Debugging becomes archaeological investigation with clear historical context
- Code review focuses on actual design decisions rather than "what were you trying to do?"
- Onboarding new developers means they can trace the reasoning behind architectural choices
- Reverting changes includes understanding what will break when you do

**Consequences of poor commit messages:**
- Hours wasted reconstructing intent from diff hunks
- Design decisions lost to time, leading to repeated mistakes
- Code archaeology requires asking people who may have left the organization

## Structure your commits with subject and body

### The subject line sets expectations

Prefer imperative mood, present tense, as if completing the sentence "This commit will...".
This is consistent with how git itself writes commit messages for `git merge` and `git revert`:

**Strong examples:**
```
Add priority field to Identifier
Mitigate bandwidth measurement race condition
Remove unused AliveMap type
Make Identifier opaque to prevent misuse
```

**Weak examples (avoid these):**
```
fix                  ← Fixed what? Where?
Updated code         ← Too vague to be useful
Refactoring          ← What did you refactor and why?
Changes              ← This applies to every commit
```

_Specificity matters._
"Fix stack overflow in quickcheck shrink impl for Ops" beats "Fix bug in tests"
because it helps future searches and gives immediate context.

There are some standard conventions that apply to all commit titles:

- Sentence case (specifically, never Title Case)
- No period at the end
- Target under 50 characters when possible, though clarity trumps brevity
- Describe the change at the level of *what problem it solves*, not mechanical details

> **An aside on Conventional Commits.**
> [Conventional Commits](https://www.conventionalcommits.org/) add optional prefixes like `feat:`, `fix:`, or `refactor:` to commit titles.
> The text following the prefix should still conform to all the guidance above—imperative mood, specific and clear, focused on what problem it solves.
> Some teams find these prefixes helpful for automated changelog generation and semantic versioning,
> particularly in Rust projects with libraries.
> Others find the prefixes add little value when the subject line is already well-written.
> Use them if your project or team benefits from the tooling they enable,
> but don't feel obligated to adopt them.

### The body explains rationale and implications

Most non-trivial commits benefit from a body
that explains the "why" behind the change.
You'll want to separate the subject from the body with a blank line
as many git tools treat that first line as a special "subject".
Prefer wrapping body text around 72 characters to maintain readability in terminal output.

The body should answer:

- What problem forced this change?
- What alternatives did you consider?
- What are the implications or trade-offs?
- What might be surprising about this approach?
- How does this relate to other work?
- How was this change tested or validated?

You're writing for someone debugging this code at 2am in six months.
That person might be you.

> An aside on terminology: respect the reader's intelligence.
> Use precise technical terms without over-explaining basics the reader will already be familiar with if they're in this code-base.
> Focus explanation on what's _surprising_ about how you're using them.

### Treat git commit messages as Markdown

While commit messages aren't usually rendered as Markdown,
developers are familiar enough with reading Markdown that you still gain richness by re-using its conventions.

For example, code-related terms
(types, function/variable names, inline code expressions, etc.)
belong in backticks to visually distinguish them from surrounding prose
and to render them better as Markdown.

Multi-line code should be placed in indented blocks to better visually distinguish them from surrounding text
and to mimic what readers are used to seeing in Markdown text.
Links should use `[]` Markdown syntax, and so on.

```
When showing actual code snippets, indent them:

    let dot_id = DotId {
        actor: &self.actor,
        count: self.count,
    };
```

Prefer indenting code blocks to make them more visually distinct in `git log` and `git show`.
Code blocks are exempt from the 72-character line length guideline—don't wrap compiler errors, log excerpts, or code snippets.


## Follow the Problem→Solution→Implications pattern for complex changes

For architectural changes or non-obvious solutions,
structure your commit message
to walk the reader through your reasoning:

### Exemplary commit

```
Move Identifier out of CausalContext

The main motivating factor for this change is to allow choosing priority
for each CRDT change, which requires changing the `Identifier` (as
that's where we're storing priority). Currently, the `Identifier` is
stored within `CausalContext`, but since we generally pass around
`&CausalContext`, it's not possible to change the `Identifier` without
cloning the entire context.

This change makes `Identifier` fully opaque (just as `ActorId` is), and
separates "the thing that stores actor + count + priority" (still called
`Identifier`) from "the thing that uses references to those" (now called
`DotId`). All the CRDT methods change to take `impl Into<DotId<'_>>`,
which allows both `&Identifier` and `Identifier` (by value), eliminating
the need to clone.

There are a few noteworthy implications:

- `DotStore` is now object-safe since it has no generic methods \o/
- _Way_ fewer generics since all the imposed `<I>` bounds are now just
  using the concrete `Identifier` and `DotId` types.
- Most of the generics left are those needed to support both immutable
  and mutable references to underlying data stores.
```

**Structure breakdown:**
1. **Problem statement** - Start with the forcing function or limitation
2. **Solution description** - Explain what changed and the key design decision
3. **Implications enumeration** - List noteworthy consequences (positive or negative)

This pattern gives readers context before details,
making the commit message readable even if they skip the diff entirely.

## Acknowledge trade-offs and downsides explicitly

Real engineering involves balancing competing concerns.
When you make a choice that has downsides,
document them.
This shows thoughtfulness and
helps future maintainers understand whether those trade-offs still make sense.

Explicitly documenting trade-offs prevents future developers
from thinking "they must have missed this problem"
when encountering the limitation.
It shows the problem was considered and the trade-off was intentional.
Make sure to explain _why_ the trade-off was acceptable given the context.

## Link to contextual information

Connect your commit to the broader project ecosystem.
This may be links to tickets or MRs, hashes of related commits, or links to Slack conversations.
These references create a trail of breadcrumbs.
When someone encounters a confusing change,
they can follow links to discussions,
original requirements,
or related work that provides additional context.

> **An aside on ephemeral links.**
> Links to MRs and Slack conversations may eventually become unavailable,
> but they're still worth including.
> A link that resolves is valuable context;
> a link that's expired is no worse than having no link at all.
> Include them as best-effort supplementary context,
> not as replacements for explaining the change in the commit message itself.

## Scale detail with complexity

Not every commit needs a dissertation.
Match your message length to the change's complexity and non-obviousness.

### Simple changes get simple messages:

**One-line subjects (no body needed):**
```
Set up renovate
Upgrade to hyper 1.0
Use ahash for faster HashMaps in DSON
Make capitalization of error messages consistent
```

These changes are self-explanatory from the subject + diff.
Adding a body would be padding.

### Medium complexity gets targeted explanation:

**Subject + 2-3 sentence body (~100-200 words):**
```
Mitigate measurement race condition(s)

The bandwidth tracker updates its measurements based on wall-clock time,
but multiple operations could check the time, see it had advanced, and
each try to update the rate estimate. This produced nonsensical values.
Now we ensure only one update happens per time advancement.
```

### High complexity gets comprehensive rationale:

**Subject + multi-paragraph body (500+ words):**

For architectural changes,
API redesigns,
or subtle bug fixes,
invest in explaining your reasoning.
These commits benefit from the full Problem→Solution→Implications structure
with explicit trade-off discussion.

**The heuristic:**
If someone reading the diff would ask "but why this approach?",
you need a body.
If the diff fully explains the change,
the subject alone may suffice.

## Commit messages document changes, not nuanced behaviour

Commit messages explain why behaviour _changed_,
not _how the resulting behaviour works_.
Detailed documentation of tricky implementation details belongs in the code itself,
where maintainers will actually see it when working on that logic.

When implementation details are particularly subtle or
involve important trade-offs,
use in-code decision records like
[YADRs](https://github.com/helsing-ai/yadr).
These are Y-statement style architecture decision records
placed directly in code comments near the relevant implementation.

### Exemplary commit

```
Remove AliveMap

This significantly reduces the extraneous metadata that must be
transmitted in CRDT updates. Specifically, we no longer need to include
an update for every nesting level of an update, just for the updated
field itself.

The downside of this change is that we can no longer distinguish unset
and empty collections (arrays and maps). This in turn means that setting
an array to empty means it is omitted from the parent structure entirely
(ie, the parent field isn't even mentioned in the resulting delta).

For our purposes, this isn't much of an issue since our schemas should
take care of interpreting missing collection fields as empty by virtue
of our use of `#[serde(default)]`.

More detail is given in the included YADR.
```

Notice the final line:
**"More detail is given in the included YADR."**
The commit message covers what changed and why it was acceptable,
but defers the nuanced implementation details to a YADR in the code itself.

That YADR provides the deeper context:

```rust
/*
 * YADR: 2024-05-06 Removal of `.alive` tracking
 *
 * In the context of DSON's ability to represent empty collections (maps
 * and arrays), we faced a question of whether to accept the significant
 * number of extra updates supporting such collections cause to _all_ map
 * and array operations due to the requisite write of the `.alive` field.
 *
 * We decided for removing the ability to represent empty collections by
 * removing all use of the `.alive` field, and neglected keeping the DSON
 * implementation in line with the original paper (which does support such
 * collections).
 *
 * ...
 */
```

The code comment explains the decision trade-offs in depth and
documents implementation details that future maintainers need
when modifying that code.
This lives where someone working on the implementation will see it,
not buried in git history.

**What belongs in commit messages:**
- Why you made this change now (the forcing function)
- What problem it solves or what requirement it addresses
- A summary of the approach taken
- What trade-offs this change introduces at a high level
- How this relates to other changes or tickets
- A pointer to in-code documentation for deeper details
- Guidance for how to review or how the MR has been broken up

**What belongs in code (via comments, YADRs, or documentation):**
- The full decision-making process for architectural choices
- Detailed analysis of alternatives considered and rejected
- Mathematical or logical proofs of correctness
- Complex algorithms and why specific approaches were chosen
- Subtle invariants, edge cases, and corner case handling
- Long-term implications that affect future modifications

## Express honest uncertainty when appropriate

Not every change comes with complete confidence.
When you're making educated guesses or working with incomplete information,
acknowledge that.
This way, future developers know which assumptions to question when debugging.
Honest uncertainty is more useful than false confidence.

This includes highlighting things you know are broken or incomplete.
Hiding problems doesn't make them disappear.
It just makes future developers think you didn't notice them,
which erodes trust in the codebase's thoughtfulness.


## Highlight drive-by changes

When you fix unrelated issues while working on something else, acknowledge them.
This helps reviewers understand scope and prevents "why is this random thing in here?" questions.
Or, better yet, separate them out as separate commits (and MRs).

## Common pitfalls to avoid

### Writing for yourself today instead of readers tomorrow

The worst commit messages assume readers have the context you have now.
Future you (and your teammates) won't remember why the change was needed,
what trade-offs seemed obvious,
or what problem you were solving.
Write as if explaining to a teammate who just joined the project:
what context do they need to understand both the change and the reasoning behind it?

### Confusing commands with explanations

Avoid commit messages that sound like instructions rather than historical records:

```
Always use ahash     ← This is a rule, not an explanation
Never clone context  ← Why? What happens if I do?
```

When you encounter code that violates these "rules" later,
you won't know if it's a bug or an intentional exception.

### Misplaced minimalism

Some developers pride themselves on one-line commit messages.
This is misplaced minimalism.
The goal isn't brevity—it's *clarity*.

A 500-word commit message for a 5-line change is appropriate
_if those 5 lines resolve a subtle race condition that took hours to debug._
Your explanation pays dividends across every future reader.

A 10-word commit message for a 500-line change is probably insufficient
unless it's pure mechanical refactoring
(and even then, explaining *why* you refactored helps).
