# ALKIS-Processing

Automatisierte Extraktion von Eigentümerinformationen und Kartengenerierung aus ALKIS-Daten im NAS-Format; ein tidyverse / sf Ansatz

## Hintergrund

[Das Amtliche Liegenschaftskatasterinformationssystem (ALKIS)](https://de.wikipedia.org/wiki/Amtliches_Liegenschaftskatasterinformationssystem)

[Die Normbasierte Austauschschnittstelle (NAS)](https://de.wikipedia.org/wiki/Normbasierte_Austauschschnittstelle)

[Tidyverse](https://www.tidyverse.org)
**Tidyverse** ist eine Sammlung von R-Paketen für die Datenwissenschaft. Alle Pakete teilen eine grundlegende Designphilosophie, Grammatik und Datenstrukturen. 

[Simple Features *sf*](https://r-spatial.github.io/sf/articles/sf1.html)
*Simple features* bezieht sich auf eine formale Norm (ISO 19125-1:2004), die beschreibt, wie Objekte in der realen Welt in Computern dargestellt werden können, mit Schwerpunkt auf der Raumgeometrie dieser Objekte. Es wird auch beschrieben, wie solche Objekte in Datenbanken gespeichert und aus Datenbanken abgerufen werden können und welche geometrischen Operationen für sie definiert werden sollten.


## Testdaten der einzelnen Bundesländer

In der folgenden -- noch unvollständigen -- Tabelle sind die ALKIS-Testdaten der Bundesländer und die Links zu daraus gewonnenen Tabellen und Karten (Extrakte) aufgeführt.

| Bundesland       | Testdaten  | Größe    | Extrakte | Besonderheiten |
|:---------------- |:---------- | --------:|:-------- |:-------------- |
Baden-Württemberg  | [**6-0-1_Beispiel_gesamt_2370_20120704.xml**](https://www.lgl-bw.de/lgl-internet/opencms/de/05_Geoinformation/AAA/ALKIS/alkis-testdaten.html) | 167.5 MB | [**Link**](testExtracts/BW/ALKIS_processing.html) | separate Flurstück-Polygone (derzeit werden nur Flurstückzentren als Punkte dargestellt) |
Bayern             | [**testdaten_alkis_komplett_nas_25833.xml**](https://www.ldbv.bayern.de/service/testdaten.html) | 24.9 MB | [**Link**](testExtracts/BY/ALKIS_processing.html) | Flurstück-Eigentümer-Zuordnung als csv Tabelle in Testdaten |
Berlin | [**auftragsposition_2_NAS_AMGR000000023166_1.xml**](https://www.stadtentwicklung.berlin.de/geoinformation/liegenschaftskataster/download/nas_mit_anonymisierten_eigentuemern.zip) | 38.5 MB | [**Link**](testExtracts/BE/ALKIS_processing.html) |          |
Brandenburg	| [**ALKIS_NAS_Beispieldaten_Bestand_BB.xml**](https://www.geobasis-bb.de/geodaten/aaa-testdaten.html) | 434.7 MB | [**Link**](testExtracts/BB/ALKIS_processing.html) | sehr großer Datensatz |
Bremen | --- | --- | siehe NI | ALKIS-Daten offenbar von LGLN NI |
Hamburg	                HH      |        |          |
Hessen | [**GID6_BestandsdatenausgabeFlurstueck_Eigentum.xml**](https://www.gds.hessen.de/) | 4.3 MB | [**Link**](testExtracts/HE/ALKIS_processing.html) |
Mecklenburg-Vorpommern | [**BDA_testdaten_2017_05_16_anonymisiert.xml**](mailto://geodatenservice@laiv-mv.de) | 159.1 MB | *IN REVIEW* |
Niedersachsen | [**NAS-ohne-Eigentumsangaben-postnas.xml**](https://www.lgln.niedersachsen.de/download/126716/Amtliches_Liegenschaftskatasterinformationssystem_ALKIS_.zip) | 8.0 MB | Testdaten enthalten keine Eigentümer-Informationen! Damit nicht zu gebrauchen |
Nordrhein-Westfalen	| [**result_FeatureCollection_bda.xml**](https://www.bezreg-koeln.nrw.de/brk_internet/geobasis/liegenschaftskataster/bestandsdatenauszug/testdaten_bestandsdatenauszug_nas.zip) | 0.03 MB |  | Testdaten liegen für Eigentümerdaten und Flurstücksdaten in zwei verschiedenen xml Dateien vor.
Rheinland-Pfalz      | [**RP51_AX_Bestandsdatenauszug.xml**](https://lvermgeo.rlp.de/fileadmin/lvermgeo/testdaten/liegenschaftskataster/ALKIS_Bestandsdatenauszug_RP51_Testdaten.zip) | 1.1 MB | [**Link**](testExtracts/RP/ALKIS_processing.html) | Testdaten liegt Flurkarte (leider ohne Eigentümer-Info) bei.
Saarland                SL      |        |          |
Sachsen                 SN      |        |          |
Sachsen-Anhalt          ST      |        |          |
Schleswig-Holstein      SH      | [**Bestandsdatenauszug_NAS_ETRS89_UTM_0348.xml**](https://www.schleswig-holstein.de/DE/Landesregierung/LVERMGEOSH/Downloads/DownloadTestdaten/downloadsTestdatenAlkis.html) | 28.7 MB | [**Link**](testExtracts/SH/ALKIS_processing.html) |
Thüringen               TH      |        |          |    