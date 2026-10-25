# Open4skills-spec

A Claude Code skill, **`/spec-plus`**, that turns a rough idea into a testable specification and task backlog through a short (~10 question) interview.

It writes `docs/SPEC.md` (requirements with stable IDs and acceptance criteria, plus a task backlog) and tunes the backlog to the LLM that will build it: a frontier model gets a plain backlog, a small local model gets atomic task cards in `docs/TASKS.md`. It also adds a pointer to the spec in your project's `CLAUDE.md`.

## Repository structure

```
Open4skills-spec/
├── README.md                  # this file
├── install.sh                 # optional helper that copies the skill into place
└── skills/
    └── spec-plus/
        └── SKILL.md           # the skill itself
```

`skills/spec-plus/SKILL.md` is the source copy kept in this repo. Claude Code does **not** read it from here; it must be copied into one of the locations below.

## Installing the skill

Claude Code discovers skills by looking for a folder containing a file named exactly `SKILL.md` (uppercase) inside a `skills/` directory in specific locations. The folder name becomes the slash command (`spec-plus` gives `/spec-plus`).

### Option A: personal install (available in every project)

```
~/.claude/skills/spec-plus/SKILL.md
```

```bash
mkdir -p ~/.claude/skills/spec-plus
cp skills/spec-plus/SKILL.md ~/.claude/skills/spec-plus/SKILL.md
```

On Windows (PowerShell):

```powershell
New-Item -ItemType Directory -Force "$HOME\.claude\skills\spec-plus"
Copy-Item skills\spec-plus\SKILL.md "$HOME\.claude\skills\spec-plus\SKILL.md"
```

### Option B: project install (shared with everyone working on one repo)

Run from the root of the project that should have the skill:

```
<your-project>/.claude/skills/spec-plus/SKILL.md
```

```bash
mkdir -p .claude/skills/spec-plus
cp /path/to/Open4skills-spec/skills/spec-plus/SKILL.md .claude/skills/spec-plus/SKILL.md
```

Commit `.claude/skills/` so teammates get the skill when they clone.

### Using the helper script

```bash
./install.sh                      # personal install
./install.sh /path/to/project     # project install
```

### Placement checklist

Claude Code will silently ignore the skill if any of these are wrong:

- The file is named `SKILL.md`, uppercase, not `skill.md` or `SKILL_2.md`.
- It sits one folder deep: `.../skills/spec-plus/SKILL.md`, not `.../skills/SKILL.md`.
- The folder is under `.claude/skills/` (note the leading dot), either in your home directory or at the root of the project.
- The YAML front matter at the top of the file is intact (`name` and `description`, between `---` lines).

## Verifying it works

1. Start a **new** Claude Code session in your project (restart if one is already open, since skills are loaded at startup).
2. Type `/` and look for `spec-plus` in the list, or ask "what skills are available?".
3. Run it:

   ```
   /spec-plus a plugin that shows related posts under each article
   ```

   If you pass an idea, the first question is skipped. With no argument it asks for the idea first.

If `/spec-plus` does not appear, re-check the placement checklist above.

## What it produces

| File | When |
|------|------|
| `docs/SPEC.md` | Always. Requirements (`R-xxx`), acceptance criteria, scope, assumptions, task backlog (`T-xxx`), change log |
| `docs/TASKS.md` | Only when the builder model is a local model (tiers B-D). One self-contained task card per task |
| `CLAUDE.md` | Created or appended with a pointer to the spec (and task cards for tiers B-D) |

After you approve the spec, say things like "build T-001" and Claude works from `docs/SPEC.md`.

## Builder model tiers

| Tier | Builder | Backlog style |
|------|---------|---------------|
| A | Frontier API model (Claude Sonnet/Opus) | Feature-sized one-liners |
| B | Large local model (over ~40B) | One file or module per task, with cards |
| C | Mid local model (~16-40B) | One file or module per task, with cards |
| D | Small local model (up to ~15B) | Atomic tasks (under ~150 lines) with exact paths, signatures and runnable checks |

If you use Aider or Cline, load `docs/SPEC.md` and the current task card as read-only context, since those tools do not read `CLAUDE.md`.

## Updating

Edit `skills/spec-plus/SKILL.md` in this repo, then re-run the copy step (or `./install.sh`) and start a new Claude Code session.
