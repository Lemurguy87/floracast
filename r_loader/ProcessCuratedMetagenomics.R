# Version 1.0 2026-06
# Script to download datasets from curatedMetagenomicData library and process them before uploading to PostgresDB
# This script is strictly responsible for uploading raw data with minor processing and formatting. 
library(curatedMetagenomicData)


# Download each respective study from the curatedMetagenomic library. 
# From each study the relative abundance data set and the meta data is downloaded and uploaded. 
# Start with the relative abundance data for each study: 
wirbelJ_2018 <- curatedMetagenomicData("WirbelJ_2018.relative_abundance", dryrun = FALSE)
vogtmannE_2016 <- curatedMetagenomicData("VogtmannE_2016.relative_abundance", dryrun = FALSE)

wirbelJ_relab <- data.frame(assay(wirbelJ_2018[[1]]))
vogtmannE_relab <- data.frame(assay(vogtmannE_2016[[1]]))

wirbelJ_meta <- data.frame(colData(wirbelJ_2018[[1]]))
vogtmannE_meta <- data.frame(colData(vogtmannE_2016[[1]]))


# Clean up the relative abundance data. Keep the species name but remove the rest. 
rownames(wirbelJ_relab) <- gsub("k__.+s__", "", rownames(wirbelJ_relab))
rownames(vogtmannE_relab) <- gsub("k__.+s__", "", rownames(vogtmannE_relab))


# Transpose each data frame and modify sample names to be concordant with the meta data for each sample
wirbelJ_relab <- data.frame(t(wirbelJ_relab))
rownames(wirbelJ_relab) <- gsub("\\.", "-", rownames(wirbelJ_relab))

vogtmannE_relab <- data.frame(t(vogtmannE_relab))
rownames(vogtmannE_relab) <- gsub("\\.", "-", rownames(vogtmannE_relab))


# Format meta data such that same meta data is kept between studies.
wirbelJ_meta <- wirbelJ_meta[ ,colnames(wirbelJ_meta) %in% intersect(colnames(wirbelJ_meta),colnames(vogtmannE_meta))]
vogtmannE_meta <- vogtmannE_meta[ ,colnames(vogtmannE_meta) %in% intersect(colnames(wirbelJ_meta),colnames(vogtmannE_meta))]


# Append the different classes from the meta data to the abundance data 
wirbelJ_relab <- wirbelJ_relab[rownames(wirbelJ_meta),]
vogtmannE_relab <- vogtmannE_relab[rownames(vogtmannE_meta),]


# Retain taxa that are concordant between relative abundance data frames 
concordant_taxa <- intersect(colnames(wirbelJ_relab), colnames(vogtmannE_relab))
wirbelJ_relab <- wirbelJ_relab[,concordant_taxa]
vogtmannE_relab <- vogtmannE_relab[,concordant_taxa]

wirbelJ_relab$Sample_name <- rownames(wirbelJ_relab)
vogtmannE_relab$Sample_name <- rownames(vogtmannE_relab)

wirbelJ_relab$disease <- wirbelJ_meta$disease
vogtmannE_relab$disease <- vogtmannE_meta$disease


# Connect to DB container and upload each dataset

library("DBI")
library("RPostgres")


if (!exists("con") || !dbIsValid(con)) {
  con <- dbConnect(RPostgres::Postgres(),dbname = Sys.getenv("POSTGRES_DB"),
                  host = Sys.getenv("POSTGRES_HOST"), 
                  port = Sys.getenv("CONTAINER_PORT"),
                  user = Sys.getenv("POSTGRES_USER"),
                  password = Sys.getenv("POSTGRES_PASSWORD"))
}


if(!(dbExistsTable(con,"wirbelj_relab"))){
  print("Creating table 'wirbelj_relab'!")
  dbWriteTable(
    conn = con,
    name = "wirbelj_relab",
    value = wirbelJ_relab
  )
} else {
  print("'wirbelj_relab' already exists!")
}

if(!(dbExistsTable(con,"vogtmanne_relab"))){
  print("Creating table 'vogtmanne_relab'!")
  dbWriteTable(
    conn = con,
    name = "vogtmanne_relab",
    value = vogtmannE_relab
  )
} else {
  print("'vogtmanne_relab' already exists!")
}

on.exit(dbDisconnect(con))








