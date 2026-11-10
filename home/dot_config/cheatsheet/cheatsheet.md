# Cheat sheet

Type `cheatsheet` to see this again.

## Moving around

| Type | What it does |
|---|---|
| `pwd` | Shows which folder you are in |
| `ls` / `ll` | Lists the files here, `ll` with sizes and dates |
| `cd Documents` | Goes into a folder, `cd ..` goes up one, `cd` alone goes home |
| `z proj` | Jumps to a folder you visited before whose name contains "proj" |
| `open .` | Opens the current folder in Finder |
| `open file.pdf` | Opens a file with its usual app |

## Keys that save time

| Key | What it does |
|---|---|
| `tab` | Completes a file or command name, press it twice for a menu |
| `→` | Accepts the grey suggestion, which comes from your history |
| `ctrl+r` | Searches every command you ever typed |
| `↑` | Brings back the previous command |
| `ctrl+c` | Stops whatever is running, or clears the line |
| `cmd+k` | Clears the screen |
| `q` | Quits a screen that shows text page by page |

A command in red has a typo. Fix it before pressing Enter.

## Claude Code

| Type or press | What it does |
|---|---|
| `claude` | Starts Claude in the current folder |
| `claude -c` | Continues the last conversation in this folder |
| `esc` | Stops Claude in the middle of something |
| `esc esc` | Goes back to an earlier message |
| `shift+tab` | Changes mode: ask before each edit, accept edits, or plan only |
| `/clear` | Starts a fresh conversation |
| `/help` | Lists everything else |

Start Claude in the folder of the project you are working on. It reads the
files there, not the whole Mac.

## herdr, several Claudes at once

Type `herdr` to start it. You can click on everything with the mouse.
Every shortcut is `ctrl+b`, then a key.

| Key | What it does |
|---|---|
| `ctrl+b` then `?` | Lists every shortcut |
| `ctrl+b` then `c` | New tab |
| `ctrl+b` then `v` | Splits the screen side by side |
| `ctrl+b` then `x` | Closes the current pane |
| `ctrl+b` then `1`…`9` | Goes to tab 1…9 |
| `ctrl+b` then `q` | Leaves herdr. Your Claudes keep running, and `herdr` brings them back |

The sidebar shows which Claude is working, which is waiting for you, and which
is done.

## Data files with SQL

```
duckdb -c "SELECT * FROM 'sales.csv' LIMIT 10"
duckdb -c "SELECT * FROM read_xlsx('report.xlsx')"
duckdb
```

The last one opens an interactive session. `.quit` leaves it.

## Keeping things up to date

| Type | What it does |
|---|---|
| `dots-update` | Updates the terminal setup and its tools |
| `mise use -g <tool>` | Installs a command-line tool |

Your own aliases and settings go in `~/.zshrc.local`. Updates never touch it.
