<#
 .Synopsis
 Objektausgaben als HTML-Report
#>

$dllPfad = Join-Path -Path $PSScriptRoot -ChildPath "Nanolex.dll"
Import-Module -Name $dllPfad

$HtmlCode = @()
Get-Nanolex | Group-Object -Property Topic | Sort-Object -Property Count -Descending | ForEach-Object {
    $HtmlCode += "<H3> Kategorie " + $_.Name + "</H3>"
    $HtmlCode += $_.Group | ConvertTo-Html -Fragment
}

$CssPfad = Join-Path -Path $PSScriptRoot -ChildPath "Standard.css"
ConvertTo-Html -Body $HtmlCode -Title "Nanolex-Report" -CssUri $CssPfad | Out-File -FilePath NanolexReport.html -Encoding default


.\NanolexReport.html
