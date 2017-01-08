## ----include=FALSE, echo=FALSE, eval=TRUE--------------------------------
options(width=300)
knitr::opts_chunk$set(echo = TRUE, eval=TRUE, fig.width = 7, fig.height = 5, fig.align = "center", size = "tiny", warning = FALSE, results = TRUE, message = FALSE, comment = "")

## ----eval=FALSE----------------------------------------------------------
## source("http://bioconductor.org/biocLite.R")
## if (!require(DESeq2)) {
##   biocLite("DESeq2", ask=FALSE)
## }
## if (!require(edgeR)) {
##   biocLite("edgeR", ask=FALSE)
## }
## if (!require(gplots)) {
##   biocLite("gplots", ask=FALSE)
## }

## ------------------------------------------------------------------------
URL.course <- "http://jvanheld.github.io/stats_avec_RStudio_EBA"

# Load the files content in an R data.frame
path.counts <- file.path(URL.course, "/practicals/yeast_2x48_replicates/data/counts.txt")
counts <- read.table(file=path.counts, sep="\t", header=TRUE, row.names=1)

path.expDesign <- "http://jvanheld.github.io/stats_avec_RStudio_EBA/practicals/yeast_2x48_replicates/data/expDesign.txt"
expDesign <- read.table(file=path.expDesign, sep="\t", header=TRUE)

## ------------------------------------------------------------------------
# look at the beginning of the counts and design table:
print(counts[1:4,1:4])
print(expDesign[1:4,])

# dimension of each table
dim(counts)
dim(expDesign)

## ----eval=FALSE----------------------------------------------------------
## View(counts)
## View(expDesign)

## ------------------------------------------------------------------------
print(expDesign$strain)
expDesign$strain <- relevel(expDesign$strain, "WT")
print(expDesign$strain)

## ------------------------------------------------------------------------
barplot(colSums(counts)/1000000, main="Total number of reads per sample (million)")

## ------------------------------------------------------------------------
prop.null <- apply(counts, 2, function(x) 100*mean(x==0))
print(head(prop.null))
barplot(prop.null, main="Percentage of null counts per sample", las=1)

## ----message=FALSE-------------------------------------------------------
# Load the DESeq2 R package
library(DESeq2)

# Build the DESeq2 main object with the count data + experimental design
dds0 <- DESeqDataSetFromMatrix(countData = counts, colData = expDesign, design = ~ strain)

# Print a summary of the data content
print(dds0)

## ----message=TRUE--------------------------------------------------------
# Detect differentially expressed genes
dds0 <- DESeq(dds0) 
res0 <- results(dds0)
print(res0)
print(summary(res0))
print(mcols(res0))

## ------------------------------------------------------------------------
nb.replicates <- 4 ## Each attendee chooses a number (3,4,5,10,15 or 20)
## Random sampling of the WT replicates (columns 1 to 48)
samples.WT <- sample(1:48, size=nb.replicates, replace=FALSE)
## Random sampling of the Snf2 replicates (columns 49 to 96)
samples.Snf2 <- sample(49:96, size=nb.replicates, replace=FALSE)
print(c(samples.WT, samples.Snf2))
dds <- DESeqDataSetFromMatrix(
  countData = counts[,c(samples.WT, samples.Snf2)], 
  colData = expDesign[c(samples.WT, samples.Snf2),], 
  design = ~ strain)
print(dds)

## ----fig.width=14--------------------------------------------------------
dds <- estimateSizeFactors(dds)
print(sizeFactors(dds))
# effect of the normalization
par(mfrow=c(1,2))
boxplot(log2(counts(dds, normalized=FALSE)+1), main="Raw counts", col=rep(c("lightblue","orange"), each=nb.replicates))
boxplot(log2(counts(dds, normalized=TRUE)+1), main="Normalized counts", col=rep(c("lightblue","orange"), each=nb.replicates))

## ----warning=FALSE-------------------------------------------------------
mean.counts <- rowMeans(counts(dds))
variance.counts <- apply(counts(dds), 1, var)
plot(x=mean.counts, y=variance.counts, pch=16, cex=0.3, main="Mean-variance relationship", log="xy")
abline(a=0, b=1)

## ----message=FALSE, fig.width=10-----------------------------------------
# dispersions estimation
dds <- estimateDispersions(dds)
# make the data homoscedastic
rld <- rlog(dds) # alternative to the "Variance Stabilizing Transformation"
plotPCA(rld, intgroup="strain") # function from the DESeq2 package

## ------------------------------------------------------------------------
dds <- nbinomWaldTest(dds)
res.DESeq2 <- results(dds, alpha=0.05, pAdjustMethod="BH")
print(head(res.DESeq2))
summary(res.DESeq2, alpha=0.05)

## ------------------------------------------------------------------------
hist(res.DESeq2$pvalue, col="lightblue", main="Histogram of raw P-values (DESeq2)", breaks=20, xlab="P-value")

## ------------------------------------------------------------------------
plotMA(res.DESeq2, alpha=0.05) # function from the DESeq2 package

## ------------------------------------------------------------------------
## Draw a volcano plot
plot(x=res.DESeq2$log2FoldChange, y=-log10(res.DESeq2$padj), 
     xlab="log2(Fold-Change)", ylab="-log10(adjusted P-value",
     col=ifelse(res.DESeq2$padj<=0.05, "red", "black"), main="Volcano plot")
grid() ## Add a grid to the plot
abline(v=0) ## plot the X axis

## ----message=FALSE-------------------------------------------------------
# load the edgeR R package
library(edgeR)
# create the edgeR main object: dge
dge <- DGEList(counts=counts[,c(samples.WT, samples.Snf2)], remove.zeros=FALSE)
dge$design <- model.matrix(~ strain, data=expDesign[c(samples.WT, samples.Snf2),])
print(dge)

## ------------------------------------------------------------------------
# normalization
dge <- calcNormFactors(dge)
print(dge$samples$norm.factors)
# dispersions
dge <- estimateGLMCommonDisp(dge, dge$design)
dge <- estimateGLMTrendedDisp(dge, dge$design)
dge <- estimateGLMTagwiseDisp(dge, dge$design)

## ------------------------------------------------------------------------
fit <- glmFit(dge, dge$design)
print(dge$design)
lrt <- glmLRT(fit)
res.edgeR <- topTags(lrt,n=nrow(dge$counts),adjust.method="BH")$table
print(head(res.edgeR))

## ------------------------------------------------------------------------
hist(res.edgeR$PValue, col="lightblue", main="Histogram of raw P-values (edgeR)", breaks=20, xlab="P-value")

## ------------------------------------------------------------------------
plot(x=sizeFactors(dds), y=dge$samples$norm.factors, xlab="DESeq2 size factors", ylab="edgeR normalization factors", pch=16)

## ------------------------------------------------------------------------
print(head(res.DESeq2))
print(head(res.edgeR))
res.edgeR <- res.edgeR[order(rownames(res.edgeR)),]
res.DESeq2 <- res.DESeq2[order(rownames(res.DESeq2)),]

## ------------------------------------------------------------------------
plot(x=res.edgeR$logFC, y=res.DESeq2$log2FoldChange, 
     pch=16, cex=0.4, xlim=c(-2,2), ylim=c(-2,2),
     xlab="edgeR log2(Fold-Change)", ylab="DESeq2 log2(Fold-Change)")
abline(a=0, b=1, col="red", lwd=4) # draw the y=x curve (y=a+b*x with a=0 and b=1)
abline(h=0, v=0) # horizontal and vertical line

## ------------------------------------------------------------------------
plot(x=res.edgeR$PValue, y=res.DESeq2$pvalue, 
     pch=16, cex=0.4, xlab="edgeR raw P-value", ylab="DESeq2 raw P-value")
abline(a=0, b=1, col="red", lwd=4) # draw the y=x curve (y=a+b*x with a=0 and b=1)

## ------------------------------------------------------------------------
# remember the number of replicates
print(nb.replicates)
# DESeq2
sum(res.DESeq2$padj <= 0.05, na.rm=TRUE)
# edgeR
sum(res.edgeR$FDR <= 0.05, na.rm=TRUE)

## ----message=FALSE-------------------------------------------------------
library(gplots)
venn(list(DESeq2=rownames(res.DESeq2[which(res.DESeq2$padj <= 0.05),]), 
          edgeR=rownames(res.edgeR[which(res.edgeR$FDR <= 0.05),])))

## ------------------------------------------------------------------------
DESeq2.genes <- rownames(res.DESeq2[which(res.DESeq2$padj <= 0.05),])
edgeR.genes <- rownames(res.edgeR[which(res.edgeR$FDR <= 0.05),])
# select a DESeq2 specific gene
spe.DESeq2 <- setdiff(DESeq2.genes, edgeR.genes)
summary(res.edgeR[spe.DESeq2,"FDR"])
# select a edgeR specific gene
spe.edgeR <- setdiff(edgeR.genes, DESeq2.genes)
summary(res.DESeq2[spe.edgeR,"padj"])

## ------------------------------------------------------------------------
# plotCounts is a function from the DESeq2 R package
plotCounts(dds, gene="ycr017c", intgroup="strain", normalized=TRUE)

## ------------------------------------------------------------------------
nb.replicates <- 10
samples.WT <- sample(1:48, size=2*nb.replicates, replace=FALSE)
print(samples.WT)
counts.H0 <- counts[,samples.WT]
expDesign.H0 <- expDesign[samples.WT,]
# add a fictive condition factor
expDesign.H0$condition <- factor(rep(c("A","B"), each=nb.replicates))
print(expDesign.H0)
dds.H0 <- DESeqDataSetFromMatrix(countData = counts.H0, colData = expDesign.H0, design = ~ condition)

## ----message=FALSE-------------------------------------------------------
dds.H0 <- DESeq(dds.H0)
res.H0 <- results(dds.H0)
summary(res.H0)

## ------------------------------------------------------------------------
sessionInfo()

