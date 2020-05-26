<#
 .Synopsis
 CSV-Daten einlesen und mit MatplotLib anzeigen
 .Notes
 Pfad von pythonw.exe wird aus Config-Datei gelesen, dadurch muss die Path-Variable nicht erweitert werden
#>

$CSVPfad = Join-Path -Path $PSScriptRoot -ChildPath "Bundestagswahl.csv"

# Da die PowerShell kein Slicing kennt und immer noch eine Extra runde Klammer erwartet,
# wird es leider unnötig kompliziert (ächz)
$Daten = Import-CSV $CSVPfad | Select-Object -Property @{n="Parteien";e={$_.PsObject.Properties.Name[1..(@($_.PsObject.Properties).Count-1)]}},
                                              @{n="Anteile";e={$obj=$_;$_.PsObject.Properties.Name[1..(@($_.PsObject.Properties).Count-1)].ForEach{$obj.PsObject.Properties[$_].Value}}}

# Jetzt wird das Python-Skript mit diesen Daten aufgerufen

$Psd1Pfad = Join-Path -Path $PSScriptRoot -ChildPath "PyConf.psd1"

$PyConf = Import-PowerShellDataFile -Path $Psd1Pfad
$PyPfad = $PyConf.pyexePfad
$ArgList = "MatplotlibBeispiel.py $($Daten.Parteien -join ",") $($Daten.Anteile -join ",")"
$PyErrorPfad = Join-Path -Path $PSScriptRoot -ChildPath PyErrors.txt
Start-Process -FilePath $PyPfad -ArgumentList $ArgList -WorkingDirectory $PSScriptRoot `
   -RedirectStandardError $PyErrorPfad -Wait

