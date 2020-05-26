<#
 .Synopsis
 Ausführen eines Python-Programms im Rahmen eines WPF-Fensters mit Datenbindung
 .Notes
 Pfad von pythonw.exe wird aus Config-Datei gelesen, dadurch muss die Path-Variable nicht erweitert werden
#>

using namespace System.Windows
using namespace System.Windows.Markup

# Alle WPF-Assemblies laden
$Assemblies = "PresentationFramework","WindowsBase","PresentationCore"
$Assemblies.ForEach{Add-Type -Assembly $_}

$Psd1Pfad = Join-Path -Path $PSScriptRoot -ChildPath "PyConf.psd1"

$SBStart = {
    $PyConf = Import-PowerShellDataFile -Path $Psd1Pfad
    $PyPfad = $PyConf.pyexePfad
    $ArgList = "WMIAbfrage2.py"
    $PyResultPfad = Join-Path -Path $PSScriptRoot -ChildPath PyResult.json
    $PyErrorPfad = Join-Path -Path $PSScriptRoot -ChildPath PyErros.txt
    Start-Process -FilePath $PyPfad -ArgumentList $ArgList -WorkingDirectory $PSScriptRoot `
     -RedirectStandardOutput $PyResultPfad -RedirectStandardError $PyErrorPfad -Wait
    $tbJson.Text = Get-Content -Path $PyResultPfad
    $dgDaten.ItemsSource = $tbJson.Text | ConvertFrom-Json
}

$XAML = @'
<Window
  xmlns='http://schemas.microsoft.com/winfx/2006/xaml/presentation'
  xmlns:x='http://schemas.microsoft.com/winfx/2006/xaml'
  WindowStartupLocation='CenterScreen'
  Title='Python und PowerShell - Beispiel Nr. 4'
  Width='600'
  Height='600'
  FontFamily='Verdana'
  FontSize='16'
>
 <StackPanel>
    <Button
        x:Name='bnStart'
        Content='Start'
        Width='120'
        Height='32'
        Margin='10'
    />
    <TextBox
        x:Name='tbJson'
        Height='200'
        Width='400'
        VerticalScrollBarVisibility='Visible'
        TextWrapping='Wrap'
        IsReadOnly='True'
        />
    <DataGrid
        x:Name='grdDaten'
        Height='300'
        Width='600'
        Margin='10'
    />
 </StackPanel>
</Window>
'@

$MainWin = [XamlReader]::Parse($XAML)
$StartButton = $MainWin.FindName("bnStart")
$tbJson = $MainWin.FindName("tbJson")
$dgDaten = $MainWin.FindName("grdDaten")
$StartButton.add_Click($SBStart)
[void]$MainWin.ShowDialog()