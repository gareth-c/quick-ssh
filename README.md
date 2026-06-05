# quick-ssh

An elegant interactive terminal menu for managing and connecting to SSH hosts.

```
  ⚡ quick-ssh — SSH Host Manager
┌──────────────────────┬───────────────────────────────────────┐
│ Hosts                │ Host Details                          │
│  ▼ Home              │  Name        NAS01                    │
│      NAS01      ◄──  │  Folder      Home                     │
│      Raspberry Pi    │                                       │
│  ▶ Work              │  Host        192.168.1.10             │
│                      │  User        admin                    │
│                      │  Port        22                       │
│                      │  SSH Key     default (~/.ssh/id_rsa)  │
│                      │                                       │
│                      │  Command                              │
│                      │  ssh admin@192.168.1.10               │
│                      │  [Enter] connect  [E] edit  [D] del   │
└──────────────────────┴───────────────────────────────────────┘
 quick-ssh  [↑↓] navigate  [Enter] connect  [A] add  [Q] quit
```

## Requirements

- Python 3.6+
- macOS or Linux (uses `curses` from the standard library — no extra packages needed)

## Installation

```bash
git clone https://github.com/yourname/quick-ssh
cd quick-ssh
./install.sh
```

The installer copies `quick-ssh` to `~/.local/bin` (or `/usr/local/bin` if that's writable) and sets the correct permissions (`755`). It will warn you if the target directory isn't on your `PATH` and show you the line to add to your shell profile.

To uninstall:

```bash
rm "$(which quick-ssh)"
```

## Usage

### Interactive TUI

```bash
./quick-ssh
```

Opens the full interactive menu. Hosts are organised into folders. Navigate with arrow keys, connect with Enter.

### Direct connect by name

```bash
./quick-ssh NAS01
```

Looks up the host by name (case-insensitive) in your saved config and executes SSH immediately — no menu shown.

### Other flags

```bash
./quick-ssh -v   # print version
./quick-ssh -h   # show usage and key bindings
```

## Key bindings

| Key | Action |
|-----|--------|
| `↑` / `↓` or `j` / `k` | Move up / down |
| `Enter` or `Space` | Connect to host · expand/collapse folder |
| `Tab` / `→` | Jump to next folder |
| `←` | Jump to previous folder |
| `Page Up / Down` | Scroll by page |
| `A` | Add new host |
| `E` | Edit selected host |
| `D` | Delete selected host (confirms first) |
| `F` | Add new folder |
| `Q` | Quit |

## Config file

Hosts are stored in `~/.config/quick-ssh/hosts.json` and created automatically on first run with sample entries.

```json
{
  "folders": {
    "Home": {
      "NAS01": {
        "host": "192.168.1.10",
        "user": "admin",
        "port": 22,
        "key": ""
      }
    },
    "Work": {
      "Web Server": {
        "host": "10.0.0.1",
        "user": "ubuntu",
        "port": 22,
        "key": "~/.ssh/work_key"
      }
    }
  }
}
```

Fields:

| Field | Description |
|-------|-------------|
| `host` | Hostname or IP address |
| `user` | SSH username (omit to use your system default) |
| `port` | SSH port (omit or set to `22` to use the default) |
| `key` | Path to private key file (omit to use the SSH agent / default key) |

You can edit the file directly or manage everything through the TUI.

## How SSH is launched

`quick-ssh` uses `os.execvp` to replace itself with the `ssh` process, so your terminal behaves exactly as if you had typed the command manually. No wrapper process stays alive in the background.

The command it builds:

```
ssh [-i <key>] [-p <port>] [user@]host
```
