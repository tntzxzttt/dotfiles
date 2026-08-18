---
description: Review staged commits before pushing for secrets, license issues, and personal information
allowed-tools: Bash, Read, Grep
---

<!-- markdownlint-disable MD013 MD041 -->

## Instructions

Review all unpushed commits for issues that should not be made public.
Report any findings and recommend whether it is safe to push.

## Diff to review

!`git log --oneline origin/$(git branch --show-current)..HEAD 2>/dev/null && echo "---DIFF---" && git diff origin/$(git branch --show-current)..HEAD 2>/dev/null || (echo "No remote tracking branch. Showing all commits on this branch:" && git log --oneline main..HEAD && echo "---DIFF---" && git diff main..HEAD)`

## Checklist

Review the diff above for each of the following:

### 1. Secrets and credentials

- API keys, tokens, passwords, private keys
- `.env` file contents or environment variable values
- OAuth client secrets, webhook URLs with tokens
- Base64-encoded credentials

### 2. License compliance

- Copied code from other projects without proper attribution
- LICENSE or NOTICE files removed or altered inappropriately
- Code snippets from Stack Overflow or blogs without license compatibility

### 3. Personal or environment-specific information

- OS usernames, home directory paths (e.g. `/Users/username/`, `/home/username/`)
- Machine hostnames, local IP addresses
- Hardcoded absolute paths that only work on one machine
- Email addresses or real names in places other than git author metadata

### 4. Sensitive configuration

- Database connection strings with real hosts or credentials
- Internal URLs, staging/production endpoints
- Debug flags or development-only settings that should not ship

### 5. Unintended file inclusions

- Binary files, build artifacts, or cache files
- Large generated files that are noise
- Files that should be in `.gitignore`

## Output format

For each category, report one of:

- **OK** — no issues found
- **WARNING** — potential issue (describe what and where)
- **BLOCK** — must fix before pushing (describe what and where)

Then write a short human-readable summary explaining the decision and reasons.

## Verdict

After the summary, the **final line** of your output must be exactly one
machine-readable verdict, with no surrounding text, quotes, or formatting:

- `VERDICT: SAFE` — no BLOCK-level issues; the push is safe.
- `VERDICT: BLOCK` — one or more issues must be fixed before pushing.

Rules:

- Emit the verdict line exactly once, as the very last line of your output.
- Use these two strings verbatim; do not reword, prefix, or annotate them.
- When in doubt, emit `VERDICT: BLOCK`.

The pre-push hook fails closed: any missing, malformed, duplicated, or
non-`SAFE` verdict blocks the push.
