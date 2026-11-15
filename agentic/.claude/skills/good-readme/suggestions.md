# Suggested improvements to the good-readme skill

From writing the README for `ur` (PineTime firmware), where the first
attempt needed correcting.

## Say outright who the README is for

The four questions imply it, but the skill never says: **the README is for
users; anything about developing the project goes in CONTRIBUTING.** The
first `ur` README kept sections on fetching debug logs, flashing over a
debug probe, and building from source, because they were "how do I
install it" for the author. A rule of thumb worth stating: if a section
only matters to someone changing the code, debugging it, or cutting a
release, it belongs in CONTRIBUTING, and the README links there once.
Building from source is the borderline case: include a line only when
users have no prebuilt alternative.

## Visual demos: how, not just whether

"Maybe a visual demo at the top" could say more for UI-bearing projects
(apps, firmware with a screen, TUIs):

- Screenshots near the top, before the feature list, a few at a modest
  width, each with alt text describing what it shows.
- Generate them reproducibly (a script, a test harness, a debug hook)
  from a real build, and mention in CONTRIBUTING how, so they get
  refreshed rather than drifting from the actual UI.
- Prefer showing variety (light/dark, key screens, a notable state) over
  one hero image.

## Check every claim against the code

A README's feature list and status line go stale quietly ("alarms and
sleep tracking are still to come" outlived both features). When writing
or revising a README, verify each feature and each usage instruction
(gestures, commands, flags) against the current code, not memory or
older docs.

## Public repositories: no personal data in examples

Screenshots, example output, and test fixtures that end up in a README
should use made-up names and data. It's easy to capture a real
notification, contact, or path while making a demo, and a README is the
most-read file in a public repository.

## Distributed artifacts: which file, and how to trust it

When a project publishes several artifacts per release, the install
section should name the one users want (and what the others are for, in
the release notes or CONTRIBUTING), and how to verify it if the project
offers that (checksums, signatures, `gh attestation verify`).

## Licence: prompt rather than skip

The skill includes a licence template, but when the repository has no
LICENSE file, the template can't be filled in honestly. Say so: ask the
user which licence they want (or flag its absence) rather than silently
omitting the section or assuming one.

## Separate the examples from the instructions

The skill's body mixes general guidance with feedback from specific past
projects (avro-tools' test suite, a "divergences" section, a stream tag,
Lidarr). Read cold, those look like instructions for the current
project. Moving them under a clearly labelled "Examples of past feedback"
heading, or into a separate file, would make the general rules easier to
apply without misreading.
