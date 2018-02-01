Describe "PowerShell Standard 5" {
    BeforeAll {
        $cmdletAssembly = "bin/Debug/netstandard2.0/Demo.Cmdlet.dll" 
        $assemblyPath = Join-Path "$PSScriptRoot" $cmdletAssembly
        $PSBin = (Get-Process -id $PID).MainModule.FileName
    }
    It "Can build a reference assembly" {
        try {
            Push-Location $PSScriptRoot
            dotnet restore
            dotnet build
            $assemblyPath | Should Exist
        }
        finally {
            Pop-Location
        }
    }
    It "Can execute the compiled cmdlet" {
        $result = & $PSBin -c "import-module $assemblyPath; Get-Thing"
        $result | Should Be "success!"
    }
}
