# BartSte dotfiles

Each dotfiles repository tracks this README. Their bare Git checkouts share the home directory.

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

### What each device does

The Raspberry Pi is the only Outlook bridge in this workflow.
It handles `outlook_personal` and `outlook_work`.
The laptop reads calendar files in Neovim and sends explicit edit requests to the Pi.
Android uses the Outlook app directly.

The read path is:

```text
Outlook -> DavMail and vdirsyncer on the Pi -> Org exports -> Dropbox -> laptop
```

The write path is separate:

```text
Local Neovim draft -> SSH alias pi -> calendar-submit on the Pi -> Outlook
```

Dropbox carries the calendar view, not edit requests.
Syncthing is not part of this setup.

### Files and schedules

The Pi stores its local calendar data under `~/.local/share/calendar/`.
It exports these files:

- `~/dropbox/generated/outlook_personal.org`
- `~/dropbox/generated/outlook_work.org`

`calsync.timer` runs every five minutes.
Its service runs `mycalsync`, exports both calendars, and uploads the exact files to Dropbox.
`dropboxpull.timer` copies Dropbox files back to the Pi every ten minutes.
The laptop uses its existing Dropbox sync.

The Org exports are read-only calendar views.
The Pi never treats their contents as automatic write requests.
A later export restores entries removed from these views.

### Edit an event in Neovim

1. Open an event from the agenda or an exported calendar file.
2. Run `:CalendarDraft` to create an editable local copy.
3. Edit and save the draft.
4. Run `:CalendarApply` to send the request to the Pi.
5. Save the draft after confirmation updates its event metadata.

The first release supports title, description, location, and date changes for plain, non-recurring events.
Use Outlook for invitations, recurring events, unsupported property changes, and ambiguous daylight-saving times.
The server rejects unsupported changes instead of silently ignoring them.

To create an event, use the personal or work capture template.
Save the local draft, then run `:CalendarNew` on its event heading.
Saving a draft alone does not create an Outlook event.

### Deletion safety

**Delete events in Outlook, not in Org.**

This workflow has no Neovim calendar-delete action.
Removing an Org entry, subtree, or exported file does not request an Outlook deletion.
An empty or damaged export is not a calendar write request either.

Drafts and pending requests stay outside Dropbox, under Neovim's local state directory:

- `calendar-bridge/drafts/` contains editable drafts.
- `calendar-bridge/pending/` contains saved requests and confirmed results.

Use `:echo stdpath('state')` to find that directory.
Dropbox cannot overwrite these local drafts.

### SSH, conflicts, and offline use

The laptop uses the literal SSH alias `pi`.
Its existing SSH configuration supplies the username, address, and key.
The separate `pi-ts` alias is not selected automatically.
Set `CALENDAR_BRIDGE_HOST` before starting Neovim to override the destination.

Test the connection from the laptop with:

```sh
ssh -o BatchMode=yes pi true
```

A successful connection produces no output.
The Pi also requires `~/.config/calendar-bridge/server`, containing its hostname.
This private marker enables the server role. Do not copy it to the laptop.

Each exported event has a UID and a `BRIDGE_BASELINE` value.
The baseline identifies the event version used for the draft.
If the calendar event changes, the Pi rejects a stale edit and keeps its pending text.
Start a fresh draft from the latest calendar view to resolve the difference manually.

Offline drafts remain local.
A failed submission also keeps its original request, with a unique request ID.
Retry the saved request with the command shown by Neovim:

```vim
:CalendarRetry <request-uuid>
```

A retry uses the original payload and request ID.
It does not create another event after a successful creation.
Do not remove the request ID to repeat an uncertain creation.

If the buffer changes during submission, Neovim preserves the saved result without replacing the newer buffer text.
A local save is not proof of an Outlook update.
Confirmation follows the Pi's outbound sync, another remote sync, and verification of the intended event fields.

### Android setup (manual)

1. Install or open Outlook for Android.
2. Add the personal and work accounts through the app's account settings.
3. Complete each account's normal sign-in steps.
4. Open Calendar and use its menu to enable both calendars.
5. Select Agenda view.
6. Confirm a known event from each account, including its date and time.
7. Confirm an all-day event as well.

Android does not need Org files, Syncthing, or a connection to the Pi.
Account access can depend on the work organization's rules.
See [Microsoft's Android account setup](https://support.microsoft.com/en-gb/outlook/install-mobile/set-up-email-in-the-outlook-for-android-app)
and [calendar quick start](https://support.microsoft.com/en-us/outlook/outlook-for-ios-and-android-quick-start).

### Checks and recovery

Check the Pi's service and schedule with:

```sh
systemctl --user status calsync.service calsync.timer
systemctl --user list-timers calsync.timer
```

Private server receipts live under `~/.local/state/calendar-bridge/requests/` by default.
Copies of replaced projection text live under `~/.local/state/calendar-bridge/projections/`.
Rollout snapshots live under `~/.local/state/calendar-bridge/backups/`.
Keep recovery files outside Dropbox. They contain private calendar text.

See the [calendar bridge guide](https://github.com/BartSte/dotfiles-linux/blob/master/dotfiles-linux/docs/calendar-bridge.md)
for supported operations and recovery details.
The [calendar tests](https://github.com/BartSte/dotfiles-linux/blob/master/dotfiles-linux/tests/calendar-sync/README.md)
use synthetic calendars and do not connect to Outlook.

## Dropbox files

`~/dropbox/org` contains personal Org notes and their archives.
`~/dropbox/generated` contains files that scheduled jobs replace.
Do not edit the files in `generated` as personal notes.

| Files in `~/dropbox/generated`                 | Publisher on the Raspberry Pi                       |
| ---------------------------------------------- | --------------------------------------------------- |
| `outlook_personal.org`, `outlook_work.org`     | `calsync.timer` runs `dotfiles-linux/bin/mycalsync` |
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
Stage this README separately in each repository that must receive the update.
