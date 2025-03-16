﻿# Dotfiles BartSte

This readme is relevant for the following dotfiles repositories:

- BartSte/dotfiles
- BartSte/dotfiles-linux
- BartSte/doffiles-windows

Please read the following sections to get started with this repository. The
examples below are writing in bash and powershell.

## Dotfiles (cross-platform)

- No initialization needed. It only contains static dotfiles. Typically, you
  will not clone this repository by yourself, instead it will be cloned for you
  by the `dotfiles-linux` or the `dotfiles-windows` repositories, as they depend
  on it.

### Neovim (`dotfiles/nvim`)

Some directories of the neovim configuration could use some explanation:

- `dotfiles/nvim/lua`:
  - `helpers`: helper functions that are used in the other lua files.
  - `plugins`: plugins that are loaded by lazy.nvim
  - `config`: plugin configuration files.
- `dotfiles/nvim/vim`: plugin configuration files in vimscript.
- `dotfiles/nvim/plugin`: non-plugin configuration files that must be sourced
  before `after/plugin`.
- `dotfiles/nvim/after/plugin`: non-plugin configuration files.
- `dotfiles/nvim/after/ftplugin`: configuration files that are loaded after the
  filetype is detected.

## Dotfiles-linux (Arch linux)

### Installation

- To initialize the repository run the following line in a bash shell:

```bash
curl -O https://raw.githubusercontent.com/BartSte/dotfiles-linux/master/dotfiles-linux/initialize && bash ./initialize; rm ./initialize
```

- Complete the environment variables in `~/.dotfiles_config.sh`.
- Run the script: `~/dotfiles-linux/main`. This script first runs all the main
  files in the modules and later the auth files. User interaction is required at
  the start, to enable bitwarden, and at the end to enable the rest.

### Bitwarden

I use Bitwarden to store my passwords. The Bitwarden CLI can be used to
retrieve passwords from the command line. However, Bitwarden CLI has the issue
that is hangs for a second before it executes the command. Furthermore, a token
needs to be stored as an environment variable. Therefore, I use `rbw` which is
the unofficial Bitwarden CLI. The downside is that it is maintained by
volunteers which have limited time to fix bugs. As a solution, I created
`bw-cli-get`, whick can be used to get entries from the bitwarden vault. By
default, it uses `rbw`. If you set the environment variable `USE_BW_CLI`, then
it will use the official Bitwarden CLI `bw`.

### Mutt

I have two email accounts: personal and work. On all my devices, I only use one
of the two accounts. I have 1 muttrc file for both accounts. The differences in
configuration are handled by calling my password manager (rbw). The following
fields may be handled differently for each account:

- password: this is the password of the email account
- username: this is the username of the email account
- domain: this is the domain of the email account
- name: this is my real name
- calendar: this is the calendar that is used by khal
- contacts: this is the contacts that are used by khard
- MuttImapAuth: this is the imap auth method
- MuttClientId: this is the client id of the oauth2 script
- MuttSmtpAuth: this is the smtp auth method
- MuttPassword: this is the app password generated by Microsoft
- Signature (is added to the notes section of rbw)

Which account I am using, is determined by setting the environment variable
`MICROSOFTACCOUNT` to `MicrosoftPersonal` or `MicrosoftWork`. This variable is
set in the `.dotfiles_config.sh` file that is created when initializing the
`dotfiles-linux` repository.

The next sections explain the following:

- Authentication: how to authenticate the email accounts.
- Synchronization: how to sync the email accounts using IMAP and `mbsync`.
- Sending: how to send emails using SMTP and `mutt_oauth2`.
- Search: how to search through emails using `notmuch`.
- Mailsync: 1 command to sync and index all emails.

#### Authentication

Authentication can be done in three ways: using an app password (generated by
the email provider), using `davmail`, or using the `mutt_oauth2` script. The
oauth2 method is is supported by most email providers. Davmail is hard to setup,
and it is difficult to debug when things go wrong, so I use it as a last resort.

##### Oauth2

For my work email account, I use oauth2 for synchronizing my mailbox (IMAP) and
sending emails (SMTP) because the app password is not supported anymore.

The following steps are needed to get oauth2 working:

- Checkout the `dotfiles-linux/bin/mutt_oauth2` script. This script is used
  to initialize and refresh the oauth2 token.
- I got the script working by registering an application at Azure as described
  in the README at `dotfiles-linux/mutt/README.md`. I used the client_id from
  the `overview` page. I added the client_id and my email address to the
  password manager at the `MuttClientId` field. Next, I called the password
  manager from the `mutt_oauth2` scrip.
- I created 1 bash script that does the initialization for you:
  `dotfiles-linux/mutt/init_mutt_oauth2`. This script can be called once to
  initialize the `mutt_oauth2` script.
- I also created 1 bash script that uses the correct token:
  `dotfiles-linux/mutt/mutt_oauth2_with_token`.
- The `mutt_oauth2_with_token` script is added to the `mbsync` config file to
  enable imap authentication. See the section
  [Synchronization](#synchronization).
- The `mutt_oauth2_with_token` was also added `smtp_oauth_refresh_command` in
  my `.muttrc` file, to enable smtp authentication. See the section
  [Sending](#sending).

##### Davmail

Davmail is a gateway that can be used to connect to exchange servers. It can be
used to connect to the exchange server using, among others, IMAP.

In the past, I used davmail to connect to the exchange server. Now I use
`mutt_oauth2`, but it is good to keep `davmail` as a backup option.
Furthermore, davmail was also needed for khalorg and khard, so I had to
set it up anyway. Initializing davmail can be done as follows:

- The davmail configuration is located in the `dotfiles-linux/davmail` file. By
  running the `main` script in this folder, the davmail configuration is copied
  to the `~/.config/davmail` folder. Copying is needed because the davmail
  stores tokens in the config file so we do not want to put this on git.

- Next, run the following commands to start davmail:

  ```bash
  davmail ~/.config/davmail/davmail.properties
  ```

- Open another shell and run the following command:

  ```bash
  mbsync -a
  ```

- Head back to shell 1 and follow the instructions. If you are prompted with a
  message that states that "interactive" mode is not supported, you can change
  the davmail.properties setting `davmail.mode=O365Interactive` to
  `davmail.mode=O365Manual`.

- Once this step is succeeded, `mbsync` will start doing its work. The refresh
  token is stored in the `~/.config/davmail/davmail.properties` file. If this
  file is removed, the authentication process has to be repeated.

#### Synchronization

For IMAP synchronization, there are basically two options: use the built-in
IMAP synchronization of neomutt or use an external tool. When using the
former, the emails are not downloaded to your local machine. Instead, the
emails are downloaded on the fly when you open a folder. This is not ideal
when you want to search through your emails fast. Therefore, I use an external
tool: `mbsync` (part of the `isync` package). This tool operates next to
neomutt and downloads the emails to your local machine in `Maildir` format. I
have two config files for `mbsync`: `personal` and `work`. Based on the value
of the environment variable `MICROSOFTACCOUNT`, the correct config file is
used. The config files are located in `~/dotfiles-linux/isync`.

For my personal email account, I use an app password for authentication. For
my work email account, I use `mutt_oauth2` for authentication. To enable
XOAUTH2 for `mbsync`, I added the following package from the AUR:
`cyrus-sasl-xoauth2-git`.

#### Sending

For sending emails, I use the built-in SMTP functionality of neomutt. The smtp
url is set in the `.muttrc` file and is dependent on the value of the
`username` field in the password manager. Authentication is done using the
`mutt_oauth2` script. The `mutt_oauth2` script is called by the
`smtp_oauth_refresh_command` field in the `.muttrc` file. This field is set to
the `mutt_oauth2_with_token` script.

#### Search

For searching through emails, I use `notmuch`. Neomutt has built-in support for
`notmuch`, so it can be configured in the `.muttrc` file together with the
`.notmuch-config` file. I added a keybinding to a global search to my `.muttrc`
file. This keybinding calls the `notmuch search` command and is bound to the
`alt+A` key. The notmuch database can be updated by calling the `notmuch new`
command.

#### Mailsync

`davmail`, `mbsync` and `notmuch` are combined into 1 command: `mailsync`.
This makes updating the emails easier. Note that no davmail is needed when
using an app password or `mutt_oauth2`, so it is only activated when a davmail
config is presented as an argument.

### khal & khalorg

I use my work office calendar for all devices such that I have 1 calendar for
all meetings. The calendar is synchronized with a local directory using
`vdirsyncer`. This directory is then used by `khal` to interact with the
calendar. Since I like to use `org-mode`, I build an interface between `khal`
and `org-mode` called `khalorg`.

`vdirsyncer` can communicate with the exchange server using davmail. To initialize
davmail, see the [Davmail](#davmail) section. Once davmail is initialized, run
the following command to synchronize the calendar:

```bash
~/dotfiles-linux/khal/main
~/dotfiles-linux/khalorg/main
vdirsyncer discover
mycalsync
```

here, `mycalsync` is a script that combines `davmail`, `vdirsyncer`, `khalorg`.
As a results, it synchronizes my office calendar with a local org file that
holds all my meetings as text.

### khard

`khard` is a contact manager that can be used to interact with the exchange
server when it is used in combination with `davmail` and `vdirsyncer`. Once you
have setup `davmail` and `vdirsyncer` as described in the sections above, `khard`
will also be synced when het `mycalsync` script is called. You can check if
`khard` is working by running the following command:

```bash
khard list
```

#### Pinentry endless password input

I need do set many passwords: login, rbw, mail. I want to set 1 password for
all apps and I want to enter just 1 password. I still want to be able to use
pinentry for other apps in the future I guess. One hacky way could be:

- Create a personal `pinentry` program and put it at the front of the PATH.
- Check who is calling: if it is rbw or mail, echo the password (in the format
  pinentry expects). Otherwise, call the real pinentry program.

- Note, when possible, it is easier to do:

```bash
rbg get field | gpg --pinentry-mode loopback --batch --passphrase-fd 0 -d ./foo.txt.gpg
```

This will read the password from stdin, instead of using pinentry. This cannot
be done when you have no access to the command that is calling gpg.

### DNS

Custom DNS servers are set manually. This is done by disabling the
`systemd-resolved` service and enabling `NetworkManager`. Next, by setting
`dns=none` in het `[main]` section of the `NetworkManager.conf` file, the
`/etc/resolv.conf` file is not overwritten by `NetworkManager`. Now, we can
define the DNS servers ourselves. These server will be used by all connections.

### Productivity

In relation to the [dns](#dns) section, we can lock the DNS settings to prevent
them from being changed. This is useful when the dns servers act as an internet
filter, e.g., blocking pornographic websites. It works as follows:

- The `/etc/sudoers` file is set to:

  ```bash
  Defaults!/usr/bin/chattr rootpw
  %wheel ALL=(ALL) NOPASSWD: ALL, !/usr/bin/chattr
  ```

  Which means that the users in the wheel group can use `sudo` without a
  password, except for the `chattr` command. This command can only be executed
  from the root account.

- By logging in to the root account and running the `lock` script, the following
  files will be made immutable:

  - `/etc/sudoers` -> protects the `chattr` command
  - `/etc/resolv.conf` -> holds the DNS servers
  - `/etc/NetworkManager/NetworkManager.conf` -> holds the NetworkManager config

  By setting the root password to a long complex password, it will discourage
  you from changing the files.

- The `unlock` script can be used to make the files mutable again. This script
  can only be executed by the root account.

### Dotfiles-windows (Windows 10 & 11)

- To initialize the repository copy the following line into powershell:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force;
[bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544");
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/BartSte/dotfiles-windows/master/dotfiles-windows/initialize.ps1'))
```

- Complete the configuration file in `$HOME/dotfiles-windows/config.ps1`.
- Run the script: `$HOME/dotfiles-windows/main.ps1`
- All the subfolders of `$HOME/dotfiles-windows` are executed by calling the
  `main.ps1` file, e.g., `$HOME/dotfiles-windows/powershell/main.ps1`.

#### Alacritty

At the moment of this writing, Alacritty + tmux has issue rendering icons. This
is because Alacritty does not use the newest version of conPTY and
OpenConsole. Funny thing is, that when you install WezTerm on your machine, the
issue is solved. This is because WezTerm uses the newest version of conPTY and
OpenConsole. So you can either do this, or extract the conpty.dll and
OpenConsole.exe from the WezTerm installation and place them around the
alacritty.exe executable (and later remove wezterm).

## Background

The following sections explain how the 3 repositories work together.

### Bare repository

The text below was inspired on the following article of [atlassian](https://www.atlassian.com/git/tutorials/dotfiles). This article will also explain the difference between a normal repository and a bare repository.

Clone the project (dotfiles, dotfiles-linux, or dotfiles-windows) into a bare
repository. I will call the bare repository: `dotfiles.git`:

```powershell
git clone --bare <git-repo-url> $HOME/dotfiles.git
```

Add the following alias to your .bashrc:

```bash
alias base='/usr/bin/git --git-dir=$HOME/dotfiles.git/ --work-tree=$HOME'
```

Or to your $PSHome/profile.ps1:

```powershell
${function:base} = { git.exe --git-dir=$HOME\dotfiles.git\ --work-tree=$HOME @args }
```

where `base` can be replaced by a name you prefer, while the folder
`dotfiles.git` is the directory holding the bare repository.

Checkout the actual content from the bare repository to your $HOME:

```bash
base checkout
```

The step above might fail with a message like:

```
error: The following untracked working tree files would be overwritten by checkout:
    README.md
    .gitignore
Please move or remove them before you can switch branches.
Aborting
```

This is because your `$HOME` folder might already have some stock configuration
files which would be overwritten by git. The solution is simple: back up the
files if you care about them, remove them if you don't care, and try again.

Set the flag showUntrackedFiles to no on this specific (local) repository:

```bash
base config --local status.showUntrackedFiles no
```

You're done, from now on you can now type `base` commands to add and update
your dotfiles:

```base
base status
base add README.md
base commit -m "Add README.md"
base push
```

### Multiple layers

Using a bare repository allows you to working on multiple repositories in the
same folder. For dotfiles this is typically the `$HOME` folder. As such, the
repositories `dotfiles` `dotfiles-linux`, and `dotfiles-windows` should all be
created in a bare repository in the `$HOME` folder. I call them
`<repo-name>.git`. Here, the repository `dotfiles.git` can be interpreted as
the base layer, containing dotfiles that are cross-platform. On top of that, a
linux layer can be added, i.e., the `dotfiles-linux.git` bare repository. As an
example, the following code adds a file `.foo` to the `dotfiles` repository
(using the alias `base`), and a file `.bar` to the `dotfiles-linux` repostory
(using the alias `lin`):

```bash
base add .foo
lin add .bar
base commit -m "Add .foo"
lin commit -m "Add .bar"
base push
lin push
```

You will always need the base layer `dotfiles`. On top of that you can add an
OS specific repostory: `dotfiles-linux` or `dotfiles-windows`.

## References

This repos are inspired on the following projects:

- [dotfiles for windows](https://github.com/jayharris/dotfiles-windows)
- [polybar-connection](https://github.com/BartSte/polybar-collection)
- [polybar-bluetooth](https://github.com/msaitz/polybar-bluetooth)
- [mutt-oauth2](https://github.com/muttmua/mutt/blob/master/contrib/mutt_oauth2.py)
- [tmux-sessionizer](https://github.com/ThePrimeagen/.dotfiles/)
