# Windows ARM64 VM test build

Run these scripts from a Windows ARM virtual machine. They follow the
repository's GitHub Actions build command:

~~~powershell
cargo build --locked --release --target aarch64-pc-windows-msvc --workspace
~~~

The scripts build portable executables only. They do not run WiX, create an
installer, enable the ui_access feature, or use AzureSignTool/Azure Key Vault.

## Prerequisites

- Rust installed through rustup.
- The MSVC C++ ARM64 build tools installed. Visual Studio Build Tools with the
  C++ workload is sufficient.
- PowerShell 7 or Windows PowerShell.

## Build

~~~powershell
.\win-test\build.ps1 -VersionNumber 0.0.0-test
~~~

The ARM64 executables are produced in:

~~~
target\aarch64-pc-windows-msvc\release
~~~

## Publish a portable test bundle

~~~powershell
.\win-test\publish.ps1 -VersionNumber 0.0.0-test
~~~

This copies glazewm.exe, glazewm-cli.exe, and glazewm-watcher.exe when present,
then creates an unsigned ZIP in win-test\out.

Windows may show a SmartScreen warning because the executables are unsigned.
That is expected for this VM-only test bundle.
