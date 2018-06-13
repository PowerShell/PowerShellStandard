param ( [string]$target )
if ( ! (test-path ${target} ) ) {
    new-item -type directory ${target}
}
else {
    if ( test-path -pathtype leaf ${target} ) {
        remove-item -force ${target}
        new-item -type directory ${target}
    }
}
push-location C:/PowerShellStandard
./build.ps1 -pack
Copy-Item -verbose C:/PowerShellStandard/*.nupkg ${target}
