# BartSte dotfiles

The base repository owns this overview. Each layer owns a README inside its own directory.
The bare Git checkouts share the home directory, so each file path must have one owner.

These repositories put configuration files in the home directory:

| Repository         | Purpose                                                                         |
| ------------------ | ------------------------------------------------------------------------------- |
| `dotfiles`         | Base files, Neovim configuration, and Linux and Windows initialization scripts  |
| `dotfiles-linux`   | Linux configuration for the shell, Git, mail, calendars, Codex, and other tools |
| `dotfiles-arch`    | Arch packages, Sway, Waybar, DNS, firewall, and systemd units                   |
| `dotfiles-pi`      | Raspberry Pi packages, services, network setup, and application setup           |
| `dotfiles-windows` | Windows and PowerShell setup                                                    |
| `dotfiles-secret`  | Optional private configuration, including Codex and qutebrowser files           |

The Linux initializer checks out the selected repositories into `$HOME` from separate bare Git repositories.
It installs the base and Linux layers, then selects the Arch or Raspberry Pi layer.
It also tries to check out `dotfiles-secret` when access is available.

The private `dotfiles-hermes` workspace is separate from `dotfiles-secret`.
The Raspberry Pi setup runs `~/dotfiles-hermes/main` when that workspace exists.

## Linux installation

Run the initializer on Arch Linux or a Raspberry Pi:

```bash
curl -fsSLo /tmp/dotfiles-initialize https://raw.githubusercontent.com/BartSte/dotfiles/master/dotfiles/initialize
bash /tmp/dotfiles-initialize
```

The initializer can replace tracked files in your home directory.
It creates `~/.dotfiles_config.sh` when that file does not exist.
Set the values that you use before you run the setup scripts:

```bash
export BWEMAIL=
export MICROSOFT_ACCOUNT=
```

Run the common setup, then the setup for your machine:

```bash
~/dotfiles-linux/main
~/dotfiles-arch/main    # Arch Linux
# or
~/dotfiles-pi/main      # Raspberry Pi
```

Run `~/dotfiles-linux/auth` for interactive login and pairing steps.
The `main` scripts run module setup and can install packages or request input.
The `auth` scripts handle services such as Bitwarden, Git, calendars, and Dropbox.

## Windows installation

The Windows initializer is in the base repository at `dotfiles/initialize.ps1`.
Run it in PowerShell:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/BartSte/dotfiles/master/dotfiles/initialize.ps1'))
```

If the initializer did not create `$HOME/dotfiles-config.ps1`, copy the template:

```powershell
Copy-Item "$HOME/dotfiles-windows/default_config.ps1" "$HOME/dotfiles-config.ps1"
```

Edit the values in `$HOME/dotfiles-config.ps1`, then run:

```powershell
& "$HOME/dotfiles-windows/main.ps1"
```

The Windows setup uses the base and Windows repositories.
It needs `$HOME/dotfiles-config.ps1` before `main.ps1` runs.

## Repository contents

### Base: `dotfiles`

`dotfiles/nvim` contains the Neovim configuration.
Its Lua configuration uses `lua/before`, `lua/config`, `lua/helpers`, `lua/plugins`, and `lua/after`.
The `vim` and `queries` directories contain Vim configuration and Tree-sitter queries.
The base repository also contains qutebrowser files and the two initialization scripts.

### Linux: `dotfiles-linux`

This layer contains Zsh, tmux, Git, NeoMutt, isync, vdirsyncer, khal, khalorg, khard, Codex, and command-line scripts.
Mail configuration is under `dotfiles-linux/mutt`.
Calendar configuration is under `dotfiles-linux/vdirsyncer`, `khal`, and `khalorg`.
The `MICROSOFT_ACCOUNT` value selects the NeoMutt account.
The configuration reads credentials with `bw-cli-get` or `rbw`.

### Arch: `dotfiles-arch`

This layer contains package lists and setup for Sway, Waybar, DNS, firewall rules, qutebrowser, and systemd units.
The `dropboxsync.timer` unit belongs to this layer.

### Raspberry Pi: `dotfiles-pi`

This layer contains apt, network, Tailscale, UFW, pipx, and systemd setup.
It also contains setup modules for Summit, Hermes, and the grocery agent.
The Hermes module runs the separate private workspace when that workspace exists.

### Windows: `dotfiles-windows`

`main.ps1` configures PowerShell, dependencies, Windows settings, Git, Neovim, Alacritty, KMonad, Caps Lock, and qutebrowser.
Its `default_config.ps1` is a template for the local `dotfiles-config.ps1` file.

### Private configuration

`dotfiles-secret` holds versioned private configuration, including Codex configuration and qutebrowser URLs.
Keep passwords and API tokens in a credential store such as `rbw`.
Do not commit them to the dotfiles repositories.

## Projects and worktrees

Repositories under `~/code/work` and `~/code/personal` can have an optional language folder, such as `python`, `shell`, or `kt`.
New worktrees use a `worktrees` folder beside the original repository.
The source path determines the category and language. The commands do not detect the programming language.

| Original repository          | New branch worktree                                  |
| ---------------------------- | ---------------------------------------------------- |
| `~/code/work/python/repo`    | `~/code/work/python/worktrees/repo--feature-task`    |
| `~/code/personal/shell/repo` | `~/code/personal/shell/worktrees/repo--feature-task` |
| `~/code/work/repo`           | `~/code/work/worktrees/repo--feature-task`           |
| `~/code/personal/repo`       | `~/code/personal/worktrees/repo--feature-task`       |

Branch worktree names use `repo--branch`, with `/` replaced by `-` in the branch name.
PR worktree names use `repo--pr-NUMBER`, and the worktree uses the PR source branch.
Repositories outside the work and personal categories use `~/code/worktrees`.
Existing worktrees retain their current paths. The commands reopen a worktree when the requested branch already has one.
Commands run from a linked worktree use the original repository to determine the destination.

### tmux commands

The tmux prefix is `Ctrl-t`. Press the prefix, then the shortcut key.

| Shortcut | Action                                                                           |
| -------- | -------------------------------------------------------------------------------- |
| `f`      | Open the fzf picker for repositories and worktrees                               |
| `b`      | Open the fzf picker for local and remote branches in the current repository      |
| `a`      | Open the picker for active Codex panes                                           |
| `D`      | Remove the current managed worktree and its tmux sessions if Git permits removal |

The repository picker reads `~/.config/tmux-session/dirs`.
The installed configuration includes work repositories, personal repositories, and the legacy `~/code/worktrees` folder.
The picker finds worktrees in the category and language folders.
The branch picker creates a worktree or opens the existing checkout for the selected branch.
Remote selections create local branches that track the selected remote branch.
New project sessions contain `nvim`, `shell`, and `codex` windows.
The removal command protects the main checkout and does not force removal of worktrees with local changes.

Use these commands from a shell:

```bash
tsp                             # Pick a repository or worktree
tsp-branches                    # Pick a branch in the current repository
tsp-wt feature/task             # Open or create a branch worktree
tsp-wt --remote origin feature/task
tsp-pr OWNER/REPO 42 main feature/task
```

`tsp-wt` accepts an optional project directory after the branch name.
New branches start at the current HEAD unless a matching remote branch exists.
`tsp-pr` resolves the repository through the same directory configuration and uses `gh` to check out the PR.

### Project configuration

The Zsh loader reads `dotfiles-linux/zsh/projectrc/mappings.conf` at shell startup.
It selects snippets from `dotfiles-linux/zsh/projectrc/projectrc.d` with the original checkout path and the relative subdirectory.
This keeps project-specific configuration available in both grouped and legacy worktrees.
The loader does not reload snippets after a directory change.
On WSL, work Python projects use the Windows virtual environment associated with the original repository.

The Zsh `codex` wrapper selects `~/.codex-personal` for original checkouts under `~/code/personal`.
Other paths use `~/.codex`. An explicit `CODEX_HOME` takes precedence.
The wrapper selects the account for each invocation, including directory overrides and calls from linked worktrees.
For the active Codex pane, the tmux status bar shows `Codex: Work` or `Codex: Personal`.
The label uses the running process's `CODEX_HOME`, including explicit overrides. Other configuration directories show `Codex: Custom`.
The label identifies the selected configuration directory. It does not verify the credentials stored there.
Grouped worktrees also remain under the existing ancestor `AGENTS.md` files for their category and language.

User-owned general-purpose Codex skills belong in `~/dotfiles-linux/codex/skills/<skill-name>`.
After a skill change, run `~/dotfiles-linux/codex/main` to install its symlink under `~/.codex/skills`.
Project-specific, plugin-managed, and Codex-managed system skills retain their existing locations.

## Calendar setup

The laptop and Raspberry Pi each connect to Outlook independently.
Each machine uses its own DavMail, vdirsyncer, khal storage, and Khalorg installation.
Outlook carries calendar changes between the machines.
The laptop does not need the Pi for calendar edits or synchronization.

```text
Each machine: Outlook <-> DavMail <-> vdirsyncer <-> khal -> khalorg -> local Org agendas
Laptop edits: Neovim -> nvim-khalorg -> local khal -> vdirsyncer -> Outlook
Phone reads:  Pi Org agendas -> read-only WebDAV over Tailscale HTTPS -> Orgzly Revived
```

### Local synchronization

`mycalsync` synchronizes `outlook_work` and `outlook_personal` sequentially.
The two DavMail profiles use the same port, so they cannot run together.
`calsync.timer` runs five minutes after the previous cycle finishes on each machine.
Run a cycle manually with:

```sh
mycalsync --verbose
systemctl --user status calsync.service calsync.timer
journalctl --user -u calsync.service --since today
```

The local calendar storage is under `~/.local/share/calendar/`.
The generated agendas are `~/.local/share/khalorg/agendas/outlook_personal.org` and `outlook_work.org`.
An explicit `XDG_DATA_HOME` changes the agenda root on the laptop.
The Pi WebDAV unit serves the standard path shown here.
The export range is today through the next 365 days.
Exports replace files atomically after success. Failed exports retain the previous file.
Unchanged exports retain their modification times.

Scheduled jobs never import Org files.
An empty, missing, damaged, or deleted Org agenda cannot request an Outlook event change.
Vdirsyncer still synchronizes calendar storage in both directions; it also uploads explicit local edits.
Keep Outlook as the event deletion interface.

If `rbw` supplies credentials, unlock its vault in an interactive terminal before background sync:

```sh
rbw unlock
systemctl --user start calsync.service
```

A locked vault blocks synchronization. A background service cannot answer an interactive password prompt.
Existing exported agendas remain available until authentication works again.

Preserve each machine's live DavMail authentication settings.
The laptop and Pi can use different authentication modes.
Do not run the complete vdirsyncer installer to repair one setting: it copies authentication templates.

### Neovim editing

The existing `nvim-khalorg` plugin provides event operations.
`khalorg-local` shares a local lock with `calsync` and blocks whole-file sync and deletion.
The dotfiles contain calendar routing and refresh configuration, without a second calendar client.

Use the Orgmode export menu, `<leader>oe`:

| Action | Result |
| ------ | ------ |
| `n` | Create the selected event in the local calendar |
| `e` | Edit the selected event's properties |
| `E` | Edit its properties and dates |
| `L` | List the calendar in an editable buffer |
| `C` | Choose a calendar to list |

The personal and work capture templates write to `~/.local/share/khalorg/inbox/`.
These files remain local and never enter the generated agenda directory.
Save a new capture, run `n`, then save again to retain the UID that the plugin adds.
Existing UIDs block accidental creation of the same captured event.

For an existing event, run `L` or `C` to obtain an editable view.
Save the view to the appropriate inbox file before editing:

```vim
:saveas ~/.local/share/khalorg/inbox/outlook_work.org
```

If that inbox file already contains unfinished work, choose another local filename.
For an unrecognized filename, the menu asks which calendar to use.
Retain the event UID, edit the selected event, and run `e` or `E`.
Generated agenda buffers resist accidental writes with the normal `:write` command.
Keep unfinished edits in the inbox rather than forcing a write to a generated agenda.

After a successful action, Neovim runs `mycalsync` locally.
If the upload fails, keep the saved event and retry `mycalsync` after the connection recovers.
Do not repeat event creation to retry an upload.
Modified buffers remain intact during refresh; resolve any disk-change prompt before replacing their text.

Local capture editing works offline. Outlook upload waits for a working connection.
This version does not add durable request receipts or cross-device conflict resolution.
Refresh before editing an existing event. Avoid concurrent edits to that event from different devices.

### Orgzly Revived on Android

The Pi serves only the two generated agendas through authenticated, read-only WebDAV.
WebDAV transfers Org files. CalDAV is not the phone interface for this setup.
Tailscale Serve provides HTTPS inside the tailnet, without public internet exposure.

See the [Pi WebDAV setup](https://github.com/BartSte/dotfiles-pi/blob/main/dotfiles-pi/calendar-webdav/README.md)
for credentials, endpoint discovery, automatic sync settings, and phone acceptance checks.
Enable Tailscale on the phone before synchronization.
The phone keeps downloaded notebooks available offline.
Phone edits cannot change the Pi exports or Outlook.

Orgzly Revived supports WebDAV auto-sync, as recorded in its
[changelog](https://www.orgzlyrevived.com/changelog).
Enable the available auto-sync triggers under Settings, Sync, Auto-sync.
Check the installed app's options rather than assuming a fixed background refresh interval.

### Migration and recovery

Private snapshots live under `~/.local/state/calendar-simplify/backup-*/` on each machine.
They preserve calendar storage, sync state, live configuration, and previous bridge state.
Older bridge drafts and pending requests remain recovery data; nothing replays them automatically.
Inspect unfinished work manually before applying an event through the local plugin.
Do not upload old calendar snapshots over current Outlook data.

The SSH calendar commands, custom Neovim bridge, and Python mutation backend are removed.
Calendar publication no longer uses Dropbox.
Other Org notes, generated training files, and Dropbox services retain their existing workflow.
The [calendar checks](https://github.com/BartSte/dotfiles-linux/blob/master/dotfiles-linux/tests/calendar-sync/README.md)
use synthetic calendar data and never create Outlook test events.

## Dropbox files

`~/dropbox/org` contains personal Org notes and their archives.
`~/dropbox/generated` contains files that scheduled jobs replace.
Do not edit the files in `generated` as personal notes.

| Files in `~/dropbox/generated`                 | Publisher on the Raspberry Pi                       |
| ---------------------------------------------- | --------------------------------------------------- |
| `activities.org`                               | `garmin-activities.timer` runs Summit               |
| `personal_records.org`                         | `garmin-update.timer` runs Summit                   |
| `training-schedule.org`, `recent-training.csv` | The Hermes training schedule publisher              |

The Pi service definitions live in `dotfiles-pi/systemd/user`.
The Pi publishes generated files to Dropbox.
Its `dropboxpull.timer` copies remote files to `~/dropbox`.
That pull excludes `activities.org` and `personal_records.org` because Summit writes them locally.

On Arch Linux, `dropboxsync.timer` runs `rclone bisync` between Dropbox and `~/dropbox`.
It syncs both `org` and `generated`.
The Dropbox remote is named `dropbox` in the rclone configuration.

## Bare Git repositories

`dotfiles-linux/zsh/git.zsh` defines these commands:

| Repository            | Git command | Status command |
| --------------------- | ----------- | -------------- |
| Base                  | `base`      | `bases`        |
| Linux                 | `lin`       | `lins`         |
| Arch                  | `linarch`   | `linarchs`     |
| Raspberry Pi          | `linpi`     | `linpis`       |
| Private configuration | `secret`    | `secrets`      |

`dot` runs a Git command across the available repositories.
`dots` shows their status.
`dotc` commits changes in the available repositories, and `dotu` commits, pulls, and pushes them.
`dotc` stages the layer directories, but it does not stage this root README.
Stage this overview only in the base repository with `base add README.md`.
Each other repository tracks its own `<layer>/README.md`.
When migrating another checkout, preserve its README content before pulling a root README removal.
After pulling those removals, use `base restore -- README.md` if Git deletes the overview.
Layer READMEs inside directories do not appear automatically as GitHub repository front pages.
