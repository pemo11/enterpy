# Abfrage aller Daten über den lokalen Computer

import wmi
import json

wmi = wmi.WMI()

class Computer:

    def __init__(self, System):
        self.Manufacturer = System.Manufacturer
        self.LogicalProcessor = System.NumberOfLogicalProcessors
        self.OwnerName =System.PrimaryOwnerName
        self.SystemName = System.SystemFamily
        self.Type = System.SystemType
        self.Memory = System.TotalPhysicalMemory
    

# Auch wenn es nur einen Computer gibt, werden "alle" geholt
for compi in wmi.Win32_ComputerSystem():
    PC1 = Computer(compi)

# Mach aus dem Objekt Json-Text
jsonText = json.dumps(PC1.__dict__)

# Die Rückgabe des Programms
print(jsonText)