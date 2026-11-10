# About me

I'm Marta. I work in IT, mostly with databases. I'm not a programmer, and the
terminal is new to me. I understand English and Spanish.

## How to talk to me

- Reply in the language I write in.
- Use plain words. When a technical term can't be avoided, explain it once,
  in one short sentence.
- When something fails, tell me first what went wrong in plain words, then
  what you want to try.

## Before you run anything

- Say in one sentence what the command does and whether it changes,
  deletes or sends anything. Read-only commands need no warning.
- Never delete or overwrite a file I didn't ask you to touch. Moving it to
  the Trash (`mv <file> ~/.Trash/`) is better than `rm`.
- Don't install software without asking. This Mac is an Intel one and
  Homebrew refuses to install on it, so never suggest `brew`. Command-line
  tools go in with `mise use -g <tool>`. For an app, point me to its
  vendor's download page.

## Databases

- Assume every connection could be production until I tell you otherwise.
- Read-only queries (SELECT, EXPLAIN, DESCRIBE) are fine to run.
- Anything that writes (INSERT, UPDATE, DELETE, MERGE, DROP, ALTER, TRUNCATE,
  GRANT) needs my explicit yes every time. Show me the full statement, which
  database and server it runs on, and roughly how many rows it touches.
- Prefer a transaction you can roll back, and show the effect with a SELECT
  before committing.
- Never write a password into a file, a command or a commit. If a connection
  needs one, ask me to put it in an environment variable or the macOS
  Keychain.

## My setup

- Claude: the desktop app and Claude Code in the terminal.
- Terminal: Ghostty. Agent manager: herdr (`herdr`). Database client:
  TablePlus. Git: GitHub Desktop, so suggest it when I want to commit or push.
  Browser: Safari or Orion.
- `duckdb` is installed for running SQL over CSV, Excel and Parquet files.
- `cheatsheet` shows my notes on the terminal. `dots-update` updates my setup.
- My settings come from Leandro's `dotfiles-marta` repository and are
  overwritten on every update. Don't edit `~/.zshrc`, `~/.zprofile`,
  `~/.claude/settings.json` or anything under `~/.config` that the repo
  manages. Personal shell additions go in `~/.zshrc.local`; anything else,
  tell me to ask Leandro.
