# TODO:
# - Eigentümer-Gemeinschaften könnten nach "Wichtigkeit" der ET sortiert dargestellt werden. 
# - 


# Loading additional libraries:

library(tidyverse) # 'tidy data' tools
library(sf) # 'simple feature' handling for geodata processing
library(lwgeom) # handling of invalid geometries
library(openxlsx) # write excel files

switch(Sys.info()[['sysname']],
       Windows = {desktop.path <- "C:/User/MLI/Desktop/ALKISextracts/"},
       Linux   = {desktop.path <- "~/Desktop/ALKISextracts/"},
       Darwin  = {desktop.path <- "~/Desktop/ALKISextracts/"})

#path2NASfile <- "../testdaten/SH/Bestandsdatenauszug_NAS_ETRS89_UTM_0348.xml" # SH
#path2NASfile <- "../testdaten/BW/6-0-1_Beispiel_gesamt_2370_20120704.xml" # BW
#path2NASfile <- "../testdaten/BB/ALKIS_NAS_Beispieldaten_Bestand_BB.xml" # BB
#path2NASfile <- "../testdaten/BY/testdaten_alkis_komplett_nas_25833.xml" # BY
#path2NASfile <- "../testdaten/BE/auftragsposition_2_NAS_AMGR000000023166_1.xml" # BE
#path2NASfile <- "../testdaten/RP/RP51_AX_Bestandsdatenauszug.xml" # RP

processALKIS <- function(path2NASfile,
                         crs = 25833,
                         shp.overwrite = TRUE
) {
  
  #st_layers(path2NASfile)
  
  troubling_cols <- c("identifier", "beginnt", "advStandardModell", "anlass")
  
  Flurstueck <- read_sf(path2NASfile, "AX_Flurstueck", crs = crs) %>%
    rename(FSgmlid = gml_id) %>%
    select(-one_of(troubling_cols))
  
  Buchungsstelle <- read_sf(path2NASfile, "AX_Buchungsstelle") %>%
    rename(BSgmlid = gml_id) %>%
    select(-one_of(troubling_cols))
  
  # Gemarkung <- read_sf(path2NASfile, "ax_gemarkung") %>%
  #   rename(Ggmlid = gml_id) %>%
  #   select(-one_of(troubling_cols))
  # 
  #Buchungsart <- st_read(path2NASfile, "v_bs_buchungsart") # TODO: unklar, woher nehmen und ob wichtig...
  
  Buchungsblatt <- read_sf(path2NASfile, "AX_Buchungsblatt") %>%
    rename(BBgmlid = gml_id, GBland = land) %>%
    select(-one_of(troubling_cols))
  
  # Buchungsblattbezirk <- read_sf(path2NASfile, "AX_Buchungsblattbezirk") %>%
  #   rename(BBBgmlid = gml_id, GBland = land) %>%
  #   select(-one_of(troubling_cols))
  
  Namensnummer <- read_sf(path2NASfile, "AX_Namensnummer") %>%
    rename(NNgmlid = gml_id) %>%
    select(-one_of(troubling_cols))
  
  Person <- read_sf(path2NASfile, "AX_Person") %>%
    rename(Pgmlid = gml_id) %>%
    select(-one_of(troubling_cols)) %>%
    # Erstelle Spalte Vorname, falls es keine gibt (wie z.B. in Rheinland-Pfalz)
    mutate(vorname = ifelse("vorname" %in% names(.),
                            vorname,
                            NA_character_))
  
  Anschrift <- read_sf(path2NASfile, "AX_Anschrift") %>%
    rename(Agmlid = gml_id) %>%
    select(-one_of(troubling_cols))
  
  # Flurstück-Eigentümer-Zuordnung, Konstruiert aus http://trac.wheregroup.com/PostNAS/browser/trunk/import/sichten.sql
  
  # Hilfstabelle "doppelverbindung" für "hat Recht an" Beziehungen (?)
  
  doppelverbindung <- merge(st_drop_geometry(Flurstueck),
                            Buchungsstelle,
                            by.x = "istGebucht",
                            by.y = "BSgmlid", all.x = TRUE) %>%
    select("FSgmlid", "BSgmlid" = istGebucht) %>%
    mutate("BA_dien" = 0)
  
  try({doppelverbindung2 <- merge(doppelverbindung, Buchungsstelle,
                                  by.x = "BSgmlid", by.y = "an",
                                  all.x = TRUE) %>% # TODO: Achtung! das SQL Skript sieht hier eine ANY()-beziehung vor. Unklar, ob merge(all = FALSE) dasselbe tut!! "an" scheint Listen von Werten enthalten zu können und ANY prüft elementweise... Im SH-Test-Datensatz ist "an" aber ein einfacher Vektor.
    select(FSgmlid, "BSgmlid" = BSgmlid.y, "BA_dien" = buchungsart)
  
  doppelverbindung <- bind_rows(doppelverbindung, doppelverbindung2) %>%
    unique() # unklar, ob unique() nötig ist, aber das macht auch UNION aus der SQL-Vorlage
  }, silent = TRUE)
  
  ## Attribute-JOIN, um Flurstück und Eigentümerinfo zu verbinden:
  FSETjoin <- 
    Flurstueck %>%
    st_drop_geometry() %>%
    merge(doppelverbindung,
          by = "FSgmlid", all.x = TRUE) %>%
    # Entschlüsseln der Gemarkung:
    #merge(Gemarkung, by = c("land", "gemarkungsnummer"), all.x = TRUE) %>%
    # Flurstück *istGebucht* auf BuchungsStelle via *BSgmlid*
    merge(Buchungsstelle %>%
            select(-starts_with("zaehler"), -starts_with("nenner")), # unklar, warum diese hier manchmal erneut auftauchen!!
          by = "BSgmlid", all.x = TRUE) %>% 
    # Entschlüsselung der Buchungsart
    #merge(Buchungsart, ...) # TODO: falls wichtig
    #  merge(Buchungsblatt,
    #        by.x = "istBestandteilVon",
    #        by.y = "BBgmlid", all.x = TRUE) %>%
    #  rename("BBgmlid" = istBestandteilVon) %>%
    #  merge(select(Buchungsblattbezirk,
    #               -schluesselGesamt, -stelle, -bezeichnung), #unklar, wozu diese hier noch einmal aufgeführt sind...
    #        by = c("GBland", "bezirk"), all.x = TRUE) %>%
    # Buchungsstelle hängt zusammen mit Namensnummer via *istBestandteilVon*
    merge(Namensnummer %>%
            select(-one_of("zaehler", "nenner", "name", "art")), #unklar, wozu diese hier manchmal noch einmal aufgeführt sind...
          by = "istBestandteilVon", all.x = TRUE) %>% #names()
    # Namensnummer *benennt* Person via Pgmlid
    merge(Person %>%
            select(-one_of("zaehler", "nenner", "name", "art")), #unklar, wozu diese hier manchmal noch einmal aufgeführt sind...
          by.x = "benennt", by.y = "Pgmlid", all.x = TRUE) %>% #names()
    # Person *hat* Anschrift via *Agmlid*
    unnest(hat) %>% #names() # äquivalent zu ANY-Join, so dass auch mehrere links in "hat" ausgewertet werden. "Person" wird um Zeilen erweitert, wo "hat" mehrere Einträge hat.
    merge(Anschrift %>%
            select(-one_of("zaehler", "nenner", "name", "art", "CharacterString", "CI_RoleCode", "DateTime", "qualitaetsangaben|AX_DQOhneDatenerhebung|herkunft|LI_Lineage|processStep|LI_ProcessStep|processor|CI_ResponsibleParty|organisationName|CharacterString")), #unklar, wozu diese hier manchmal noch einmal aufgeführt sind...
          by.x = "hat", by.y = "Agmlid", all.x = TRUE) %>% #names() 
    #unique() %>% 
    mutate(Eigentuemer = if_else(is.na(vorname),
                                 nachnameOderFirma,
                                 paste(nachnameOderFirma, vorname,
                                       sep = ", "))) %>%
    filter(!is.na(Eigentuemer)) # FIXME: warum? hat was mit den doppelverbindungen zu tun
  
  
  
  
  ## alle Flurstücke mit aggregierten Attribut- und Geodaten
  Flurstueck_ET <- FSETjoin %>%
    mutate(FS = ifelse(is.na(nenner),
                       as.character(zaehler),
                       paste(zaehler, nenner, sep = "/"))) %>%
    group_by(flurstueckskennzeichen, FS) %>%
    summarise(ET = paste(unique(Eigentuemer), collapse = "; ")) %>%#,
              #nET = count ET) %>%
    merge(Flurstueck, ., by = "flurstueckskennzeichen")
  
  ## SHP-Dateien schreiben:
  try(st_write(Flurstueck_ET, paste(desktop.path,
                                    "AX_Flurstueck_ET.shp", sep = "/"),
               delete_dsn = shp.overwrite, quiet = TRUE))
  
  
  
  
  ## check auf invalide Geometrie (z.B. nicht unterstützte 'WKB types' wie "CURVEPOLYGON"):
  needs.repair <- st_is_valid(Flurstueck) %>% is.na() %>% sum() > 0
  if (needs.repair) {
    Flurstueck_ET <- st_make_valid(Flurstueck_ET)
  }
  
  ## alle Eigentümer(gemeinschaften) mit aggregierten Info zu Fläche, Zahl:
  FSstats <- Flurstueck_ET %>%
    mutate(ha = as.numeric(st_area(.)) / 10000) %>%
    group_by(ET) %>%
    summarise(ha = sum(ha) %>% signif(2),
              amtFl = sum(amtlicheFlaeche),
              n = n()) %>%
    arrange(desc(ha)) %>%
    mutate(ETtrunc = str_trunc(ET, 15),
           label = paste0(ha, " ha \t", ETtrunc))
  
  ## check for column "telefon" and create it if not exists:
  if (!"telefon" %in% names(FSETjoin)) {
    FSETjoin$telefon <- NA
  }
  
  ETstats <- FSETjoin %>%
    merge(Flurstueck %>% 
            st_make_valid() %>%
            select(flurstueckskennzeichen), .,
          by = "flurstueckskennzeichen") %>%
    mutate(ha = st_area(.) %>% as.numeric() / 10000) %>%
    group_by(Eigentuemer, #amtlicheFlaeche,
             postleitzahlPostzustellung, ort_Post,
             strasse, hausnummer, telefon) %>%
    summarise(ha = sum(ha) %>% round(2),
              amtlFl = sum(amtlicheFlaeche),
              n = n())
  
  return(list(crs.used = crs,
              ETtab = Flurstueck_ET,
              FStats = FSstats,
              EStats = ETstats))
}


mapOV <- function(alkisExtract,
                  dynamic = FALSE,
                  param = "ET") {
  if (dynamic) {
    # dynamische Karte:
    mapview(alkis$ETtab, zcol = "ET", legend = FALSE) # könnte lange dauern
  }else plot(alkis$ETtab["ET"]) # statische Karte
}

mapFlur <- function(alkisExtract, export.pdf = TRUE) {
  p <- alkisExtract$FStats %>%
    slice(1:12) %>%
    ggplot() +
    geom_sf(aes(fill = label), color = "black") +
    geom_sf(data = alkis$ETtab, fill = NA, color = "darkgrey") +
    geom_sf_text(data = alkis$ETtab, aes(label = FS),
                 check_overlap = TRUE) + # kleinere Flurstücke werden bei Überlappung nicht gelabelt, da FSstats nach FS-Größe sortiert ist (?)
    scale_fill_brewer(palette = "Paired") +
    guides(fill = guide_legend(reverse = TRUE))
  
  if (export.pdf) {ggsave(p, filename = "Flurkarte.pdf",
                          path = desktop.path)}
  p
}

tabFS <- function(alkisExtract) {
  tab <- alkis$ETtab %>%
    st_drop_geometry() %>%
    arrange(flurstueckskennzeichen) %>%
    select(flurstueckskennzeichen, FS, gemarkungsnummer, 
           #flurnummer, # keine Flurnummer in BY Daten vorhanden?!
           amtlicheFlaeche, ET,
           everything())
  
  write.xlsx(tab, paste(desktop.path, "FS-Liste.xlsx", sep = "/"))
  DT::datatable(tab)
}

tabEG <- function(alkisExtract) {
  tab <- alkisExtract$FStats %>%
    st_drop_geometry() %>%
    select("Eigentümer(gemeinschaft)" = ET,
           "Ges. Fläche" = ha,
           amtFl,
           "Anzahl FS" = n)
  
  write.xlsx(tab, paste(desktop.path, "FS-Stats.xlsx", sep = "/"))
  DT::datatable(tab)
}

tabET <- function(alkisExtract) {
  tab <- alkisExtract$EStats %>%
    st_drop_geometry() %>%
    arrange(desc(ha))
  
  write.xlsx(tab, paste(desktop.path, "ET-Stats.xlsx", sep = "/"))
  DT::datatable(tab)
}
