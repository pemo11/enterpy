<#
 .Synopsis
 Aufruf des Nanolex-Cmdlets
#>

# Pfad der Dll-Datei kann auch relativ sein
$dllPfad = Join-Path -Path $PSScriptRoot -ChildPath "Nanolex.dll"
# import-module -Name .\Nanolex.dll
Import-Module -Name $dllPfad

Get-Module -Name Nanolex

Get-Nanolex