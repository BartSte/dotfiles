#!/usr/bin/env bash
set -euo pipefail

# Run initialize in isolated HOME and assert expected artifacts.
export HOME="$GITHUB_WORKSPACE/_home"
mkdir -p "$HOME"

bash "$GITHUB_WORKSPACE/dotfiles/initialize"

# Assertions
[[ -d "$HOME/dotfiles.git" ]] || { echo "Missing bare repo: dotfiles.git"; exit 1; }
[[ -d "$HOME/dotfiles-linux.git" ]] || { echo "Missing bare repo: dotfiles-linux.git"; exit 1; }
[[ -f "$HOME/.dotfiles_config.sh" ]] || { echo "Missing .dotfiles_config.sh"; exit 1; }

# In CI (ubuntu-latest), we only expect base + linux layers.
if [[ -d "$HOME/dotfiles-arch.git" ]] || [[ -d "$HOME/dotfiles-pi.git" ]]; then
  echo "Unexpected distro layer present in CI."; exit 1;
fi

echo "init OK"
