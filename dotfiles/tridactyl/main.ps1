$ErrorActionPreference = 'Stop'

$sourceFile = Join-Path $PSScriptRoot '.tridactylrc'
$targetFile = Join-Path $HOME '.tridactylrc'

if (-not (Test-Path -LiteralPath $sourceFile -PathType Leaf)) {
    throw "Tridactyl config not found: $sourceFile"
}

if (Test-Path -LiteralPath $targetFile -PathType Container) {
    throw "Tridactyl target is a directory: $targetFile"
}

Copy-Item -LiteralPath $sourceFile -Destination $targetFile -Force
Write-Host "Installed $targetFile"
