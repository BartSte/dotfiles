function Install-Scoop {
    if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
        Set-ExecutionPolicy Bypass -Scope Process -Force;
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
        iex (iwr -useb get.scoop.sh)
    }
}

function clone($repo, $directory) {
    git clone --bare $repo $directory
}

function checkout($directory) {
    git --work-tree=$env:USERPROFILE --git-dir=$directory checkout
}

$github="https://github.com/BartSte" 

$base="$github/dotfiles.git" 
$base_dir="/dotfiles.git"

$win="$github/dotfiles-windows.git"
$win_dir="/dotfiles-windows.git"

$secret="$github/dotfiles-secret.git"
$secret_dir="/dotfiles-secret.git"

Write-Host "# Installing scoop"
Install-Scoop

Write-Host "# Installing git"
scoop install git

Write-Host "# Clone BartSte/dotfiles.git as a bare repository"
Write-Host $base
clone $base $base_dir -and checkout $base_dir

Write-Host "# Clone BartSte/dotfiles-windows.git as a bare repository"
Write-Host $win
clone $win $win_dir -and checkout $win_dir

Write-Host "# Clone BartSte/dotfiles-secret.git as a bare repository (optional)"
Write-Host $secret
if (-not (Test-Path $secret_dir)) {
    try {
        git clone --bare $secret $secret_dir | Out-Null
        checkout $secret_dir
    } catch {
        Write-Host "Note: could not clone private repo dotfiles-secret (skipping)."
        Write-Host "      You can clone it later with:"
        Write-Host "        git clone --bare $secret $secret_dir"
    }
} else {
    checkout $secret_dir
}

if (-not (Test-Path "$env:USERPROFILE/dotfiles-windows/default_config.ps1")) {
    Copy-Item "$env:USERPROFILE/dotfiles-windows/default_config.ps1" "$env:USERPROFILE/dotfiles-config.ps1"
}

Write-Host "# Please complete the file /dotfiles-config.ps1"
Write-Host "# Next, run the ~/dotfiles-windows/main.ps1"
