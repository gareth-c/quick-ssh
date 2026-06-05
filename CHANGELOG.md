# Changelog

All notable changes to quick-ssh will be documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] — 2026-06-05

### Added
- Interactive curses TUI with two-panel layout (host list + detail view)
- Folder organisation — group hosts into named folders, expand/collapse with Enter/Space
- Full keyboard navigation: arrow keys, `j`/`k`, Tab to jump between folders, Page Up/Down
- Add, edit, and delete hosts via in-TUI dialogs
- Add folders via `F` key
- Detail panel showing host, user, port, SSH key, and the exact SSH command that will run
- Direct connect by name: `quick-ssh NAS01` looks up the host and execs SSH immediately
- `-v` / `--version` flag to print the release version
- `-h` / `--help` flag to print usage, key bindings, and config file location
- Config stored in `~/.config/quick-ssh/hosts.json` with sample entries written on first run
- `install.sh` — copies binary to `~/.local/bin` or `/usr/local/bin`, sets correct permissions, warns if install dir is not on `$PATH`

### Security
- SSH args built as a list passed to `os.execvp` — no shell involved, no injection via metacharacters
- `--` separator inserted before the SSH destination to prevent host/user values starting with `-` being parsed as SSH options (ProxyCommand injection)
- Config directory created with `0o700`, config file written with `0o600` — not world-readable
- Atomic config writes via `tempfile.mkstemp` + `os.replace` — corrupt-on-kill resistant
- Malformed or `null` config handled gracefully; falls back to defaults rather than crashing the TUI
