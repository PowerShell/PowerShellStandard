function Start-Build {
    $versions = 3,5
    $srcBase = Join-Path $PsScriptRoot src
    foreach ( $version in $versions ) {
        try {
            $srcDir = Join-Path $srcBase $version
            Push-Location $srcDir
            dotnet restore
            dotnet build
        }
        finally {
            Pop-Location
        }
    }

    
}

function Invoke-Test {
    try {
        $testBase = Join-Path $PsScriptRoot test
        Push-Location $testBase
        Invoke-Pester
    }
    finally {
        Pop-Location
    }
}

function Export-NPKG
{
    if ( ! (get-command nuget.exe) ) { 
        Throw "nuget.exe not found, packages cannot be created"
    }
    # be sure we've built
    Start-Build
    # build the packages
    $versions = 3,5
    $srcBase = Join-Path $PsScriptRoot src
    foreach ( $version in $versions ) {
        try {
            $srcDir = Join-Path $srcBase $version
            Push-Location $srcDir
            $result = nuget.exe pack PowerShellStandard.Library.nuspec 2>&1
            if ( ! $? ) {
                Write-Error -Message $result
            }
        }
        finally {
            Pop-Location
        }
    }

}
