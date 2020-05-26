<#
 .Synopsis
 Webservice abrufen - Teil 1
 #>

 $WebUri = "http://nanolex.azurewebsites.net/api/lexikon"

 # Schritt 1: Ein erster Aufruf
 Invoke-WebRequest -Uri $WebUri

 # Frage: Wie finde ich heraus, auf dem Typ das Rückgabeobjekt basiert?
 # Frage: Wie finde ich heraus, welche Members das Objekt besitzt?

 # Schritt 2: Auswahl der Content-Eigenschaft

Invoke-WebRequest -Uri $WebUri | Select-Object -ExpandProperty Content

# Schritt 3: Umwandeln in Objekte
Invoke-WebRequest -Uri $WebUri | Select-Object -ExpandProperty Content | ConvertFrom-Json

# Dieser Aufruf funktioniert nicht
Invoke-WebRequest -Uri $WebUri | Select-Object -ExpandProperty Content | `
 ConvertFrom-Json | Select-Object -First 3

# Der Grund: Durch die Konvertierung entsteht 1 Array-Objekt

# Eine Lösung erfordert etwas mehr Aufwand
(Invoke-WebRequest -Uri $WebUri | Select-Object -ExpandProperty Content | ConvertFrom-Json).ForEach{ $_}

# Jetzt sind es 47 Objekte

((Invoke-WebRequest -Uri $WebUri | Select-Object -ExpandProperty Content | ConvertFrom-Json).ForEach{ $_}).Count

# Jetzt geht auch dieser Befehl
(Invoke-WebRequest -Uri $WebUri | Select-Object -ExpandProperty Content | ConvertFrom-Json).ForEach{ $_} | `
Select-Object -First 3

# Nur bestimmte Einträge einer Kategorie
(Invoke-WebRequest -Uri $WebUri | Select-Object -ExpandProperty Content | ConvertFrom-Json).ForEach{ $_}  | Where-Object Topic -eq "Allgemein"


