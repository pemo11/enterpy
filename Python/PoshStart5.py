# Beispiel 4: Powershell in einem Pythopn-Programm starten
# Pipeline-Verarbeitung mit Json-Text aus Python heraus
# Die Json-Daten stammen aus einem PowerShell-Befehl, der einen Webservice abgefragt
import os
import subprocess
import json
import pandas as pd
import matplotlib.pyplot as plt
from timeit import default_timer as timer

# Schritt 1: PowerShell-Cmdlet wird als Modul geladen und ausgeführt

dllPfad = os.path.join(os.path.dirname(__file__), "Nanolex.dll")
jsonPfad = os.path.join(os.path.dirname(__file__), "Nanolex.json")

# Genial, dass sich f und r so kombinieren lassen
# poshArgs = fr"powershell.exe -NoProfile -C Import-Module {dllPfad};Get-Nanolex"
start = timer()
# poshArgs = fr"powershell.exe -NoProfile -C 'Import-Module {dllPfad};Get-Nanolex | ConvertTo-Json | Out-File -FilePath {jsonPfad} -Encoding Utf8'"
# os.system(poshArgs)
poshArgs = f"powershell.exe -NoProfile -C Import-Module {dllPfad};Get-Nanolex | ConvertTo-Json | Out-File -FilePath {jsonPfad} -Encoding Utf8"
print(poshArgs)
subprocess.call(poshArgs)
dauer = timer() - start
print(f"*** {jsonPfad} wurde in {dauer:.2f}s erzeugt ***")

# Schritt 2: Laden der Json-Datei und Anzeige in Matplotlib

# ut8-sig statt utf-8 vermeidet einen UTF-8 BOM header error (darauf würde man ohne SO nie kommen;)
with open(jsonPfad, "r", encoding="utf-8-sig") as fh:
    jsonDaten = json.load(fh)

# Nicht so elegant - die Daten hatten wir auch schon vorher;)
# print(jsonDaten)

# Schritt 2A: Besser: Nimm doch Pandas (muss aber u.U erst per pip install pandas nachinstalliert werden)
df = pd.read_json(jsonPfad, encoding="utf-8-sig")

print(df)

# Schritt 2B: Gruppieren mit Pandas nach der Spalte Topic
kategorien = []
anzahl = []
print(df.groupby("Topic").groups)

for name, group in df.groupby("Topic"):
    kategorien.append(name)
    anzahl.append(len(group))

print(kategorien)
print(anzahl)

farben = ['green', 'orangered', 'blue', 'yellow', 'red', 'black']

# Schriott 3: Anzeige eines Balkendiagramms
xbars = plt.bar(kategorien, anzahl, color=farben)
plt.title("Lexikon-Kategorien")
plt.show()