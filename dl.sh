#!/bin/sh
# d target. Downloads $1 with English subs embedded, notifies when done or failed.
dir="${DL_DIR:-$HOME/Videos}"
if f=$(yt-dlp -P "$dir" -S res:1080 --write-auto-subs --sub-langs 'en.*' --embed-subs \
        --print after_move:filepath -- "$1" 2>/dev/null); then
    notify-send -a newsboat "Download finished" "$(basename "$f")"
else
    notify-send -a newsboat -u critical "Download failed" "$1"
fi
