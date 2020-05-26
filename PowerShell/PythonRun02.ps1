<#
 .Synopsis
 Ausführen eines Python-Programms im Rahmen eines WinForm-Fensters
 .Notes
 Pfad von pythonw.exe wird aus Config-Datei gelesen, dadurch muss die Path-Variable nicht erweitert werden
#>

using namespace System.Windows.Forms
using namespace System.Drawing

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$Psd1Pfad = Join-Path -Path $PSScriptRoot -ChildPath "PyConf.psd1"

$SBStart = {
    $PyConf = Import-PowerShellDataFile -Path $Psd1Pfad
    $PyPfad = $PyConf.pyexePfad
    $ArgList = "WMIAbfrage2.py"
    $PyResultPfad = Join-Path -Path $PSScriptRoot -ChildPath PyResult.json
    $PyErrorPfad = Join-Path -Path $PSScriptRoot -ChildPath PyErros.txt
    Start-Process -FilePath $PyPfad -ArgumentList $ArgList -WorkingDirectory $PSScriptRoot `
     -RedirectStandardOutput $PyResultPfad -RedirectStandardError $PyErrorPfad -Wait
    $tbOutput.Text = Get-Content -Path $PyResultPfad
}

$form = [Form]::new()
$form.Size = [Size]::new(600,400)
$form.Text = "Python und PowerShell - Beispiel Nr. 2"
$bnStart = [Button]::new()
$bnStart.Text = "&Start"
$bnStart.Size = [Size]::new(120,32)
$bnStart.Location = [Point]::new(10,240)
$bnStart.add_Click($SBStart)
$tbOutput = [Textbox]::new()
$tbOutput.Multiline = $true
$tbOutput.Location = [Point]::new(10,10)
$tbOutput.Scrollbars = "Vertical"
$tbOutput.Size = [Size]::new(400,200)
$form.Controls.Add($bnStart)
$form.Controls.Add($tbOutput)

[Application]::Run($form)

