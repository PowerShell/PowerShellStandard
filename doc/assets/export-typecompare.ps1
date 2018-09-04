class CommonType {
    [string]$Fullname
    [bool]$PowerShell51
    [bool]$PowerShell61
    [bool]$PSStandard5
    [string]$ExclusionReason
    CommonType([string]$n) {
        $this.Fullname = $n
    }
}

$PS51 = Get-Content PS51.txt
$PS61 = Get-Content PS6.txt
$PSSA = Get-Content PSS5.txt
$ALL = .{ $PS51; $PS61; $PSSA } |Sort-Object -Unique
$ALL | %{
    $ct = [CommonType]::new($_)
    $ct.PowerShell51 = $PS51 -contains $_
    $ct.PowerShell61 = $PS61 -contains $_
    $ct.PSStandard5  = $PSSA -contains $_
    $ct
} | export-csv TypeComparison.csv

