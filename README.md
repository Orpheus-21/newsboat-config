# newsboat-config

A configuration for the newsboat feed reader. It adds vim keys, query feeds, named filters, and three helper scripts.

## What it does

Newsboat reads RSS feeds in the terminal. This repository replaces the default configuration of newsboat. It changes the key bindings, the colors, the filters, and the list of feeds.

The helper scripts add three actions:

- `s` clips an article to a folder in an Obsidian vault.
- `b` appends a link to a Markdown reading list.
- `d` downloads a video with `yt-dlp`.

The feed list holds one feed: Hacker News.

## Requirements

- Linux.
- newsboat. The configuration was tested with newsboat 2.44.

Each of these programs is needed for one or more keys:

| Program | Used by |
|---|---|
| `firefox` | `o`, `O`, and the default browser |
| `mpv` | `v`, and podcast playback in podboat |
| `wl-copy` | `y` (Wayland only) |
| `yt-dlp` | `d` |
| `notify-send` | desktop notices from the scripts and from newsboat |

## Install

1. Move your current configuration away, if you have one:

   ```sh
   mv ~/.config/newsboat ~/.config/newsboat.bak
   ```

2. Clone this repository into the configuration folder. The `include` lines in `config` expect this path.

   ```sh
   git clone https://github.com/Orpheus-21/newsboat-config.git ~/.config/newsboat
   ```

3. Write your paths in `clip.sh`. Set `dir` to the folder in your Obsidian vault that receives clippings. You can also export `CLIP_DIR`.

4. Write your path in `bookmark.sh`. Set `f` to the Markdown file for your bookmarks. You can also export `BOOKMARK_FILE`.

5. Write your paths in `config`. Two lines are commented out and marked `WRITE YOUR PATH`. They are `save-path` and `download-path`. Remove the leading `#` after you set each path.

6. Start newsboat:

   ```sh
   newsboat
   ```

If you skip step 3 or step 4, the key shows an error message and writes no file.

## Usage

The key grammar follows vim. A lowercase key does the common action. The matching capital key does the larger version.

| Key | Action |
|---|---|
| `j` `k` | Move down and up |
| `gg` `G` | Go to the top and the bottom |
| `l` or Enter | Open |
| `h` | Go back |
| `n` `p` | Next and previous unread article |
| `J` `K` | Next and previous feed in the article list. Next and previous article in the article view |
| `o` | Open in Firefox |
| `O` | Open all unread articles in Firefox and mark them read |
| `y` | Copy the link to the clipboard |
| `v` | Play the link in `mpv` |
| `d` | Download the link with `yt-dlp` |
| `b` | Add the link to the bookmark file |
| `s` | Clip the article to the Obsidian folder |
| `S` | Save all articles in the list |
| `e` | Add the podcast to the download queue |
| `x` | Toggle read |
| `a` | Mark all articles above as read |
| `A` | Mark the feed as read |
| `C` | Mark all feeds as read |
| `t` `T` | Pick a tag and clear the tag |
| `f` `F` | Pick a filter and clear the filter |
| `u` | In the feed list, show or hide read feeds. In the article view, show the links |
| `r` `R` | Reload one feed and reload all feeds |
| `E` | Edit the `urls` file and apply the change |
| `/` | Search |
| `:` | Command line |
| `?` | Help |
| `q` | Quit |

The file `keys` holds the full list.

To add a feed, press `E` and add one line to `urls`. The format is:

```
https://example.org/feed.xml  tag  "~Display name"
```

## Configuration

| File | Content |
|---|---|
| `config` | Entry point. Fetch, cache, and reading settings, and the external programs |
| `keys` | All key bindings |
| `theme` | Colors, highlights, and list formats |
| `filters` | Named filters, article highlights, and rules that drop articles |
| `urls` | Query feeds and the feed list |

Main settings in `config`:

| Setting | Value | Meaning |
|---|---|---|
| `reload-time` | `30` | Minutes between automatic reloads |
| `max-items` | `300` | Maximum number of articles for each feed |
| `keep-articles-days` | `90` | Days to keep an article |
| `text-width` | `90` | Width of the article text in columns |
| `html-renderer` | `internal` | Newsboat renders HTML itself, so `w3m` and `lynx` are not needed |

To remove one concern, delete its `include` line in `config`.

The `urls` file starts with five query feeds: Unread, Today, Flagged, Videos, and Podcasts. A query feed is a virtual feed. It shows the articles that match a rule.

The `filters` file defines seven named filters: Today, This week, Unread, Flagged, Videos, Podcasts, and Dead feeds. The `f` key lists them.

WARNING: The `filters` file also holds `ignore-article` rules. The rules drop articles with a sponsor title and links to YouTube Shorts. Newsboat drops these articles at fetch time, so you cannot get them back. Change `ignore-mode download` to `ignore-mode display` while you test a new rule.

## How it works

The file `config` includes `keys`, `theme`, and `filters` by path under `~/.config/newsboat`. Newsboat reads `urls` from the same folder.

The three scripts run from the keys:

- `clip.sh` is a `pipe-to` target. Newsboat sends the rendered article on standard input. The script reads the `Title:` and `Link:` headers, removes characters that are not safe in a file name, and writes `<title>.md` with a `source:` line in the frontmatter. The script never overwrites a file. A repeated clip is named `<title> (2).md`.
- `bookmark.sh` is the `bookmark-cmd`. It appends one line to the bookmark file with the title, the link, the feed title, and the date. It creates the file if the file does not exist.
- `dl.sh` runs `yt-dlp` and writes to `$DL_DIR`. The default folder is `~/Videos`. The script embeds English subtitles and prefers a height of 1080 pixels. It sends a desktop notice when the download ends or fails.

The browser keys use `set browser` for one action. The keys then reset the browser command to Firefox.

## License

GPL-3.0-or-later. See `LICENSE`.
