---
description: Suggest the next release version and title based on changes since the latest tag
allowed-tools: Bash, Read
---

<!-- markdownlint-disable MD041 -->

## Instructions

Suggest the next release version and title for this repository.
Do NOT create the release — only propose.

## Steps

1. Get the latest tag:

!`git describe --tags --abbrev=0 origin/main`

1. List commits since the latest tag:

!`git log $(git describe --tags --abbrev=0 origin/main)..origin/main --oneline`

1. Review past releases for title style and naming conventions:

!`gh release list --limit 5`

1. Determine the version bump following [Semantic Versioning](https://semver.org/):
   - **patch**: only fixes or chores (no new features)
   - **minor**: at least one `feat` commit
   - **major**: breaking changes

2. Propose a title that summarizes the theme of the changes, matching the style of previous releases.

## Output format

- **Version**: `vX.Y.Z`
- **Title**: a short phrase describing the theme of the changes
