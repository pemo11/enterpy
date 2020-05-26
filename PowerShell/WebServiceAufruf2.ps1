
<#
 .Synopsis
 Webservice abrufen - Teil 2
 .Description
 Jetzt mit Typisierung
 #>

 # Die Uri ist immer noch diesselbe
 $WebUri = "http://nanolex.azurewebsites.net/api/lexikon"

 # Schritt 1: Definition eines neuen Typs
 class LexEintrag
 {
     [Int]$LexId
     [String]$LexTopic
     [String]$LexTerm
     [String]$Definition

     LexEintrag([Int]$Id, [String]$Topic, [String]$Term, [String]$Definition)
     {
         $this.LexId = $Id
         $this.LexTopic = $Topic
         $this.LexTerm = $Term
         $this.Definition = $Definition
     }
 }

# Schritt 2: Rueckgabe von LexEintrag-Objekten
(Invoke-WebRequest -Uri $WebUri | Select-Object -ExpandProperty Content | ConvertFrom-Json).ForEach{
    [LexEintrag]::new($_.Id, $_.Topic, $_.Term, $_.Definition)
}

# Jetzt erhalten wir typisierte Objekte
# Schritt 3: Oder mit Zuweisung
$Eintraege = (Invoke-WebRequest -Uri $WebUri | Select-Object -ExpandProperty Content | ConvertFrom-Json).ForEach{
    [LexEintrag]::new($_.Id, $_.Topic, $_.Term, $_.Definition)
}

# Schritt 4: Der Typ kann um ein Member erweitert werden
 Update-TypeData -Typename LexEintrag -MemberType ScriptProperty `
 -MemberName AbgerufenAm -Value { Get-Date}

# Schritt 5: Jetzt wird eine weitere Eigenschaft angezeigt
# $Eintraege

# Schritt 6: Jetzt soll alles etwas schoener ausgegeben werden
# Es kommt eine Typformatdefinitionsdatei ins Spiel
$FormatDataMono = @'
<Configuration>
  <ViewDefinitions>
    <View>
      <Name>LexTableMono</Name>
      <ViewSelectedBy>
        <TypeName>LexEintrag</TypeName>
      </ViewSelectedBy>
      <TableControl>
        <TableHeaders>
          <TableColumnHeader>
            <Label>Stichwort</Label>
            <Width>36</Width>
          </TableColumnHeader>
          <TableColumnHeader>
            <Label>Kategorie</Label>
            <Width>24</Width>
          </TableColumnHeader>
          <TableColumnHeader>
            <Label>Definition</Label>
            <Width>80</Width>
          </TableColumnHeader>
        </TableHeaders>
        <TableRowEntries>
          <TableRowEntry>
            <TableColumnItems>
              <TableColumnItem>
                <PropertyName>LexTerm</PropertyName>
              </TableColumnItem>
              <TableColumnItem>
               <ScriptBlock>
               "$($_.LexTopic.Substring(0,1).ToUpper())$($_.LexTopic.Substring(1).ToLower().Replace(' ',''))"
              </ScriptBlock>
              </TableColumnItem>
              <TableColumnItem>
                <PropertyName>Definition</PropertyName>
              </TableColumnItem>
            </TableColumnItems>
          </TableRowEntry>
        </TableRowEntries>
      </TableControl>
    </View>
  </ViewDefinitions>
 </Configuration>
'@

# Die Typdefinitionsdatei wird dem Typenformatierer bekannt gemacht
$FormatPath = Join-Path -Path $PSScriptRoot -ChildPath LexEintrag.format.ps1xml
$FormatDataMono | Set-Content -Path $FormatPath
Update-FormatData -AppendPath $FormatPath -Verbose

# Jetzt sieht die Ausgabe auf einmal etwas anders aus
$Eintraege | Format-Table -View LexTableMono

# Auch farbige Ausgaben sind dank VT100-Unterstützung bei Windows 10 und
# Windows Server 2016 möglich
$FormatDataColor = @'
<Configuration>
  <ViewDefinitions>
    <View>
      <Name>LexTableColor</Name>
      <ViewSelectedBy>
        <TypeName>LexEintrag</TypeName>
      </ViewSelectedBy>
      <TableControl>
        <TableHeaders>
          <TableColumnHeader>
            <Label>Stichwort</Label>
            <Width>36</Width>
          </TableColumnHeader>
          <TableColumnHeader>
            <Label>Kategorie</Label>
            <Width>24</Width>
          </TableColumnHeader>
          <TableColumnHeader>
            <Label>Definition</Label>
            <Width>80</Width>
          </TableColumnHeader>
        </TableHeaders>
        <TableRowEntries>
          <TableRowEntry>
            <TableColumnItems>
              <TableColumnItem>
                <PropertyName>LexTerm</PropertyName>
              </TableColumnItem>
              <TableColumnItem>
               <ScriptBlock>
                $ColorTopicHash = @{PowerShell="93m";"Windows Server"="92m"}
                if ($ColorTopicHash.ContainsKey($_.LexTopic))
                { $EscColor = $ColorTopicHash[$_.LexTopic]} else { $EscColor = "97m"}
                $Esc = [Char]0x1b
                if ($Host.Name -ne "Windows PowerShell ISE Host")
                { "${Esc}[$EscColor$($_.LexTopic.Substring(0,1).ToUpper())$($_.LexTopic.Substring(1))${Esc}[0m"}
                else
                { "$($_.LexTopic.Substring(0,1).ToUpper())$($_.LexTopic.Substring(1))" }
              </ScriptBlock>
              </TableColumnItem>
              <TableColumnItem>
                <ScriptBlock>$_.Definition</ScriptBlock>
              </TableColumnItem>
            </TableColumnItems>
          </TableRowEntry>
        </TableRowEntries>
      </TableControl>
    </View>
  </ViewDefinitions>
 </Configuration>
'@

# Wieder das gleiche Prozedere
$FormatPath = Join-Path -Path $PSScriptRoot -ChildPath LexEintrag.format.ps1xml
$FormatDataColor | Set-Content -Path $FormatPath
Update-FormatData -AppendPath $FormatPath -Verbose

# Auf einmal ist bei der Ausgabe Farbe ins Spiel
# Aber nicht bei der PowerShell ISE!
$Eintraege  | Format-Table -View LexTableColor

# Welche Formatdefinitionen gibt es für einen Typen?
Get-FormatData -TypeName LexEintrag 