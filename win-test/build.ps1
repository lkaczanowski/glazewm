[CmdletBinding()]
param(
  [string]$VersionNumber = "0.0.0"
)

$ErrorActionPreference = "Stop"

$target = "aarch64-pc-windows-msvc"
$repoRoot = Split-Path -Parent $PSScriptRoot
$originalVersionNumber = $env:VERSION_NUMBER

function Invoke-NativeCommand {
  param([scriptblock]$Command, [string]$Description)

  & $Command
  if ($LASTEXITCODE -ne 0) {
    throw "$Description failed with exit code $LASTEXITCODE."
  }
}

Push-Location $repoRoot
try {
  # Match the nightly toolchain used by the GitHub Actions build workflow.
  Invoke-NativeCommand {
    rustup target add $target --toolchain nightly
  } "Installing Rust target $target"

  # Build the WM, CLI, and Windows watcher. This intentionally does not
  # enable the ui_access feature, which requires a signed executable.
  $env:VERSION_NUMBER = $VersionNumber
  Invoke-NativeCommand {
    cargo build --locked --release --target $target --workspace
  } "Building GlazeWM for $target"

  Write-Host "Built executables: target\$target\release"
}
finally {
  if ($null -eq $originalVersionNumber) {
    Remove-Item Env:VERSION_NUMBER -ErrorAction SilentlyContinue
  }
  else {
    $env:VERSION_NUMBER = $originalVersionNumber
  }

  Pop-Location
}
