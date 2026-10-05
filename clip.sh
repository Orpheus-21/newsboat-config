#!/bin/sh
# pipe-to target. stdin: rendered article, Title:/Link: headers, blank line, body.
# Writes a vault clipping shaped like the Web Clipper ones: source frontmatter + body.
# Never overwrites; a repeat clip becomes "Title (2).md".
# WRITE YOUR PATH: the folder in your Obsidian vault that receives clippings.
# Example: dir="$HOME/vault/clippings". You can also export CLIP_DIR.
dir="${CLIP_DIR:-}"
[ -n "$dir" ] || { notify-send "Clip failed" "Write your path in clip.sh" >/dev/null 2>&1; exit 1; }
tmp=$(mktemp) || exit 1
trap 'rm -f "$tmp"' EXIT
cat > "$tmp"
title=$(sed -n '/^ *$/q;s/^Title: //p' "$tmp")
link=$(sed -n '/^ *$/q;s/^Link: //p' "$tmp")
name=$(printf '%s' "$title" | sed 's/[][\/:*?"<>|#^]//g;s/^ *//;s/ *$//')
[ -n "$name" ] || name="Untitled $(date +%Y%m%d-%H%M%S)"
mkdir -p "$dir"
f="$dir/$name.md"; n=2
while [ -e "$f" ]; do f="$dir/$name ($n).md"; n=$((n + 1)); done
{ printf -- '---\nsource: %s\n---\n' "$link"; sed '1,/^ *$/d' "$tmp"; } > "$f"
notify-send "Clipped" "$name" >/dev/null 2>&1
