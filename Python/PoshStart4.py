# PowerShell mit Base64-Command starten
# Vollständige Übersicht https://docs.python.org/3/library/codecs.html#standard-encodings
import base64
import os

# Ein PowerShell-Befehl als Beispiel
s = "Get-CimInstance -ClassName Win32_Process -Filter \"Name like 'Po%'\" | Select-Object ProcessId,Name,WorkingsetSize"

# Soetwas ginge auch;)
s1 ="記者 鄭啟源 羅智堅"

# "utf-8" ist default - soll Unicode sein

# Wichtig: Es funktioniert nur mit utf_16_le
bString = s.encode("utf_16_le")

b64 = base64.b64encode(bString)

s64 = b64.decode("utf-8")
print(s64)

# Jetzt PowerShell mit der Befehlsfolge ausführen
#poshArgs = "-noprofile -OutputFormat Xml -encodedCommand " + s64
poshArgs = "-noprofile -encodedCommand " + s64
print(poshArgs)
os.system("powershell " + poshArgs)
