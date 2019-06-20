# ALKISprocessing

Extraktion von Eigentümerinformationen und Karten aus ALKIS-Daten im NAS-Format; ein tidyverse / sf Ansatz

## Hintergrund

[Das Amtliche Liegenschaftskatasterinformationssystem (ALKIS)](https://de.wikipedia.org/wiki/Amtliches_Liegenschaftskatasterinformationssystem)

[Die Normbasierte Austauschschnittstelle (NAS)](https://de.wikipedia.org/wiki/Normbasierte_Austauschschnittstelle)

[Tidyverse](https://www.tidyverse.org)
**Tidyverse** ist eine Sammlung von R-Paketen für die Datenwissenschaft. Alle Pakete teilen eine grundlegende Designphilosophie, Grammatik und Datenstrukturen. 

[Simple Features *sf*](https://r-spatial.github.io/sf/articles/sf1.html)
*Simple features* bezieht sich auf eine formale Norm (ISO 19125-1:2004), die beschreibt, wie Objekte in der realen Welt in Computern dargestellt werden können, mit Schwerpunkt auf der Raumgeometrie dieser Objekte. Es wird auch beschrieben, wie solche Objekte in Datenbanken gespeichert und aus Datenbanken abgerufen werden können und welche geometrischen Operationen für sie definiert werden sollten.


## Testdaten

### Schleswig Holstein

[Testdaten aus SH](https://www.schleswig-holstein.de/DE/Landesregierung/LVERMGEOSH/Downloads/DownloadTestdaten/downloadsTestdatenAlkis.html)

Kleiner Datensatz: **Bestandsdatenauszug_NAS_ETRS89_UTM_0348.xml** (28.7 MB)

[Extrakte aus SH Testdaten](testExtracts/SH/ALKIS_processing.html)


### Baden-Württemberg

[Testdaten aus BW](https://www.lgl-bw.de/lgl-internet/opencms/de/05_Geoinformation/AAA/ALKIS/alkis-testdaten.html)

Größerer Datensatz mit separaten Flurstück-Polygonen (so dass derzeit nur Flurstückzentren als Punkte dargestellt werden): **6-0-1_Beispiel_gesamt_2370_20120704.xml** (167.5 MB)

[Extrakte aus BW Testdaten](testExtracts/BB/ALKIS_processing.html)



### Brandenburg

[Testdaten aus BB](https://www.geobasis-bb.de/geodaten/aaa-testdaten.html)

Sehr großer Datensatz: **ALKIS_NAS_Beispieldaten_Bestand_BB.xml** (434.7 MB)

[Extrakte aus BB Testdaten](testExtracts/BB/ALKIS_processing.html)