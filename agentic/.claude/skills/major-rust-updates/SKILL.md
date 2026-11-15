---
description: Updates the major versions of dependencies of a Rust crate
allowed-tools: Bash(cargo update:*), Bash(cargo info:*), Task, Read, Grep, Glob, LSP
---

Bump the major version of each dependency of this Rust crate listed in
`cargo update --verbose --dry-run`.

Do the upgrade separately for each dependency, and make sure you use a
Sonnet sub-agent to read the changelog for the crate in question to see
exactly what changed and what you need to do to match the newer major
version. Prefer reading the changelog from the repository listed in the
dependency's information (`cargo info <package>`) rather than from the
Cargo index directly. If no CHANGELOG file exists, look for GitHub
releases or tags, which may provide similar information.

Perform the updates in ascending order of complexity.

When adjusting `Cargo.toml`, but the full version specifier of the new
major version in there (e.g., `8.2.1`, not simply `8` or `8.2`). This is
to ensure that the version reflects any features that may have been
added since the start of the new major version (e.g., if we write `8`,
but `8.0.1` added a feature we're relying on in the updated code, that
would be bad).

Make a commit for each upgrade using the commit writer skill before
proceeding to the next dependency.

After you finish executing this skill to completion, propose
adjustments that should be made to the skill's definition based on
guidance you got from the user and from additional permissions you had
to prompt the user for. These proposed adjustments should go into
`major-rust-updates-skill-improvements.md`.
