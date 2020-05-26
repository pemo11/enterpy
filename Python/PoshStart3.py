"""
Beispiel 3: Powershell in einem Python-Programm starten
Umleiten der Standardausgabe
"""
import subprocess
import sys
from os import path

# Verzeichnisse werden im Documents-Verzeichnis angelegt
poshArgs = "1..3 | ForEach-Object { $dirName='PyTest_{0:000}' -f $_;'Lege Verzeichnis ' + $dirName + ' an'; mkdir $dirName}"

dirPfad = path.join(path.dirname(__file__), "PyTest123")

# Löschen der Datei muss bestätigt werden
# poshArgs = f"mkdir {dirPfad};New-Item -ItemType File -Path {path.join(dirPfad, 'Ausgabe.txt')};del {dirPfad}"

# Löschen der Datei geht nicht, da sie auf ReadOnly gesetzt wurde
poshArgs = f"$datei='{path.join(dirPfad, 'Ausgabe.txt')}';(New-item -ItemType File -Path $datei -Force).Attributes='ReadOnly';del $datei"
print(poshArgs)
# poshArgs = "dir"

p = subprocess.Popen(["powershell", poshArgs], shell=True, stdout=subprocess.PIPE, stderr = subprocess.PIPE)
print(p.returncode)

stdout, stderr = p.communicate()
print(f"Output: {stdout}")
print(f"Error: {stderr}")

print("*** Auftrag ausgeführt ***")
