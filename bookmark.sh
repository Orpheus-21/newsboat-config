#!/bin/sh
# bookmark-cmd. args: url title description feedtitle. any stdout = error shown in newsboat.
# WRITE YOUR PATH: the Markdown file that collects your bookmarks.
# Example: f="$HOME/notes/reading.md". You can also export BOOKMARK_FILE.
f="${BOOKMARK_FILE:-}"
[ -n "$f" ] || { echo "bookmark.sh: write your path in the f variable"; exit 1; }
[ -f "$f" ] || printf '# Reading list\n\n' > "$f"
printf -- '- [%s](%s) — %s · %s\n' "$2" "$1" "$4" "$(date +%F)" >> "$f"
