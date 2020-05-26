# Das Ergebnis der Bundestagswahl als Balkendiagramm mit Matplotlib und Pandas
import matplotlib.pyplot as plt
# import pandas as pd
import sys

parteien = sys.argv[1].split(",")
anteile = sys.argv[2].split(",")

anteile = [float(z) for z in anteile]

# Wichtig: Wenn man eine Farbe falsch schreibt, resultiert gleich eine umfangreiche Fehlermeldung
farben = ['black', 'orangered', 'blue', 'yellow', 'red', 'green']

xbars = plt.bar(parteien, anteile, color=farben)
plt.title("Bundestagswahl 2017")
plt.show()