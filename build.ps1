#!/usr/bin/env pwsh
param ( 
    [Parameter(ParameterSetName="Clean")][switch]$Clean,
    [Parameter(ParameterSetName="Test")][switch]$Test
)

import-module $PSScriptRoot/PowerShellStandard.psm1 -force

if ( $Clean ) {
    Start-Clean
    return
}

Start-Build

if ( $Test ) {
    Invoke-Test
}

