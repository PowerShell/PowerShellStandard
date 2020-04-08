#!/usr/bin/env pwsh
param ( 
    [Parameter(HelpMessage="Remove earlier built versions")][switch]$Clean,
    [Parameter(HelpMessage="Run the tests")][switch]$Test,
    [Parameter(HelpMessage="Create a .nupkg")][switch]$Pack,
    [Parameter(HelpMessage="Build only for netstandard2.0")][switch]$CoreOnly
)

Write-Progress -Activity "Importing module"
import-module $PSScriptRoot/PowerShellStandard.psm1 -force

if ( $Clean ) {
    Start-Clean
    return
}

# It would be great if there were targeting frameworks for net452
# on non-Windows platforms, but for now, if you're linux or macOS
# we'll build only core
if ( $IsLinux -or $IsMacOS ) {
    $CoreOnly = $true
}

Write-Progress -Activity "Starting Build"
if ( $Pack ) {
    if ( $CoreOnly ) {
        Write-Warning "Must build both netstandard2.0 and net452 to build package"
        throw "Build on a Windows system with netstandard and net452 target platforms"
    }
    Export-NuGetPackage
}
else {
    Start-Build -CoreOnly:$CoreOnly
}

if ( $Test ) {
    if ( $psversiontable.psversion.major -lt 6 ) {
        throw "Must run tests on PowerShell Core 6 or above"
    }
    Invoke-Test -CoreOnly:$CoreOnly
}

