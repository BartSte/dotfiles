# BartSte dotfiles

These repositories share the home directory as their Git worktree.
The base repository owns this README. Each file path must have one repository owner.

| Repository | Purpose |
| ---------- | ------- |
| `dotfiles` | Neovim configuration and initialization scripts |
| `dotfiles-linux` | Shell, tmux, Git, mail, calendars, Codex, and command-line tools |
| `dotfiles-arch` | Arch packages, Sway, Waybar, DNS, firewall, and systemd units |
| `dotfiles-pi` | Raspberry Pi packages, network, services, and applications |
| `dotfiles-windows` | Windows and PowerShell configuration |
| `dotfiles-secret` | Optional private configuration |

## Linux installation

The initializer installs the base and Linux repositories as bare Git repositories.
On Arch Linux and Raspberry Pi, it also installs the platform repository.
The initializer also attempts to install the optional private repository.
It can overwrite existing configuration files in the home directory.

Run the initializer:

```bash
curl -fsSLo /tmp/dotfiles-initialize https://raw.githubusercontent.com/BartSte/dotfiles/master/dotfiles/initialize
bash /tmp/dotfiles-initialize
```

Edit `~/.dotfiles_config.sh` before setup:

| Variable | Value |
| -------- | ----- |
| `BWEMAIL` | Email address for the Bitwarden account |
| `MICROSOFT_ACCOUNT` | Bitwarden item for the NeoMutt account |

Run the common setup:

```bash
~/dotfiles-linux/main
```

On Arch Linux, run its setup:

```bash
~/dotfiles-arch/main
```

On a Raspberry Pi, run its setup:

```bash
~/dotfiles-pi/main
```

Run the interactive authentication steps for Bitwarden, Git, calendars, and Dropbox:

```bash
~/dotfiles-linux/auth
```

Start a new Zsh session after setup.
The `main` scripts install and configure modules. The `auth` scripts handle interactive authentication.
Keep passwords and API tokens outside Git.

### WSL

The Linux setup installs WSL integration and enables systemd through `/etc/wsl.conf`.
After the first setup, restart WSL from PowerShell:

```powershell
wsl --shutdown
```

Use `wuv` and `wpy` for Windows Python environments from WSL.
Work Python projects use the Windows environment associated with the original repository.

## Windows installation

Run the Windows initializer in PowerShell:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/BartSte/dotfiles/master/dotfiles/initialize.ps1'))
```

The initializer installs Scoop, Git, and the base and Windows repositories.
It also attempts to install the private repository.

If `$HOME/dotfiles-config.ps1` does not exist, copy the template:

```powershell
Copy-Item "$HOME/dotfiles-windows/default_config.ps1" "$HOME/dotfiles-config.ps1"
```

Edit `$HOME/dotfiles-config.ps1`.
Then run the Windows setup:

```powershell
& "$HOME/dotfiles-windows/main.ps1"
```

## Projects and worktrees

Store repositories under `~/code/work` or `~/code/personal`, with an optional language directory.
New worktrees use `worktrees/<repository>/<branch>` beside the original repository.
Branch directory names replace `/` with `-`. PR directories use `pr-<number>`.

| Original repository | Worktree for `feature/task` |
| ------------------- | --------------------------- |
| `~/code/work/python/repo` | `~/code/work/python/worktrees/repo/feature-task` |
| `~/code/personal/repo` | `~/code/personal/worktrees/repo/feature-task` |

Repositories outside these categories use `~/code/worktrees/<repository>/<branch>`.
The commands reuse an existing worktree for the requested branch.

### tmux

The tmux prefix is `Ctrl-t`. Press the prefix, then the shortcut key.

| Shortcut | Action |
| -------- | ------ |
| `f` | Select a repository or worktree |
| `b` | Select a local or remote branch |
| `a` | Select an active Codex pane |
| `H` | Open the Pi session through SSH alias `pi` |
| `D` | Remove the current managed worktree and its tmux sessions |

The repository picker reads `~/.config/tmux-session/dirs`.
Project sessions contain `nvim`, `shell`, and `codex` windows.
Worktree removal protects the main checkout and refuses local changes.

Use the same tools from a shell:

```bash
tsp                             # Pick a repository or worktree
tsp-branches                    # Pick a branch in the current repository
tsp-wt feature/task             # Open or create a branch worktree
tsp-wt --remote origin feature/task
tsp-pr OWNER/REPO 42 main feature/task
```

`tsp-wt` accepts an optional project directory after the branch name.
New branches start at the current HEAD unless a matching remote branch exists.
Fetch remote branches before selection.
`tsp-pr` uses `gh` to open a PR worktree.

### Project configuration

The Zsh loader reads `dotfiles-linux/zsh/projectrc/mappings.conf` at shell startup.
It selects snippets from `projectrc.d` for the original repository and current subdirectory.
Linked worktrees use the same project configuration.

The Zsh `codex` wrapper selects `~/.codex-personal` for repositories under `~/code/personal`.
Other repositories use `~/.codex`. An explicit `CODEX_HOME` takes precedence.
The selection also applies to linked worktrees.
The tmux status bar shows the selected Codex configuration.

Store user-owned Codex skills under `~/dotfiles-linux/codex/skills/<skill-name>`.
After a skill change, run `~/dotfiles-linux/codex/main` to install its symlink.
Project-specific, plugin-managed, and system skills retain their existing locations.

## Calendar setup

The laptop and Raspberry Pi each synchronize Outlook through their own DavMail, vdirsyncer, khal, and Khalorg installation.
Neovim uses `nvim-khalorg` for explicit event creation and edits.
The Pi serves generated Org agendas to Orgzly Revived through read-only WebDAV over Tailscale HTTPS.

### Local synchronization

`mycalsync` synchronizes `outlook_work` and `outlook_personal` and exports agendas from today through the next 365 days.
`calsync.timer` runs five minutes after each completed cycle.
Calendar storage is under `~/.local/share/calendar/`.
Generated agendas are under `~/.local/share/khalorg/agendas/`.
Scheduled jobs export calendar views without importing Org files.

If the credential vault is locked, run `rbw unlock` in a terminal before synchronization.
Run or inspect a cycle with:

```sh
mycalsync --verbose
systemctl --user status calsync.service calsync.timer
journalctl --user -u calsync.service --since today
```

### Neovim editing

Use the Orgmode export menu, `<leader>oe`:

| Action | Result |
| ------ | ------ |
| `n` | Create the selected calendar event |
| `e` | Edit its properties |
| `E` | Edit its properties and dates |
| `L` | List the calendar in an editable buffer |
| `C` | Choose a calendar to list |

The personal and work capture templates save local files under `~/.local/share/khalorg/inbox/`.
Save a new capture. Run `n`. Save again to retain its UID.
For an existing event, use `L` or `C` to open an editable view.
Save a local copy before you edit the event:

```vim
:saveas ~/.local/share/khalorg/inbox/outlook_work.org
```

If the inbox file contains unfinished work, choose another filename.
Retain the event UID.
Keep unfinished edits in the inbox, separate from the generated agendas.
Use Outlook to delete events.

After a successful edit, Neovim runs `mycalsync` to upload and refresh.
If the upload fails, retry `mycalsync` rather than creating the event again.

See the [local calendar guide](https://github.com/BartSte/dotfiles-linux/blob/master/dotfiles-linux/docs/calendars.md)
for configuration and troubleshooting.

### Orgzly Revived on Android

Enable Tailscale on the phone.
Add the Pi's HTTPS WebDAV endpoint as an Orgzly Revived repository with its dedicated username and password.
Download both calendar notebooks.
Enable the available options under Settings, Sync, Auto-sync.
Phone access is read-only. Downloaded notebooks remain available offline.

See the [Pi WebDAV setup](https://github.com/BartSte/dotfiles-pi/blob/main/dotfiles-pi/calendar-webdav/README.md)
for server setup, credentials, and Android configuration.

## Dropbox files

`~/dropbox/org` contains personal Org notes and their archives.
`~/dropbox/generated` contains files that scheduled jobs replace.
Do not edit generated files as personal notes.

| Files in `~/dropbox/generated` | Publisher on the Raspberry Pi |
| ----------------------------- | ----------------------------- |
| `activities.org` | `garmin-activities.timer` through Summit |
| `personal_records.org` | `garmin-update.timer` through Summit |
| `training-schedule.org`, `recent-training.csv` | Hermes training publisher |

The Pi publishes these generated files to the rclone remote named `dropbox`.
Its `dropboxpull.timer` downloads other Dropbox content every ten minutes.
It excludes `activities.org` and `personal_records.org` because Summit writes them locally.
On Arch Linux, `dropboxsync.timer` synchronizes `~/dropbox` in both directions through `rclone bisync`.

## Dotfiles commands

The Zsh configuration defines these Git commands for the bare repositories:

| Repository | Git command | Status command |
| ---------- | ----------- | -------------- |
| Base | `base` | `bases` |
| Linux | `lin` | `lins` |
| Arch | `linarch` | `linarchs` |
| Raspberry Pi | `linpi` | `linpis` |
| Private configuration | `secret` | `secrets` |

`dot` runs a Git command across the installed repositories. `dots` shows their status.
`dotc "message"` stages and commits the layer directories.
`dotu` commits, pulls, and pushes changes across the installed repositories.
Stage this README separately with `base add README.md`.
The Linux, Arch, Pi, and private repositories each own a README inside their layer directory.
