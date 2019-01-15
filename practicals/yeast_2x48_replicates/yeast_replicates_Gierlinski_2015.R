## ----configuration-------------------------------------------------------

## Define the path to download the data (I will replace this by an URL on github)
dir.data <- "~/Documents/enseignement/AVIESAN_ecole_bioinformatique/2015-09_Ecole_Bioinfo_AVIESAN_n4/stats_avec_RStudio_EBA15/data/yeast_48_replicates/"

list.files(dir.data)

## ----data_loading_WT-----------------------------------------------------

## Read the counts per gene in for the WT and Snf2 mutant, respectively
counts.WT.raw <- read.table(file.path(dir.data, "WT_raw.tsv"), row.names = 1, sep="\t")
head(counts.WT.raw) ## Display the first rows of the WT count table
dim(counts.WT.raw) ## Check the size of the WT count table


## ----summary, eval=TRUE, echo=TRUE---------------------------------------

summary(counts.WT.raw)


## ----data_loading_Snf2, eval=FALSE, echo=TRUE----------------------------
## 
## ## Loading the Snf2 raw count table
## counts.Snf2.raw <- read.table(file.path(dir.data, "Snf2_raw.tsv"), row.names = 1)
## head(counts.WT.raw) ## Display the first rows of the Snf2 count table
## dim(counts.WT.raw) ## Check the size of the Snf2 count table
## 
## 
## ## Sample-wise statistics
## snf2.stats.per.sample <-  data.frame(
##   mean = apply(counts.Snf2.raw, 2, mean),
##   var = apply(counts.Snf2.raw, 2, var),
##   sd = apply(counts.Snf2.raw, 2, sd),
##   min = apply(counts.Snf2.raw, 2, min),
##   median = apply(counts.Snf2.raw, 2, median),
##   Q3 =  apply(counts.Snf2.raw, 2, quantile, 0.75),
##   max = apply(counts.Snf2.raw, 2, max)
##   )
## 
## 
## 
## ## Gene-wise statistics
## snf2.stats.per.gene <- data.frame(
##   mean = apply(counts.Snf2.raw, 1, mean),
##   var = apply(counts.Snf2.raw, 1, var),
##   sd = apply(counts.Snf2.raw, 1, sd),
##   min = apply(counts.Snf2.raw, 1, min),
##   median = apply(counts.Snf2.raw, 1, median),
##   Q3 =  apply(counts.Snf2.raw, 1, quantile, 0.75),
##   max = apply(counts.Snf2.raw, 1, max)
##   )
## 
## 

