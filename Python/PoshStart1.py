# Beispiel 1: Powershell in einem Python-Programm starten
import subprocess
from os import path

poshArgs = "Get-Process"

# Die einfachste Form - dann shell=True erhält powershell.exe poshArgs über StdIn
# subprocess.call(["powershell.exe", poshArgs], shell=True)
# print("Fertig...")

# Optional, wenn nicht auf die Beendigung gewartet wird
# subprocess.check_call(["powershell.exe", poshArgs], shell=True)
# print("Fertig...")

#poshArgs = "Get-Process | Where-Object WS -gt 100MB"
#subprocess.call(["powershell.exe", poshArgs], shell=True)

jsonPfad = path.join(path.dirname(__file__), "Prozesse.json")
poshArgs = f"Get-Process | Where-Object WS -gt 100MB | Select-Object Name, Company, StartTime, WS | ConvertTo-Json | Out-File -FilePath {jsonPfad} -Encoding Utf8"
subprocess.call(["powershell.exe", poshArgs], shell=True)
print("Fertig...")

# Wenn die Befehlszeile zu umfangreich wird, dann Base64...