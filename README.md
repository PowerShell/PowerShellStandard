# ![logo][] PowerShell Standard

## Supports PowerShell Core and Windows PowerShell

PowerShell Core is a cross-platform (Windows, Linux, and macOS) automation and configuration tool/framework that works well with your existing tools and is optimized for dealing with structured data (e.g. JSON, CSV, XML, etc.), REST APIs, and object models.
It includes a command-line shell, an associated scripting language and a framework for processing cmdlets.

Windows PowerShell is a Windows command-line shell designed especially for system administrators.
Windows PowerShell includes an interactive prompt and a scripting environment that can be used independently or in combination.

The PowerShell Standard has been created to assist developers create modules and PowerShell hosts which will use only APIs that exist across different versions of PowerShell.

## PowerShell Standard Libraries

Two PowerShell Standard `.nupkg` versions are available:

- PowerShell Standard.Library Version 3
  - This allows you to create PowerShell modules and host which will run on PowerShell Version 3 and later including PowerShellCore

- PowerShell Standard.Library Version 5.1
  - This allows you to create PowerShell modules and host which will run on PowerShell Version 5.1 and later including PowerShellCore

Both are available on [NuGet.org](https://www.nuget.org/packages/PowerShellStandard.Library)

[logo]: https://raw.githubusercontent.com/PowerShell/PowerShell/master/assets/Powershell_black_64.png

### Building PowerShell Standard Libraries

The script `build.ps1` is the tool to build, package, and test the PowerShell Standard Libraries.
In to build the PowerShell Standard Libraries simply type:

```powershell
./build.ps1
```

### Running tests

There are some very simple tests which test the validity of the PowerShell Standard Libraries.
These tests may be found in the test directory associated with the version of the PowerShell Standard Library
| Version | Location |
| 3 | `test/3` |
| 5 | `test/5` |

to run the tests, simply type:

```powershell
./build.ps1 -test
```

### Creating NuGet Packages

In order to create NuGet packages, simply type:

```powershell
./build.ps1 -Pack
```

This will create 2 NuGet packages; 1 for each version of the PowerShell Standard Library in the root of the repository.
These can then be uploaded to https://nuget.org/ if desired.

### Removing Build Artifacts

To remove all build artifacts (except for the .nuget files in the root of the repository), type the following:

```powershell
./build.ps1 -Clean
```
