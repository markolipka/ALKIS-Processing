# function to knit report with input parameters:

knitALKISreport <- function(ask = FALSE,
                            alkisDataFile, crs.epsg, quelle,
                            output_dir, dynamic = TRUE,
                            max.size.MB = 500) {
  options(shiny.maxRequestSize = max.size.MB * 1024 * 1024) # max upload size in Bytes
  if (ask) {
    switch(Sys.info()[['sysname']],
           Windows = {desktop.path <- "C:/User/MLI/Desktop/ALKISextracts/"},
           Linux   = {desktop.path <- "~/Desktop/ALKISextracts/"},
           Darwin  = {desktop.path <- "~/Desktop/ALKISextracts/"})
    
    rmarkdown::render("source/ALKIS_processing.Rmd",
                      params = "ask",
                      output_dir = desktop.path)
  }else{
    norm.file <- normalizePath(alkisDataFile)
    print(norm.file)
    rmarkdown::render("source/ALKIS_processing.Rmd",
                      params = list(
                        alkisDataFile = norm.file,
                        crs = crs.epsg,
                        source = quelle,
                        dynamic = dynamic),
                      output_dir = normalizePath(paste0("testExtracts/", output_dir, "/")))
  }
}

# GUI für Report-Erstellung
# knitALKISreport(ask = TRUE)


# Tests mit Testdaten der einzelnen Bundesländer:

## SH: 
knitALKISreport(
  alkisDataFile = "testdaten/SH/Bestandsdatenauszug_NAS_ETRS89_UTM_0348.xml",
  crs.epsg = 25832,
  quelle = "https://www.schleswig-holstein.de/DE/Landesregierung/LVERMGEOSH/Downloads/DownloadTestdaten/downloadsTestdatenAlkis.html",
  dynamic = TRUE,
  output_dir = "SH")

## BB: 
knitALKISreport(
  alkisDataFile = "testdaten/BB/ALKIS_NAS_Beispieldaten_Bestand_BB.xml",
  crs.epsg = 25833,
  quelle = "https://www.geobasis-bb.de/geodaten/aaa-testdaten.html",
  dynamic = FALSE,
  output_dir = "BB")

## BW: 
knitALKISreport(
  alkisDataFile = "testdaten/BW/6-0-1_Beispiel_gesamt_2370_20120704.xml",
  crs.epsg = 25832,
  quelle = "https://www.lgl-bw.de/lgl-internet/opencms/de/05_Geoinformation/AAA/ALKIS/alkis-testdaten.html",
  dynamic = TRUE,
  output_dir = "BW")

## HE:
knitALKISreport(
  alkisDataFile = "testdaten/HE/GID6_BestandsdatenausgabeFlurstueck_Eigentum.xml",
  crs.epsg = 25832,
  quelle = "https://www.gds.hessen.de/",
  dynamic = TRUE,
  output_dir = "HE")
### Vergleichsdaten im testdatensatz Hessen:
# he.vgl.shp <- read_sf("testdaten/HE/Daten_Shape/ax_11001_area.shp")
# plot(he.vgl.shp, max.plot = 1)

## BY: 
knitALKISreport(
  alkisDataFile = "testdaten/BY/testdaten_alkis_komplett_nas_25833.xml",
  crs.epsg = 25833,
  quelle = "https://www.ldbv.bayern.de/service/testdaten.html",
  dynamic = TRUE,
  output_dir = "BY")

### BY Vergleichsdaten im Testdatensatz:
#by.vgl <- read.csv("testdaten/BY/Testdatei_Lurchingen.csv", sep = "#")
#by.vgl.shp <- read_sf("testdaten/BY/Flurstueck.shp")


# BE:
knitALKISreport(
  alkisDataFile = "testdaten/BE/auftragsposition_2_NAS_AMGR000000023166_1.xml",
  crs.epsg = 25833,
  quelle = "https://www.stadtentwicklung.berlin.de/geoinformation/liegenschaftskataster/download/nas_mit_anonymisierten_eigentuemern.zip",
  dynamic = TRUE,
  output_dir = "BE")

# RP
knitALKISreport(
  alkisDataFile = "testdaten/RP/RP51_AX_Bestandsdatenauszug.xml",
  crs.epsg = 25832,
  quelle = "https://lvermgeo.rlp.de/fileadmin/lvermgeo/testdaten/liegenschaftskataster/ALKIS_Bestandsdatenauszug_RP51_Testdaten.zip",
  dynamic = TRUE,
  output_dir = "RP")

#MV:
knitALKISreport(
  alkisDataFile = "testdaten/MV/BDA_testdaten_2017_05_16_anonymisiert.xml",
  crs.epsg = 25833,
  quelle = "per Mail angefragt beim Fachbereich Geodatenbereitstellung
Landesamt für innere Verwaltung Mecklenburg-Vorpommern (geodatenservice@laiv-mv.de)",
  dynamic = TRUE,
  output_dir = "MV")

#Saarland (SL):
knitALKISreport(
  alkisDataFile = "testdaten/SL/AMGR000000380950.xml",
  crs.epsg = 25832,
  quelle = "https://www.saarland.de/100407.htm",
  dynamic = TRUE,
  output_dir = "SL")

#Sachsen (SN):
knitALKISreport(
  alkisDataFile = "testdaten/SN/Bestandsdaten_Ostritz_mEToBsmPkt.xml",
  crs.epsg = 25833,
  quelle = "https://www.landesvermessung.sachsen.de/inhalt/produkte/lika/download/download.html",
  dynamic = TRUE,
  output_dir = "SN")

#Sachsen-Anhalt (ST):
knitALKISreport(
  alkisDataFile = "testdaten/ST/auftragsposition_1_AMGR000000283627.xml",
  crs.epsg = 25832,
  quelle = "https://www.lvermgeo.sachsen-anhalt.de/de/leistungen-testdaten-der-geobasisdaten/leistungen-testdaten-der-geobasisdaten.html",
  dynamic = TRUE,
  output_dir = "ST")

#Thüringen (TH1):
knitALKISreport(
  alkisDataFile = "testdaten/TH/Test_ALKIS-NAS_2107007.xml",
  crs.epsg = 25832,
  quelle = "https://www.thueringen.de/th9/tlbg/onlineshop-vertrieb/testdaten/",
  dynamic = TRUE,
  output_dir = "TH1")

#Thüringen (TH2):
knitALKISreport(
  alkisDataFile = "testdaten/TH/Test_ALKIS-NAS_2107008.xml",
  crs.epsg = 25832,
  quelle = "https://www.thueringen.de/th9/tlbg/onlineshop-vertrieb/testdaten/",
  dynamic = TRUE,
  output_dir = "TH2")

#Niedersachsen (NI):
knitALKISreport(
  alkisDataFile = "testdaten/NI/NAS-ohne-Eigentumsangaben-postnas.xml",
  crs.epsg = 25832,
  quelle = "https://www.lgln.niedersachsen.de/startseite/online_angebote_amp_services/service/testdaten/testdaten-51644.html",
  dynamic = TRUE,
  output_dir = "NI")
