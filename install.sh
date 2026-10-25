#!/usr/bin/env bash
# Install the spec-plus skill for Claude Code.
#   ./install.sh            -> personal install (~/.claude/skills/), all projects
#   ./install.sh /path/to/project -> project install (<project>/.claude/skills/)
set -euo pipefail

src="$(cd "$(dirname "$0")" && pwd)/skills/spec-plus"
if [ $# -ge 1 ]; then
  dest="$1/.claude/skills/spec-plus"
else
  dest="$HOME/.claude/skills/spec-plus"
fi

mkdir -p "$dest"
cp "$src/SKILL.md" "$dest/SKILL.md"
echo "Installed spec-plus to $dest"
echo "Restart Claude Code (or start a new session), then run /spec-plus"
