#!/usr/bin/env pwsh
param ( 
    [Parameter()][switch]$Clean,
    [Parameter()][switch]$Test,
    [Parameter()][switch]$Pack
)

import-module $PSScriptRoot/PowerShellStandard.psm1 -force

if ( $Clean ) {
    Start-Clean
    return
}

if ( $Pack ) {
    Export-NuGetPackage
}
else {
    Start-Build
}

if ( $Test ) {
    Invoke-Test
}

