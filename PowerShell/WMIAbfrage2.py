# Abfrage aller Systemdienste per WMI

import wmi
import json

wmi = wmi.WMI()

class Systemservice:

    def __init__(self, Name,Description,State,StartMode):
        self.Name = Name
        self.Description = Description
        self.Status = State
        self.StartMode = StartMode

services = []

# Auch wenn es nur einen Computer gibt, werden "alle" geholt
for service in wmi.Win32_Service():
    services.append(Systemservice(service.Name, service.Description, service.State, service.StartMode))

# Mach aus dem Objekt Json-Text
jsonText = "["
for service in services:
    jsonText += json.dumps(service.__dict__) + ","

# Das letzte Komma entfernen
jsonText = jsonText[:-1]
jsonText += "]"

# Die Rückgabe des Programms
print(jsonText)