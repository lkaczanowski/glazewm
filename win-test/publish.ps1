[CmdletBinding()]
param(
  [string]$VersionNumber = "0.0.0",
  [string]$OutputDirectory = (Join-Path $PSScriptRoot "out")
)

$ErrorActionPreference = "Stop"

$target = "aarch64-pc-windows-msvc"
$buildScript = Join-Path $PSScriptRoot "build.ps1"
$sourceDirectory = Join-Path $PSScriptRoot "..\target\$target\release"
$publishDirectory = Join-Path $OutputDirectory "glazewm-$VersionNumber-$target"
$archivePath = Join-Path $OutputDirectory "glazewm-$VersionNumber-$target.zip"
$binaries = @("glazewm.exe", "glazewm-cli.exe", "glazewm-watcher.exe")

& $buildScript -VersionNumber $VersionNumber
if ($LASTEXITCODE -ne 0) {
  throw "Build script failed with exit code $LASTEXITCODE."
}

if (-not (Test-Path -LiteralPath (Join-Path $sourceDirectory "glazewm.exe"))) {
  throw "GlazeWM executable was not found in $sourceDirectory."
}

New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null

if (Test-Path -LiteralPath $publishDirectory) {
  Remove-Item -LiteralPath $publishDirectory -Recurse -Force
}

New-Item -ItemType Directory -Path $publishDirectory | Out-Null

foreach ($binary in $binaries) {
  $sourcePath = Join-Path $sourceDirectory $binary
  if (Test-Path -LiteralPath $sourcePath) {
    Copy-Item -LiteralPath $sourcePath -Destination $publishDirectory
  }
}

Compress-Archive -Path (Join-Path $publishDirectory "*") -DestinationPath $archivePath -Force

Write-Host "Published unsigned ARM64 executables to $publishDirectory"
Write-Host "Created portable archive: $archivePath"
