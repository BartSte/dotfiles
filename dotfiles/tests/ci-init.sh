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

arch_exists=false
pi_exists=false
[[ -d "$HOME/dotfiles-arch.git" ]] && arch_exists=true
[[ -d "$HOME/dotfiles-pi.git" ]] && pi_exists=true

if $arch_exists && $pi_exists; then
  echo "Both arch and pi layers present; expected only one."; exit 1;
fi
if ! $arch_exists && ! $pi_exists; then
  echo "No distro layer present; expected arch or pi."; exit 1;
fi

echo "init OK"
