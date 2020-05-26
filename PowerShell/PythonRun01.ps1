<#
 .Synopsis
 Ausführen eines Python-Programms, das Json-Daten erzeugt
  .Notes
 Pfad von pythonw.exe wird aus Config-Datei gelesen, dadurch muss die Path-Variable nicht erweitert werden
 Hat auf Anhieb funktioniert:) (ohne Fehler usw. - kaum zu glauben)
#>

$Psd1Pfad = Join-Path -Path $PSScriptRoot -ChildPath "PyConf.psd1"
$PyConf = Import-PowerShellDataFile -Path $Psd1Pfad

$PyPfad = $PyConf.pyexePfad

$ArgList = "WMIAbfrage1.py"
$PyResultPfad = Join-Path -Path $PSScriptRoot -ChildPath PyResult.json

Start-Process -FilePath $PyPfad -ArgumentList $ArgList -WorkingDirectory $PSScriptRoot -RedirectStandardOutput $PyResultPfad -Wait

Get-Content -path $PyResultPfad | ConvertFrom-Json