---
name: terse-commits-comments
description: User-wide style preference for git commit messages and code comments — keep both as terse as possible. Apply automatically any time you are about to write a commit message or add a code comment, in any project, without being asked to invoke this skill explicitly.
---

# Terse commits and comments

This user wants commit messages and code comments kept as short as possible, across every project.

## Commit messages

- Prefer a single short line. Only add a body if there's a genuinely non-obvious "why" that the diff itself can't convey.
- No filler ("this commit adds...", "various changes to..."). State the change plainly.
- Don't enumerate every file touched — the diff already shows that.

## Code comments

- Default to no comments, per standard good-code practice.
- When a comment is warranted (non-obvious WHY: a constraint, a workaround, an invariant), write it as short as possible — a phrase or one line, not a paragraph.
- Never restate WHAT the code does.

If a project's own CLAUDE.md or style guide already specifies terse commits/comments, this skill just reinforces it — no conflict to resolve. If a project explicitly asks for more verbose commit messages (e.g. a required template with sections), follow the project's explicit convention instead.
