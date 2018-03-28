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

function Start-Clean {
    $versions = 3,5
    $srcBase = Join-Path $PsScriptRoot src
    foreach ( $version in $versions ) {
        try {
            $srcDir = Join-Path $srcBase $version
            Push-Location $srcDir
            dotnet clean
            if ( test-path obj ) { remove-item -recurse -force obj }
            if ( test-path bin ) { remove-item -recurse -force bin }
            remove-item "PowerShellStandard.Library.${version}*.nupkg"
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

function Export-NuGetPackage
{
    # create the package
    # it will automatically build
    $versions = 3,5
    $srcBase = Join-Path $PsScriptRoot src
    foreach ( $version in $versions ) {
        try {
            $srcDir = Join-Path $srcBase $version
            Push-Location $srcDir
            $result = dotnet pack
            if ( ! $? ) {
                Write-Error -Message $result
            }
        }
        finally {
            Pop-Location
        }
    }

}
