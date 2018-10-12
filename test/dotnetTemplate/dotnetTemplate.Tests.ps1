Describe "PowerShell Standard C# Module Template" {
    Context "Targeting PowerShell Standard 5.1" {
        BeforeAll {
            $testFolder = "./foo"
            $publishDir = "./bin/Release/netstandard2.0/publish/"
            $PSBin = (Get-Process -id $PID).MainModule.FileName

            $FavoriteNumber = 4
            $FavoritePet = "Cat"
            $DefaultFavoritePet = "Dog"
        
            dotnet new -i "$PSScriptRoot/../../src/dotnetTemplate/Microsoft.PowerShell.Standard.Module.Template/Microsoft.PowerShell.Standard.Module.Template/"
            New-Item $testFolder -ItemType Directory
            Push-Location $testFolder
            dotnet new psmodule
        }
        It "Can package the module that was created" {
            dotnet publish --configuration Release
            $LASTEXITCODE | Should -Be 0
            Test-Path $publishDir | Should -BeTrue
            Test-Path foo.csproj | Should -BeTrue
            Test-Path TestSampleCmdletCommand.cs | Should -BeTrue
            Test-Path obj | Should -BeTrue
        }
        It "Can execute the compiled cmdlet" {
            $result = & $PSBin -o XML -c "import-module $publishDir/foo.dll; (Test-SampleCmdlet -FavoriteNumber $FavoriteNumber)"
            $result.FavoriteNumber | Should -Be $FavoriteNumber
            $result.FavoritePet | Should -Be "Dog"
            
            $result = & $PSBin -o XML -c "import-module $publishDir/foo.dll; (Test-SampleCmdlet -FavoriteNumber $FavoriteNumber -FavoritePet $FavoritePet)"
            $result.FavoriteNumber | Should -Be $FavoriteNumber
            $result.FavoritePet | Should -Be "Cat"
        }
        AfterAll {
            dotnet new -u "$PSScriptRoot/../../src/dotnetTemplate/Microsoft.PowerShell.Standard.Module.Template/Microsoft.PowerShell.Standard.Module.Template/"
            Pop-Location
            Remove-Item -Path ./foo -Recurse
        }
    }

    Context "Targeting PowerShell Standard 3" {
        BeforeAll {
            $testFolder = "./foo"
            $publishDir = "./bin/Release/netstandard2.0/publish/"
            $PSBin = (Get-Process -id $PID).MainModule.FileName

            $FavoriteNumber = 4
            $FavoritePet = "Cat"
            $DefaultFavoritePet = "Dog"
        
            dotnet new -i "$PSScriptRoot/../../src/dotnetTemplate/Microsoft.PowerShell.Standard.Module.Template/Microsoft.PowerShell.Standard.Module.Template/"
            New-Item $testFolder -ItemType Directory
            Push-Location $testFolder
            dotnet new psmodule -v 3.0.0-preview-02
        }
        It "Can package the module that was created" {
            dotnet publish --configuration Release
            $LASTEXITCODE | Should -Be 0
            Test-Path $publishDir | Should -BeTrue
            Test-Path foo.csproj | Should -BeTrue
            Test-Path TestSampleCmdletCommand.cs | Should -BeTrue
            Test-Path obj | Should -BeTrue
        }
        It "Can execute the compiled cmdlet" {
            $result = & $PSBin -o XML -c "import-module $publishDir/foo.dll; (Test-SampleCmdlet -FavoriteNumber $FavoriteNumber)"
            $result.FavoriteNumber | Should -Be $FavoriteNumber
            $result.FavoritePet | Should -Be "Dog"
            
            $result = & $PSBin -o XML -c "import-module $publishDir/foo.dll; (Test-SampleCmdlet -FavoriteNumber $FavoriteNumber -FavoritePet $FavoritePet)"
            $result.FavoriteNumber | Should -Be $FavoriteNumber
            $result.FavoritePet | Should -Be "Cat"
        }
        AfterAll {
            dotnet new -u "$PSScriptRoot/../../src/dotnetTemplate/Microsoft.PowerShell.Standard.Module.Template/Microsoft.PowerShell.Standard.Module.Template/"
            Pop-Location
            Remove-Item -Path ./foo -Recurse
        }
    }
}
