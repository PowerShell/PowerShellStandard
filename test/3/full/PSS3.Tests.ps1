Describe "PowerShell Standard 3" {
    BeforeAll {
        $cmdletAssembly = "bin/Release/net452/Demo.Cmdlet.dll" 
        $assemblyPath = Join-Path "$PSScriptRoot" $cmdletAssembly
        $PSBin = (Get-Process -id $PID).MainModule.FileName
    }
    It "Can build a reference assembly" {
        dotnet restore
        dotnet build --configuration Release
        $assemblyPath | Should Exist
    }
    It "Can execute the compiled cmdlet" {
        $result = & $PSBin -c "import-module $assemblyPath; Get-Thing"
        $result | Should Be "success!"
    }
}
