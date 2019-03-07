Describe "Ensure that the created file versions match what is in the Signing.xml file" {
    BeforeAll {
        $baseDir = Resolve-Path (Join-Path $PsScriptRoot "..")
        $signingFilePath = Join-Path $baseDir "tools/releaseBuild/signing.xml"
        $signingXml = [xml](Get-Content $signingFilePath)
        $testCases = $signingXml.SelectNodes(".//file").src |
            Foreach-Object { @{ FileName = $_.split(([char[]]"/\"))[-1] } }
    }
    It "the file '<FileName>' should exist" -testcases $testCases {
        param ( $FileName )
        "$baseDir/$fileName" | Should -Exist
    }
}
