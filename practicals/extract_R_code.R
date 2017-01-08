################################################################
## Extract the code of this markdown file
library(knitr)

dir.course <- "~/stats_avec_RStudio_EBA"
dir.practicals <- file.path(dir.course, "practicals")
Rmd.files <- list.files(path=dir.practicals, pattern="*.Rmd", recursive = TRUE)
setwd(dir.practicals)

for (md.file in Rmd.files) {
  R.file <- sub(pattern=".Rmd$", replacement = ".R", x = md.file)
  purl(md.file, output=R.file, quiet=TRUE)
  message("Extracted R code: ", R.file)
}

# this.folder <- "~/stats_avec_RStudio_EBA/practicals/02_peak-calling/"
# setwd(this.folder)
# md.file <- "peak-calling_stats_practical.Rmd"
# purl(md.file)

  
  
  