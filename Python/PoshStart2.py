# Beispiel 2: Powershell in einem Python-Programm starten
# PowerShell-Prozess mit Befehlszeile starten - Teil 2
import subprocess
from os import path

limitMb = 100
# -NoProfile wird als Befehl erkannt
# poshArgs = f" -NoProfile -C Get-Process | Where-Object WS -gt {limitMb}MB"
poshArgs = f"Get-Process | Where-Object WS -gt {limitMb}MB"

# Dieses Mal ohne shell=True
# subprocess.run(["powershell.exe", poshArgs])
# print("Fertig...")

# Bislang wurden alle Befehlszeilenargumente als Sequenz übergeben

# Wichtig: Wenn die Schalter ins Spiel kommen, muss alles ein String übergeben werden
# subprocess.call('powershell.exe  -Command Get-Process')
# https://stackoverflow.com/questions/15109665/subprocess-call-using-string-vs-using-list/15109975#15109975

poshArgs = f"powershell.exe -NoProfile -C Get-Process | Where-Object WS -gt {limitMb}MB"
subprocess.call(poshArgs)
print("Fertig...")
