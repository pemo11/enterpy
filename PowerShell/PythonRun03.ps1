<#
 .Synopsis
 Ausführen eines Python-Programms im Rahmen eines WinForm-Fensters mit Datenbindung
 .Notes
 Pfad von pythonw.exe wird aus Config-Datei gelesen, dadurch muss die Path-Variable nicht erweitert werden
#>

using namespace System.Data
using namespace System.Windows.Forms
using namespace System.Drawing

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
    $ta = [DataTable]::new()
    $ta.Columns.Add("Name",[String])
    $ta.Columns.Add("Status",[String])
    $ta.Columns.Add("Description",[String])
    # $dgDaten.DataSource = $tbOutput.Text | ConvertFrom-Json 
    $Daten = $tbOutput.Text | ConvertFrom-Json 
    [Messagebox]::Show("$($Daten.Count) Datensätze erhalten")
    # Direkte Datenbindung geht bei WinForms nicht, daher Umweg über eine DataTable
    foreach($Service in $Daten)
    {
      $row = $ta.NewRow()
      $row["Name"] = $Service.Name
      $row["Status"] = $Service.Status
      $row["Description"] = $Service.Description
      $ta.Rows.Add($row)
    }
    $dgDaten.DataSource = $ta
    [Application]::DoEvents()
}

$form = [Form]::new()
$form.Size = [Size]::new(600,600)
$form.Text = "Python und PowerShell - Beispiel Nr. 3"
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
$dgDaten = [DataGridView]::new()
$dgDaten.Size = [Size]::new(400,200)
$dgDaten.Location = [Point]::new(10,280)
$dgDaten.ReadOnly = $true

$form.Controls.Add($bnStart)
$form.Controls.Add($tbOutput)
$form.Controls.Add($dgDaten)

[Application]::Run($form)

