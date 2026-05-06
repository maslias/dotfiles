# Superpowers for pi

This pi extension adapts Jesse Vincent's Superpowers methodology (`obra/superpowers`) to pi.

## What it does

- Registers the bundled `repo/skills/` directory with pi via `resources_discover`, so Superpowers skills appear as pi skills and `/skill:<name>` commands.
- Gates bundled skill descriptions so pi should not auto-select Superpowers skills until Superpowers is active.
- Keeps Superpowers inactive by default.
- Activates and injects the `using-superpowers` bootstrap only after a user prompt mentions `superpowers`.
- Latches activation for the rest of the session so chained workflows such as brainstorming → writing plans → executing plans continue without requiring every prompt to mention `superpowers`.
- Adds pi-specific tool mapping for Superpowers instructions originally written for Claude Code:
  - `Read` / `Write` / `Edit` / `Bash` → pi `read` / `write` / `edit` / `bash`
  - `Skill` tool → pi skill loading (`/skill:<name>` or reading the skill's `SKILL.md`)
  - `TodoWrite` → explicit response checklist or project-local TODO/plan document
  - `Task`/subagents → pi-compatible self-execution or separate pi agents/worktrees by user request

## Commands

- `/superpowers` — show installation/status notes.
- `/superpowers-update` — refresh bundled skills from `https://github.com/obra/superpowers`, then run `/reload`.

## Files

- `index.ts` — pi extension entrypoint.
- `repo/` — vendored Superpowers repository snapshot.
