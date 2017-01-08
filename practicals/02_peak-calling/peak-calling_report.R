## ------------------------------------------------------------------------
#url.course <- "~/stats_avec_RStudio_EBA/" # For JvH local test only
url.course <- "http://jvanheld.github.io/stats_avec_RStudio_EBA/"
url.data <- file.path(url.course, "practicals", "02_peak-calling", "data")

## Choose a window size (200 or 50)
window.size <- 200

## Load counts per window in chip sample
chip.bedg.file <- paste(sep="", 
                        "FNR_",
                        window.size,"bp.bedg")
chip.bedg <- read.table(file.path(url.data, chip.bedg.file))
names(chip.bedg) <- c("chrom", "start", "end","counts")

## Load counts per window in the input sample
input.bedg.file <- paste(sep="", "input_",window.size,"bp.bedg")
input.bedg <- read.table(file.path(url.data, input.bedg.file))
names(input.bedg) <- c("chrom", "start", "end","counts")

## ------------------------------------------------------------------------
dim(chip.bedg) ## Check number of rows and columns
head(chip.bedg) ## check the content of the first rows

dim(input.bedg) ## Check number of rows and columns (should be the same as for test file)
head(input.bedg) ## check the content of the first rows

## ------------------------------------------------------------------------
## The fourth column of the bedgraph file contains the counts
chip.counts <- chip.bedg[,4] 
input.counts <- input.bedg[,4] 

## Count total counts
chip.total <- sum(chip.counts)
input.total <- sum(input.counts)

## Compare total counts between test and input samples
print(chip.total)
print(input.total)
print (input.total/chip.total)

## ------------------------------------------------------------------------
G <- 4641652 ## Genome size
print(genome.coverage <- sum(input.total) * 35 / G)

## ------------------------------------------------------------------------
## Option 1: mormalize the data based on the library sum
norm.input.libsum <- input.counts * chip.total / input.total
head(norm.input.libsum)

## Option 1: mormalize the data based on median counts per library.
## This is more robust to outliers, esp. in the ChIP sample, 
## where the actual peaks bias the mean towards higher values
norm.input.median <- input.counts *  median(chip.counts) /  median(input.counts)
head(norm.input.median)

# Check the normalizing effect: 
# Libsum-scaled input counts should have the same sum as test counts.
sum(chip.counts)
sum(norm.input.libsum)
sum(norm.input.libsum)/sum(chip.counts)

# Median-scaled input counts do not have the same sum as test counts.
sum(norm.input.median)
sum(norm.input.median)/sum(chip.counts)

## Make a choice between options 1 and 2
norm.input <- norm.input.median

## Display the first elements of the normalized input counts
head(norm.input)

## ----fig.width=7, fig.height=7-------------------------------------------
par(mfrow=c(1,1))
plot(norm.input, chip.counts, 
     xlab="Normalized input", ylab="Test", 
     col="#666666",
     main="Counts per window")
grid()

## ----fig.width=7, fig.height=7-------------------------------------------
## Compute the range of counts for all windows (test or input) in order to use the same scale to display counts on comparative graphs
count.range <- range(c(chip.counts, norm.input))

## Note: we add 1 to the counts in order to avoid problem with the logarithmic scale
par(mfrow=c(1,1))
plot(norm.input+1, chip.counts+1, 
     xlab="Normalizd input (x=count+1)", 
     ylab="Test (y=count+1)", 
     main="Counts per window", 
     log="xy", col="gray", xlim=count.range+1, ylim=count.range+1)
abline(a=0,b=1) ## Plot the diagonal to compare counts between samples
grid()

## Roughly surround a region of interest to be discussed below 
abline(h=500, col="red")
abline(v=c(100,200),col="red", lty="dotted")

## ----fig.width=7, fig.height=8-------------------------------------------
max.count <- count.range[2]
par(mfrow=c(2,1))

hist(chip.counts, breaks=c(seq(from=0,to=300,by=5),max.count), 
     xlim=c(0,300), freq=TRUE, col="blue", 
     main="Read counts in test sample",
     xlab="Reads per window", ylab="Number of windows")

hist(norm.input, breaks=c(seq(from=0,to=300,by=5),max.count), 
     xlim=c(0,300),freq=FALSE, col="gray",
     main="Read counts in normalized input sample",
    xlab="Reads per window", ylab="Number of windows")

par(mfrow=c(1,1)) ## Restore default plot setting

## ----fig.width=7, fig.height=8-------------------------------------------
## Compute the middle position of each window (do use as coordinate for plots)
chip.midpos <- (chip.bedg[,3] +  chip.bedg[,2])/2
input.midpos <- (input.bedg[,3] +  input.bedg[,2])/2

par(mfrow=c(2,1)) ## Split the plot window in two vertical panels

## Note: we add 1 to the counts to avoid problems with the logarithmic scale
plot(chip.midpos,
     chip.counts + 1, 
     col="blue", log="y",
     main="Chromosomal distribution of reads: Test sample",
     type="l",
     xlab="chromosomal position",
     ylab="Reads (+1) per window", ylim=count.range+1)
grid()
abline(h=mean(chip.counts), col="#00CC00", lwd=2)

plot(input.midpos,
     norm.input + 1, 
     col="gray", log="y",
     main="Chromosomal distribution of reads: Input sample",
     type="l",
     xlab="chromosomal position",
     ylab="Reads (+1) per window", ylim=count.range+1)
grid()
abline(h=mean(norm.input), col="#00CC00", lwd=2)
par(mfrow=c(1,1))

## ------------------------------------------------------------------------
# a.  Number of reads in the test (FNR ChIP-seq)
# b.  Number of reads in the input
# c.  Normalized number of reads in the input (norm.input)
read.stats <- cbind(chip.bedg, input.counts, norm.input)

# d.  Reads per base in the normalized input
read.stats$input.norm.rpb <- read.stats$norm.input/window.size
  
# e.  Fold enrichment (ratio between test and normalized input)
read.stats$fold <- read.stats$counts/read.stats$norm.input

# f.  Log-fold enrichment (log(10) of the fold enrichment)
read.stats$log.fold <- log(base=10, read.stats$fold)

head(read.stats)

## ------------------------------------------------------------------------
## Compute the prior probabilities
n.FNR = sum(chip.counts) ## Number of reads in FNR library
print(paste("Marked = n.FNR = ", n.FNR))

n.input = sum(input.counts) ## Number of reads in the input library
print(paste("Non-marked = n.input = ", n.input))

p.FNR = n.FNR/(n.FNR + n.input) ## Prior probability to belong to the FNR library
print(paste("Prior probability for the FNR library=", format(p.FNR, digits=4)))

read.stats$phyper <- phyper(chip.counts-1, 
                                m=n.FNR, 
                                n=n.input, 
                                k=chip.counts+input.counts, 
                                lower=FALSE, log=FALSE)
head(read.stats)

## ------------------------------------------------------------------------
n.FNR <- sum(chip.counts) ## Size of the FNR library
n.input <- sum(input.counts) ## Size of the input library
N <-n.FNR  + n.input ## Total number of read counts

## A vector indicating as "marked" the number of test+input counts in each window. 
## Each window will be considered successively as the "marked" reads for the hypergeometric
m.per.window <- chip.counts + input.counts 

## Similarly , we define the number of no-marked reads per window, i.e. those not belonging to the considered window
n.per.window <- N - m.per.window

read.stats$phyper.bis <- phyper(chip.counts-1, 
                              m=m.per.window, 
                              n=n.per.window, 
                              k=n.FNR, 
                              lower=FALSE,log=FALSE)

head(read.stats)

## ------------------------------------------------------------------------

# sum(read.stats$norm.input != read.stats$input.counts*m/n) == 0
## Compute the Poisson p-value
read.stats$ppois <- ppois(q=read.stats$counts-1, 
                          lambda=read.stats$norm.input, 
                          lower.tail=FALSE, log=FALSE)



## ------------------------------------------------------------------------

## Prior probability for a read to fall within a given window
read.stats$window.prior <- input.counts/sum(input.counts)
print (range(read.stats$window.prior))
hist(read.stats$window.prior, breaks=100, col="#DDFFDD")
abline(v=mean(read.stats$window.prior), lwd=3, col="darkgreen")

## Prior probability per window if one would assume equiprobability (which we don't)
equi.p = (1/nrow(read.stats))
print(paste("Equiprobable window prior =", equi.p))

## Verification: this equiprobable prior should equal the mean probability of the window-specific priors
mean.p = mean(read.stats$window.prior)
print(paste("Mean window prior = ", mean.p))
print(paste("Equality ? ", mean.p == equi.p))


## Compute the P-value of the test reads, using a binomial distribution (explain your model).
read.stats$pbinom <- pbinom(q=chip.counts-1, 
                            size=sum(chip.counts), 
                            prob=read.stats$window.prior, 
                            lower=FALSE, log=FALSE)

## Display the first rows of the stats table
head(read.stats)


## ----fig.width=8, fig.height=8-------------------------------------------
## Plot the Poisson versus binomial p-values
plot(read.stats[,c("ppois","pbinom")],log="xy", 
     col="#666666",
     main="P-value estimations",
     xlab="Poisson p-value", ylab="Alternative p-values",
     panel.first=c(grid(),abline(a=0,b=1, col="blue")))

legend("topleft", legend=c("Binomial", "Hypergeometric"),pch=c(1,2))

## Plot the hypergeometric versus Poisson p-values
lines(read.stats[,c("ppois","phyper")],type="p", pch=2)

## ----width=7, height=12--------------------------------------------------

par(mfrow=c(3,1))
## Draw histograms of p-value distributions
hist(read.stats$ppois, breaks=20, 
     main ="Poisson p-value distributions",
     xlab="p-value", ylab="Frequency")


## Draw histograms of p-value distributions
hist(read.stats$pbinom, breaks=20, 
     main ="Binomial p-value distributions",
     xlab="p-value", ylab="Frequency")


## Draw histograms of p-value distributions
hist(read.stats$phyper, breaks=20, 
     main ="Hypergeometric p-value distributions",
     xlab="p-value", ylab="Frequency")


