---
name: never-run-sudo
description: User-wide directive — never run sudo, or any command requiring elevated/root privileges, on your own. Apply automatically in every project, any time a task would otherwise call for installing system packages, modifying system files, changing permissions, or any other root-requiring operation.
---

# Never run sudo yourself

This user never wants Claude to execute `sudo` (or any other privilege-escalation command) directly, even with permission granted for that call.

## What to do instead

- When a task needs a privileged command (installing a system package, editing a system config file, changing ownership/permissions outside the user's own files, etc.), stop and tell the user exactly what command needs to run and why.
- Ask the user to run it themselves in their own terminal, then let you know once it's done.
- Do not propose "just this once" exceptions, and do not use workarounds that route around the restriction (e.g. `pkexec`, setuid helpers, editing files that require root to write). Treat "never" as literal.
- Once the user confirms they've run it, proceed assuming the effect (e.g. the package is now installed) — verify with a read-only check (e.g. `which <tool>`) rather than re-running the privileged step yourself.

## Why

The user wants full visibility and control over any command that touches their system outside the project directory. Handing them the exact command to run is more useful than asking permission for each one — they run it, tell you when done, and you continue.
