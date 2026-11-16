# Files synchronization

The Linux laptop and Android phone keep local working files.
Each device synchronizes with the same Files folder through SFTP over Tailscale.
No remote mount is required.

The repositories have separate responsibilities:

- `dotfiles`: initialization and this overview.
- `dotfiles-linux`: FreeFileSync configuration, client commands, and an inactive user timer.
- `dotfiles-arch`: FreeFileSync, Tailscale, OpenSSH, Python, and vault packages.

On Arch, run the normal Linux and Arch installers first.
Then use `~/dotfiles-linux/files/auth` to enroll the client.
See `~/dotfiles-linux/docs/ftpu-files.md` for pairing and verification.

Public repositories contain no device endpoints, passwords, or enrolled profiles.
Deletion propagation remains disabled. Enabling it later requires coordinated client changes and a recovery test.
