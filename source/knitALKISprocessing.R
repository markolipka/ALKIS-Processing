# knit document with input parameters:

options(shiny.maxRequestSize = 500 * 1024 * 1024) # max upload size in Bytes

switch(Sys.info()[['sysname']],
       Windows = {desktop.path <- "C:/User/MLI/Desktop/ALKISextracts/"},
       Linux   = {desktop.path <- "~/Desktop/ALKISextracts/"},
       Darwin  = {desktop.path <- "~/Desktop/ALKISextracts/"})

rmarkdown::render("source/ALKIS_processing.Rmd",
                  params = "ask",
                  output_dir = desktop.path)


### tests:

# SH: https://www.schleswig-holstein.de/DE/Landesregierung/LVERMGEOSH/Downloads/DownloadTestdaten/downloadsTestdatenAlkis.html
rmarkdown::render("source/ALKIS_processing.Rmd",
                  params = list(
                    alkisDataFile = "../testdaten/SH/Bestandsdatenauszug_NAS_ETRS89_UTM_0348.xml",
                    dynamic = TRUE),
                  output_dir = "testExtracts/SH/")

# BB: https://www.geobasis-bb.de/geodaten/aaa-testdaten.html
rmarkdown::render("source/ALKIS_processing.Rmd",
                  params = list(
                    alkisDataFile = "../testdaten/BB/ALKIS_NAS_Beispieldaten_Bestand_BB.xml",
                    dynamic = TRUE),
                  output_dir = "testExtracts/BB/")

# BW: https://www.lgl-bw.de/lgl-internet/opencms/de/05_Geoinformation/AAA/ALKIS/alkis-testdaten.html
rmarkdown::render("source/ALKIS_processing.Rmd",
                  params = list(
                    alkisDataFile = "../testdaten/BW/6-0-1_Beispiel_gesamt_2370_20120704.xml",
                    dynamic = TRUE),
                  output_dir = "testExtracts/BW/")
