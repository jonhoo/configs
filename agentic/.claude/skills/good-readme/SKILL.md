---
description: Make a README that is concise, informative, and useful.
---

Write a README file for the project. Aim for it to be terse, tight, and
to the point, with very little fluff. Brevity and directness will be
significantly appreciated by readers.

READMEs are a common first touch-point with both users and other
developers. A good one answers four questions immediately:

1. What does this do?
2. Why should I care?
3. How do I use it?
4. How do I install it?

They must be in that order. For example, usage comes before install
since the user needs to see the usage to determine if it's useful enough
to install. They do not all necessarily need to be separated out as
sections.

Structure it like a funnel: a one-liner and maybe a visual demo at the
top so someone can decide in seconds if this solves their problem, then
progressively add depth. Show usage before installation — people want to
see what they're getting *before* committing to setup steps.

**The README is for users; anything about developing the project,
debugging it, or contributing to it, goes in CONTRIBUTING.**

If there are other tools, protocols, hardware devices, upstream
repositories, or reference material that are deeply intertwined with the
work, these should be made clear and accessible in the README, often
mentioned early on.

Any caveats for the work, such as "experimental", "beta",
"unmaintained", "forked", etc., should be featured prominently and early
(but _after_ "Why should I care?"). If the project is a fork or port,
the README _must_ include a reference + credit to the original project,
an explanation of the motivation for the fork/port, (if it's a fork) how
the fork will eventually merge back upstream (if ever), and an
explanation of how it differs from the original (ideally with one or two
brief examples when relevant).

If the project is completely/mostly vibe-coded or power-coded
(LLM-fueled but with deep review, testing, and/or reference
implementation comparison), or otherwise LLM-assisted, this should be
made clear in the README _after_ "Why should I care?" in a "How it was
built?" paragraph.

In "Why should I care?", if there are tools the reader may already be
familiar with, concise contrast to those is often a useful vehicle.

In the "How do I use it?" section, do not repeat all command line
arguments — users should find those by running `--help`. Focus on what
we expect to be by far the most common few invocations that the majority
of the tool's users will run.

The "How do I install it?" section _may_ mention toolchains the user must
have installed, but if so it should be very brief, and only include
_essential_ and possibly non-obvious information (e.g., Rust MSRV is not
necessary to mention for CLI tools). It should ideally mention a
"simple" install mechanism (like `cargo install`) when it exists, and a
"build from source" install mechanism.

After the four mentioned questions are answered, a section on
administrativia (under a better name) should be included. This should
include, e.g, a license section:

```markdown
## License

Licensed under either of

 * Apache License, Version 2.0
   ([LICENSE-APACHE](LICENSE-APACHE) or <http://www.apache.org/licenses/LICENSE-2.0>)
 * MIT license
   ([LICENSE-MIT](LICENSE-MIT) or <http://opensource.org/licenses/MIT>)

at your option.

## Contribution

Unless you explicitly state otherwise, any contribution intentionally submitted
for inclusion in the work by you, as defined in the Apache-2.0 license, shall be
dual licensed as above, without any additional terms or conditions.
```

Highly developer-focused text, like testing strategy, should go a
CONTRIBUTING file, not in the README, although the README should point
potential contributors at CONTRIBUTING. Neither the README nor
CONTRIBUTING should mention gitignore'd files.
