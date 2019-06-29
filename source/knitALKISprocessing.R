# knit document with input parameters:

options(shiny.maxRequestSize = 500 * 1024 * 1024) # max upload size in Bytes

switch(Sys.info()[['sysname']],
       Windows = {desktop.path <- "C:/User/MLI/Desktop/ALKISextracts/"},
       Linux   = {desktop.path <- "~/Desktop/ALKISextracts/"},
       Darwin  = {desktop.path <- "~/Desktop/ALKISextracts/"})

# rmarkdown::render("source/ALKIS_processing.Rmd",
#                   params = "ask",
#                   output_dir = desktop.path)


### tests:

setwd("/Users/markolipka/Nextcloud/UKA/ALKIS_processing")
# SH: https://www.schleswig-holstein.de/DE/Landesregierung/LVERMGEOSH/Downloads/DownloadTestdaten/downloadsTestdatenAlkis.html
rmarkdown::render("source/ALKIS_processing.Rmd",
                  params = list(
                    alkisDataFile = "../testdaten/SH/Bestandsdatenauszug_NAS_ETRS89_UTM_0348.xml",
                    crs = 25832,
                    source = "https://www.schleswig-holstein.de/DE/Landesregierung/LVERMGEOSH/Downloads/DownloadTestdaten/downloadsTestdatenAlkis.html",
                    dynamic = TRUE),
                  output_dir = "testExtracts/SH/")

# BB: https://www.geobasis-bb.de/geodaten/aaa-testdaten.html
rmarkdown::render("source/ALKIS_processing.Rmd",
                  params = list(
                    alkisDataFile = "../testdaten/BB/ALKIS_NAS_Beispieldaten_Bestand_BB.xml",
                    crs = 25833,
                    source = "https://www.geobasis-bb.de/geodaten/aaa-testdaten.html",
                    dynamic = TRUE),
                  output_dir = "testExtracts/BB/")

# BW: https://www.lgl-bw.de/lgl-internet/opencms/de/05_Geoinformation/AAA/ALKIS/alkis-testdaten.html
rmarkdown::render("source/ALKIS_processing.Rmd",
                  params = list(
                    alkisDataFile = "../testdaten/BW/6-0-1_Beispiel_gesamt_2370_20120704.xml",
                    crs = 25832,
                    source = "https://www.lgl-bw.de/lgl-internet/opencms/de/05_Geoinformation/AAA/ALKIS/alkis-testdaten.html",
                    dynamic = TRUE),
                  output_dir = "testExtracts/BW/")

# Hessen: 
rmarkdown::render("source/ALKIS_processing.Rmd",
                  params = list(
                    alkisDataFile = "../testdaten/ALKIS-Testdaten_Hessen/GID6_BestandsdatenausgabeFlurstueck_Eigentum.xml",
                    crs = 25832,
                    source = "https://www.gds.hessen.de/",
                    dynamic = TRUE),
                  output_dir = "testExtracts/HE/")
### Vergleichsdaten im testdatensatz Hessen:
# he.vgl.shp <- read_sf("testdaten/ALKIS-Testdaten_Hessen/Daten_Shape/ax_11001_area.shp")
# plot(he.vgl.shp, max.plot = 1)

## BY: https://www.ldbv.bayern.de/service/testdaten.html
rmarkdown::render("source/ALKIS_processing.Rmd",
                  params = list(
                    alkisDataFile = "../testdaten/BY/testdaten_alkis_komplett_nas_25833.xml",
                    crs = 25833,
                    source = "https://www.ldbv.bayern.de/service/testdaten.html",
                    dynamic = TRUE),
                  output_dir = "testExtracts/BY/")

### BY Vergleichsdaten im Testdatensatz:
#by.vgl <- read.csv("testdaten/BY/Testdatei_Lurchingen.csv", sep = "#")
#by.vgl.shp <- read_sf("testdaten/BY/Flurstueck.shp")


# BE: https://www.stadtentwicklung.berlin.de/geoinformation/liegenschaftskataster/download/nas_mit_anonymisierten_eigentuemern.zip
rmarkdown::render("source/ALKIS_processing.Rmd",
                  params = list(
                    alkisDataFile = "../testdaten/BE/auftragsposition_2_NAS_AMGR000000023166_1.xml",
                    crs = 25833,
                    source = "https://www.stadtentwicklung.berlin.de/geoinformation/liegenschaftskataster/download/nas_mit_anonymisierten_eigentuemern.zip",
                    dynamic = TRUE),
                  output_dir = "testExtracts/BE/")

# RP
rmarkdown::render("source/ALKIS_processing.Rmd",
                  params = list(
                    alkisDataFile = "../testdaten/RP/RP51_AX_Bestandsdatenauszug.xml",
                    crs = 25832,
                    source = "https://lvermgeo.rlp.de/fileadmin/lvermgeo/testdaten/liegenschaftskataster/ALKIS_Bestandsdatenauszug_RP51_Testdaten.zip",
                    dynamic = TRUE),
                  output_dir = "testExtracts/RP/")
