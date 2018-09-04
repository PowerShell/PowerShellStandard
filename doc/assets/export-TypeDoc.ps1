$tlist = Import-CSV TypeComparison.csv
@'
# PowerShell Standard Library 5

'@

$unavailableHeader = @'
## Unavailable Types

There are a number of types which while exist in both PowerShell 5.1 and PowerShell 6, have been excluded from PowerShell Standard 5.
The following lists the reason for exclusion and types excluded from PowerShell Standard 5.

'@

$unavailableTypes = $tlist |Where-Object {$_.PowerShell51 -eq "True" -and $_.PowerShell61 -eq "True" -and $_.PSStandard5 -eq "False"}

$unavailableHeader
$unavailableTypes | Sort-Object ExclusionReason | Group-Object ExclusionReason | %{
    "  - {0}" -f $_.Name
    $_.Group | %{ "    - {0}" -f $_.FullName }
}

$urlBase = "https://docs.microsoft.com/en-us/dotnet/api/"
$view = "view=pscore-6.0.0"
$command = "Microsoft.PowerShell.Commands.DisablePSRemotingCommand"

$availableTypes = $tlist |Where-Object {$_.PSStandard5 -eq "True"}
$groupedTypes = $availableTypes | group { $fragments = $_.fullname.split("."); $fragments[0..($fragments.count - 2)] -join "." }

$typelistHeader = @'

## Available Types

The following table is a table of available types in PowerShell Standard by Namespace with links to online documentation.

'@

$ColumnCount = 2
$emptyCell = "<td>&nbsp;</td>"
$typelistHeader
"<table>"
$groupedTypes | %{
    $name = $_.name
    # Sigh - no way to span columns in markdown
    ""
    "<tr><th valign='bottom' height='50' align='left' colspan='${ColumnCount}'>${name}</th></tr>"
    $group = $_.group
    # $gTypes = @($_.group | %{$_.fullname.split(".")[-1] })
    for($i = 0; $i -lt $group.Count; $i += ${ColumnCount} ) {
        $t = $group[$i..($i+${columnCount}-1)] | %{ 
            $fullname = $_.fullname -replace "``","-" # "
            $name = $fullname.split(".")[-1]
            "<td><a href='${urlBase}${fullname}?${view}'>${name}</a></td>"
            }
        # pad the collection
        $addlCellCount = ${ColumnCount} - @($t).Count
        if ( $addlCellCount -gt 0 ) {
            $t += @($emptyCell) * $addlCellCount
            }
        "<tr>" + ($t -join "") + "</tr>"
    }
}
"</table>"
"" 
