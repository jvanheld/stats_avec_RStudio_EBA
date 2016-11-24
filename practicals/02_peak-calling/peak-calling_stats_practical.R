## ----setup, include=FALSE, size="huge"-----------------------------------
library(knitr)
## Default parameters for displaying the slides
knitr::opts_chunk$set(echo = TRUE, eval=TRUE, fig.width = 7, fig.height = 5, fig.align = "center", size = "tiny")

## ----out.width = "100%", echo=FALSE, fig.cap="**The peak calling question**. Slide from Carl Herrmann. "----
knitr::include_graphics("images/peak-calling_the_question.png")

## ------------------------------------------------------------------------
url.course <- "http://jvanheld.github.io/stats_avec_RStudio_EBA/"
url.data <- file.path(url.course, "practicals", "02_peak-calling", "data")

## ------------------------------------------------------------------------
## Define URL of the ChIP file
chip.bedg.file <- file.path(url.data, "FNR_200bp.bedg")

## Load the file content in an R data.frame
chip.bedg <- read.table(chip.bedg.file)

## Set column names
names(chip.bedg) <- c("chrom", "start", "end","counts")

## ------------------------------------------------------------------------
dim(chip.bedg)

## ------------------------------------------------------------------------
head(chip.bedg, n = 5)

## ------------------------------------------------------------------------
tail(chip.bedg, n = 5)

## ----eval=FALSE----------------------------------------------------------
## View(chip.bedg)

## ------------------------------------------------------------------------
chip.bedg[100:105,] 

## ------------------------------------------------------------------------
chip.bedg[100:105, 2] 
chip.bedg[100:105, "start"] 
chip.bedg[100:105, c("start", "counts")] 

## ------------------------------------------------------------------------
chip.bedg$midpos <- (chip.bedg$start + chip.bedg$end)/2
head(chip.bedg)

## ----fig.width=7, fig.height=4, fig.align="center"-----------------------
plot(chip.bedg[, c("midpos", "counts")], type="h")

## ----fig.width=7, fig.height=4, fig.align="center"-----------------------
plot(chip.bedg[, c("midpos", "counts")], type="h", 
     col="darkgreen", xlab="Genomic position (200bp bins)", 
     ylab= "Reads per bin",
     main="FNR ChIP-seq")

## ------------------------------------------------------------------------
## Define URL of the input file
input.bedg.file <- file.path(url.data, "input_200bp.bedg")

## Load the file content in an R data.frame
input.bedg <- read.table(input.bedg.file)

## Set column names
names(input.bedg) <- c("chrom", "start", "end","counts")


## ----fig.width=7, fig.height=4-------------------------------------------
## Compute middle positions per bin
input.bedg$midpos <- (input.bedg$start + input.bedg$end)/2

plot(input.bedg[, c("midpos", "counts")], type="h", 
     col="red", xlab="Genomic position (200bp bins)", 
     ylab= "Read counts",
     main="Background (genomic input)")

## ----fig.width=8, fig.height=4-------------------------------------------
par(mfrow=c(1,2)) ## Draw two panels besides each other
plot(chip.bedg[, c("midpos", "counts")], type="h", 
     col="darkgreen", xlab="Genomic position (200bp bins)", 
     ylab= "Reads per bin",
     main="FNR ChIP-seq")
plot(input.bedg[, c("midpos", "counts")], type="h", 
     col="red", xlab="Genomic position (200bp bins)", 
     ylab= "Reads per bin",
     main="Background (genomic input)")
par(mfrow=c(1,1)) ## Reset default mode

## ----fig.width=7, fig.height=7, fig.align="center"-----------------------
plot(input.bedg$counts, chip.bedg$counts, col="darkviolet",
     xlab="Genomic input", ylab="FNR ChIP-seq",
     main="Reads per 200bp bin")

## ----fig.width=7, fig.height=7, fig.align="center"-----------------------
plot(input.bedg$counts, chip.bedg$counts, col="darkviolet",
     xlab="Genomic input", ylab="FNR ChIP-seq",
     main="Reads per 200bp bin",
     log="xy")
grid() ## add a grid

## ------------------------------------------------------------------------
names(input.bedg)

## Merge two tables by identical values for multiple columns
count.table <- merge(chip.bedg, input.bedg, by=c("chrom", "start", "end", "midpos"), suffixes=c(".chip", ".input"))

## Check the result size
names(count.table)

## ------------------------------------------------------------------------
## Simplify the chromosome name
head(count.table$chrom)
count.table$chrom <- "NC_000913.2"
kable(head(count.table)) ## Display the head of the table in a 

## ----fig.width=7, fig.height=7-------------------------------------------
max.counts <- max(count.table[, c("counts.input", "counts.chip")])
plot(x = count.table$counts.input, xlab="Input counts",
     y = count.table$counts.chip, ylab="ChIP counts",
     main="ChIP versus input counts",
     col="darkviolet", panel.first=grid())

## ----fig.width=7, fig.height=7-------------------------------------------
plot(x = count.table$counts.input, xlab="Input counts per bin",
     y = count.table$counts.chip, ylab="ChIP counts per bin",
     main="ChIP versus input counts (log scale)",
     col="darkviolet", panel.first=grid(), log="xy")

## ----fig.width=7, fig.height=7-------------------------------------------
epsilon <- 0.1 ## Define a small pseudo-count
plot(x = count.table$counts.input + epsilon, 
     y = count.table$counts.chip + epsilon, 
     col="darkviolet", panel.first=grid(), log="xy")

## ----fig.width=7, fig.height=7-------------------------------------------
plot(x = count.table$counts.input + epsilon, xlab=paste("Input counts +", epsilon),
     y = count.table$counts.chip + epsilon,  ylab=paste("ChIP counts +", epsilon),
     col="darkviolet", panel.first=grid(), log="xy")
abline(a=0, b=1)

## ----fig.width=7, fig.height=4, fig.align="center"-----------------------
count.table$ratio <- (count.table$counts.chip + 1) / (count.table$counts.input + 1)

hist(count.table$ratio)

## ----fig.width=7, fig.height=4, fig.align="center"-----------------------
hist(count.table$ratio, breaks=100)

## ----fig.width=7, fig.height=4, fig.align="center"-----------------------
hist(count.table$ratio, breaks=1000)

## ----fig.width=7, fig.height=4-------------------------------------------
count.table$log2.ratio <- log2(count.table$ratio)
hist(count.table$log2.ratio, breaks = 200, xlim=c(-5,5), col="gray", xlab="Count ratios (truncated scale)")

## ------------------------------------------------------------------------
sum(count.table$counts.chip)
sum(count.table$counts.input)

## ----fig.width=7, fig.height=5, fig.align="center"-----------------------
## Normalize input counts by library sizes
count.table$input.scaled.libsize <- count.table$counts.input * sum(count.table$counts.chip)/sum(count.table$counts.input)

plot(x = count.table$input.scaled.libsize + 1, 
     y = count.table$counts.chip + 1, col="darkviolet", log="xy",
     main="ChIP versus input",
     xlab="Scaled input counts",
     ylab="ChIP counts")
grid()
abline(a=0, b=1, col="black")

## ----fig.width=7, fig.height=4, fig.align="center"-----------------------
count.table$scaled.ratio.libsum <- (count.table$counts.chip + epsilon ) / (count.table$input.scaled.libsize + epsilon)

hist(count.table$scaled.ratio.libsum, breaks=2000, xlim=c(0, 5), xlab="Count ratios after libsum scaling", main="Count ratio histogram", col="gray", border="gray")
abline(v=mean(count.table$scaled.ratio.libsum), col="darkgreen", lwd=3)
abline(v=median(count.table$scaled.ratio.libsum), col="brown", lwd=3, lty="dotted")
legend("topright", c("mean", "median"), col=c("darkgreen", "brown"), lwd=3, lty=c("solid", "dotted"))

## Print the mean and median scaled ratios
mean(count.table$scaled.ratio.libsum)
median(count.table$scaled.ratio.libsum)

## ------------------------------------------------------------------------
summary(count.table[, c("counts.chip", "counts.input")])

## ------------------------------------------------------------------------
## Normalize input counts by median count
count.table$input.scaled.median <- count.table$counts.input * median(count.table$counts.chip)/median(count.table$counts.input)

count.table$scaled.ratio.median <- (count.table$counts.chip + epsilon ) / (count.table$input.scaled.median + epsilon)

## Print the mean and median scaled ratios
mean(count.table$scaled.ratio.median)
median(count.table$scaled.ratio.median)

## ----fig.width=7, fig.height=5, fig.align="center"-----------------------
hist(count.table$scaled.ratio.median, breaks=2000, xlim=c(0, 5), xlab="Count ratios after median scaling", main="Count ratio histogram", col="gray", border="gray")
abline(v=mean(count.table$scaled.ratio.median), col="darkgreen", lwd=3)
abline(v=median(count.table$scaled.ratio.median), col="brown", lwd=3, lty="dotted")
legend("topright", c("mean", "median"), col=c("darkgreen", "brown"), lwd=3, lty=c("solid", "dotted"))

## ----log2.ratios---------------------------------------------------------
## Add a column with log2-ratios to the count table
count.table$log2.ratios <- log2(count.table$scaled.ratio.median)

## ----fig.width=10, fig.height=4, fig.align="center"----------------------
par(mfrow=c(1,2))

## Plot ratio distribution
hist(count.table$scaled.ratio.median, breaks=2000, xlim=c(0, 5), xlab="Count ratios after median scaling", main="Count ratio histogram", col="gray", border="gray")
abline(v=mean(count.table$scaled.ratio.median), col="darkgreen", lwd=3)
abline(v=median(count.table$scaled.ratio.median), col="brown", lwd=3, lty="dotted")
legend("topright", c("mean", "median"), col=c("darkgreen", "brown"), lwd=3, lty=c("solid", "dotted"))

## Plot log2-ratio distribution
hist(count.table$log2.ratios, breaks=100, xlim=c(-5, 5), xlab="log2(ChIP/input)", 
     main="log2(count ratios)", col="gray", border="gray")
abline(v=mean(count.table$log2.ratios), col="darkgreen", lwd=3)
abline(v=median(count.table$log2.ratios), col="brown", lwd=3, lty="dotted")
legend("topright", c("mean", "median"), col=c("darkgreen", "brown"), lwd=3, lty=c("solid", "dotted"))

## ----MA_plot-------------------------------------------------------------
count.table$M <- 1/2*(log2(count.table$counts.chip + epsilon) + log2(count.table$input.scaled.median + epsilon))

plot(count.table$M, count.table$log2.ratio)

## ------------------------------------------------------------------------
count.table$pvalue <- ppois(
  q=count.table$counts.chip, 
  lambda = count.table$input.scaled.median, lower.tail = FALSE)

## ----fig.width=7, fig.height=4, fig.align="center"-----------------------
hist(count.table$pvalue, breaks=20, col="grey")

## ----fig.width=7, fig.height=8-------------------------------------------
par(mfrow=c(3,1))
par(mar=c(2,4,0.5,0.5))
plot(count.table$midpos, count.table$counts.chip, type='h', col="darkgreen", xlab="", ylab="counts")
plot(count.table$midpos, -log10(count.table$pvalue), type='h', col="grey", xlab="", ylab="-log10(p-value)")
par(mfrow=c(1,1))

## ----eval=FALSE----------------------------------------------------------
## View(count.table)

## ----sessioninfo---------------------------------------------------------
## Print the complete list of libraries + versions used in this session
sessionInfo()

