---
name: guide-technical-writing
description: Apply when writing technical documentation, guides, tutorials, educational content, or any extended technical prose. Emphasizes clear voice, real consequences over abstractions, guidance over commands, and showing progression from acceptable to optimal approaches.
---

# Writing style and teaching guidelines

This document captures writing and teaching patterns that have a proven track-record.
Use this guidance when creating technical documentation,
guidelines,
or educational content.

## Why this matters

**Poor technical writing has real costs.**
When documentation is unclear or prescriptive without explanation:

- **Readers waste time** deciphering what you meant instead of applying what you taught
- **Teams make wrong decisions** because they followed rules without understanding trade-offs
- **Knowledge doesn't transfer**—people can't adapt guidance to their specific context
- **Maintainers struggle** when they inherit code following patterns they don't understand

Good technical writing respects the reader's intelligence,
explains the reasoning behind recommendations,
and acknowledges that different contexts require different approaches.

## Context-dependent application

Different document types need different approaches.
These guidelines apply most strongly to:
- **Conceptual guides** teaching philosophy or approach
- **Best practice documents** explaining recommendations
- **Educational content** meant to build understanding

They apply less to:
- **API reference** (which needs to be comprehensive and findable, not narrative)
- **Tutorials** (which need more explicit steps)
- **Quick references** (where listing items is the point)

Even within a single document,
different sections might need different treatment.
An introductory "why" section benefits from narrative flow,
while a "common patterns" reference section might legitimately use a bulleted list.

The key is being intentional:
understand _why_ these patterns work,
so you know when to apply them and when other approaches serve readers better.

## Voice and tone

### Highlight the real consequences

Lead with visceral,
concrete impact before diving into technical details.
Instead of listing generic problems ("service disruption", "data loss"),
paint the picture:
"planes crash, defences fail, people die."

Ground every concept in _why it matters in practice_,
not just what it is theoretically.
Exemplifying the implications through lived experience or likely resulting situations tends to be useful.

This doesn't mean being alarmist.
It means respecting that readers need to understand stakes to make good decisions.

Note that this applies at every level of the document,
not just the initial scope and motivation section.

### Guide, don't command

Prefer advisory language ("prefer", "consider", "often better") over absolutes ("always", "never", "must").
Frame recommendations as _guidance to internalize and apply thoughtfully_,
not rules to follow blindly.
Allow room for judgment and context;
state principles and let readers determine how to apply them,
rather than prescribing specific implementation techniques.

> The exception to this is if you're writing a normative technical specification.
> In that case, use the formalized terms from [RFC2119](https://datatracker.ietf.org/doc/html/rfc2119).

Even when giving direct guidance,
speak _to_ the reader rather than at them.
The goal is to sound like a peer offering advice,
not an authority issuing orders.
"You want to avoid academic vocabulary" feels collaborative;
"avoid academic vocabulary" feels commanding.
Section headings are an exception—bare statements or imperatives work fine there.

Example transformation:
- Before: "In production code: always use `expect()`, never `unwrap()`"
- After: "Prefer `expect()` over `unwrap()` everywhere (test code excluded)"

The second version acknowledges exceptions and trusts the reader to understand the principle.

### Acknowledge the tensions and trade-offs

Explicitly discuss balancing acts in design decisions.
Admit when something is genuinely difficult or has downsides.
Show _the reasoning process_,
not just the conclusion.

Example:
"Ultimately,
it's a balancing act between enforcing as many things as possible in the type system,
versus introducing so many types that programmers can't easily make sense of the code overall any more."

This honesty builds trust and helps readers apply guidance to their specific context,
where the balance point might differ.

## Structure: building understanding

### Front-load what helps readers decide to keep reading

Put caveats,
context,
and applicability constraints early in documents,
before diving into detailed guidance.
This respects readers' time by helping them quickly determine if the content is relevant to their situation.

Unless obvious, be explicit about what is _not_ in scope or intended use.
Consider including a brief instruction on what to do in excluded cases.

Save the detailed principles for readers who've already decided this applies to them.

### Headings state the takeaway, not the topic

You want to write subsection titles that _convey the conclusion or guidance_,
not just name what's being discussed.
Readers skimming headings should get the key points without reading the body.
Keep headings concise—avoid adding qualifiers or contrasts that don't add clarity.

Compare:
- Topic-only: "About `expect()` vs `unwrap()`", "Indexing", "Error handling"
- Takeaway: "Prefer `expect()` for context", "Encode invariants in types", "Define recovery layers"

The second set tells you _what to do_ or _how to think_,
not just what section discusses.

### Principles before patterns, understanding before mechanics

Structure your content to build conceptual understanding first.
Put fundamental solutions (like type-system approaches) before workarounds.
Make sure readers understand _why_ before learning _how_.

Example:
If the key take-away of a document is that "Panics are assertions",
this belongs in a paragraph near the beginning establishing the target mental model,
not buried at the end after implementation details.

This ordering matches how people learn:
concept → consequences → application.

### Ruthlessly cut tangents

Remove sections that drift from the core topic,
even if they're good advice.
Each section should _directly serve the main point_.
If something is generally good practice but not specific to your topic,
cut it or move it elsewhere.

This takes discipline.
That section on error handling layers might be excellent advice,
but if your document is about panic policy and that section doesn't illuminate panic decisions,
it dilutes your message.

### Summaries are for take-aways

Summary sections remind readers of the most critical aspects of what they've read.
They don't introduce new ideas or make new arguments.
They don't simply repeat what came before either.
They distill the essential take-aways—what readers must remember to apply the guidance.

### Brief asides address predictable questions

Include parenthetical clarifications, short aside sections, or footnotes for important, high-signal edge cases readers will wonder about.
Keep these concise and clearly marked.

Example:
> **An aside on test code.** In test code the recommendation is to _prefer panics_ over returning errors...

These preempt the "but what about..." questions without derailing the main narrative.

### Make guidance actionable

Readers should know what action to take after engaging with your guidance.
Don't just explain a concept or problem—show the path forward.

This doesn't mean every section needs a checklist or step-by-step procedure.
Sometimes "the action" is "think about your code differently" or "ask these questions when designing."
But make that explicit.
Don't leave readers nodding along without knowing how to apply what they've learned.

Example contrast:
- Explanatory only: "Type systems can encode invariants that prevent bugs"
- Actionable: "When you find yourself writing `expect()` repeatedly for the same invariant, consider encoding it in a newtype or custom data structure"

The second tells readers _when_ and _how_ to apply the concept.

## Examples: making abstract concrete

### Use realistic, specific examples

Let readers see themselves in your examples.
Show actual values readers might encounter;
meaningful function names,
real values,
specific error messages,
not placeholders.
Realistic examples teach the concept and give readers patterns they can directly adapt,
without distracting them with fill-in-the-blanks exercises.
Prefer the concrete and specific to the generic,
but generalize enough to avoid relying on context that readers won't have.

### Show the evolution from acceptable to optimal

Use progressions in examples to demonstrate levels of conformance:

```rust
// This is okay:
let value = cache.get(&key).expect("cache must contain key");

// This is better:
let value = cache.get(&key).expect("cache populated during init()");

// Or when possible, eliminate the panic:
let value = cache.get(&key).unwrap_or_default();
```

This structure shows readers the thought process and lets them choose the appropriate level for their context.
Different projects have different constraints—show the spectrum.

## Language and emphasis

### Italicize to emphasize concepts, not for decoration

It's helpful to use italics for the parts of claims that are critical to the validity of the claim overall.
These are often a key insight or take-away that it is vital that the reader does not miss and subsequently remembers.
You want to draw the eye to what matters most conceptually.
Emphasize the _idea being conveyed_,
not just for visual variety.

### Lead each concept with understanding, then consequences, then mechanics

Follow this progression:
1. What does this concept _mean_? (mental model)
2. Why does it _matter_? (consequences, stakes)
3. How do you _apply_ it? (patterns, examples)

This matches how understanding builds.
Readers who grasp the mental model can often figure out application themselves.

### Choose lists deliberately over connected prose

Prefer paragraphs that connect ideas when you want readers to understand relationships and themes.
Weaving concepts together reveals how they build on each other and helps readers grasp the bigger picture.

Use lists when:
- The section's purpose is inherently to catalog items (like "common patterns" or "when to use X")
- Items are relatively independent without strong cross-dependencies
- Scannability and reference-ability matter more than showing connections
- You're listing steps in a process or options to choose from

When you do use lists,
keep items focused and contextually related.
Avoid long lists of disconnected prescriptions where connecting the ideas would better serve understanding.

### Write actively and concisely

Use active voice.
Keep sentences focused on one idea.
Use em-dashes for clarifying asides.
Break complex ideas into multiple sentences rather than nesting clauses.

Avoid repeating the same point in different sections or paragraphs.
Redundancy signals to readers that you're not carefully managing their attention,
which erodes trust and makes them more likely to skim or skip other parts of the text.
If a point matters enough to state and survives "ruthlessly cut tangents",
state it _once_ in the most appropriate location.
After editing a document a few times,
do a consolidation-pass to catch any missed redundancies.

> If something is _extraordinarily_ important,
> you can repeat it,
> though then you should acknowledge the repetition explicitly.
> For example:
>
> > This bears repeating:
> > you rarely have _the_ answer;
> > caveats and exceptions are everywhere.
> > Write with that in mind.

When one paragraph addresses multiple distinct sub-points,
prefer splitting it unless doing so muddles the narrative.
When multiple short paragraphs address related points, prefer combining them.
Weaving them together shows relationships and improves flow,
and usually offers additional opportunities to compact.

If a section makes its point in two paragraphs,
resist the urge to add a third for completeness.
Value the reader's time—say what needs saying, then stop.

### Respect the reader

Trust the reader's competence—explain the "why" and let them figure out the "how" for their context.
Less hand-holding, more respect for their judgment.

Choose precise words,
but favour common terms over obscure ones when both work
to avoid losing readers less well-versed in weird words.
"Connect" and "list" serve better than "synthesise" and "enumerate."
Technical precision matters;
verbal flourish doesn't.
Metaphorical language ("paint the picture", "fill-in-the-blanks") is fine—you want to avoid academic vocabulary,
not figurative language.

## Common patterns in practice

**When writing guidance,
prefer showing progression over mandating a single approach.**
Let readers see the spectrum from acceptable to ideal,
with explanations of the trade-offs at each level.

**When explaining consequences,
be concrete and visceral** rather than abstract and categorical.
"This makes debugging harder" is less effective than "when this fails,
you'll get no backtrace,
no context,
and the same crash behaviour but now you can't tell why."

**When you find yourself using "always" or "never",
pause and ask**:
Is this genuinely absolute?
Or should I say "strongly prefer" or "avoid unless"?
Absolutes should be rare and reserved for genuine invariants.
The nuance is often what's most worth teaching.

**When a section grows beyond a screen or two**,
consider whether you're covering multiple concepts that should be separate sections,
or including tangential material that should be cut.

## Formatting: semantic line breaks

Use [semantic line breaks](https://sembr.org/) in Markdown documents to structure prose along semantic boundaries.
This means adding a line break after each substantial unit of thought:

- **After each sentence**
- **After independent clauses** punctuated by comma, semicolon, or colon
- **Before lists**
- **After dependent clauses** when it clarifies structure

**Exception for em-dashes:**
Em-dashes must stay on the same line as adjacent text,
as Markdown renderers join consecutive lines with spaces.
Breaking before or after an em-dash would inject unwanted spaces around it,
violating the British English convention of no spaces around em-dashes (—like this—).
This means some lines containing em-dashes will be longer than others.

While semantic line breaks can be annoying when reading the pure source,
they make _changes_ to prose easier to review
as they create more meaningful diffs that show logical changes rather than rewrapped paragraphs.
And that is more valuable than source readability.
