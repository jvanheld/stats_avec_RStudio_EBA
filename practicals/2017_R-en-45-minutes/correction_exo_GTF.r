# Fichier GTF Saccharomyces_cerevisiae.R64-1-1.90.gtf récupéré sur :
# https://www.ensembl.org/info/data/ftp/index.html

# 1
# Copier le fichier Saccharomyces_cerevisiae.R64-1-1.90.gtf disponible dans 
# /projet/sbr/ggb/intro_R/ vers votre espace de travail.
file.copy(from="/projet/sbr/ggb/intro_R/Saccharomyces_cerevisiae.R64-1-1.90.gtf",
          to=getwd())

# 2
# Charger ce fichier dans R et afficher les 10 premières lignes. 
# Remarque : le fichier contient les colonnes suivantes : 
# seqname, source, feature, start, end, score, strand, frame, attribute
gtf <- read.table("Saccharomyces_cerevisiae.R64-1-1.90.gtf", sep="\t", header=FALSE,
                  col.names=c("seqname", "source", "feature", "start", "end", "score", "strand", "frame", "attribute"))
print(head(gtf, 10))

# 3
# Afin de gagner en lisibilité, supprimer la dernière colonne du tableau. 
# Afficher à nouveau les 10 premières lignes. Combien y en a-t-il au total?
gtf <- gtf[, -ncol(gtf)]
print(head(gtf, 10))
dim(gtf) # le fichier GTF contient 42071 lignes

# 4
# Combien le génome contient-il de gènes ? 
# Créer une data.frame contenant uniquement les gènes.
table(gtf$feature) # on a 7126 gènes
# première méthode
gtf.gene <- gtf[which(gtf$feature=="gene"),]
# seconde méthode
gtf.gene <- subset(gtf, feature=="gene")
print(head(gtf.gene, 10))
dim(gtf.gene)

# 5
# Pour cette nouvelle data.frame, créer une variable donnant 
# la longueur de chacun de ces gènes (end - start + 1)
gtf.gene$length <- gtf.gene$end - gtf.gene$start + 1

# 6
# Quelle est la longueur moyenne des gènes de cet organisme ? 
# Tracer l'histogramme de ces longueurs.
summary(gtf.gene$length) # longueur moyenne : 1301 nts
hist(gtf.gene$length, col="lightgrey", xlab="Length", 
     main="Gene length according to chromosome")

# 7
# A l'aide de boxplots, tracer la distribution de la longueur des 
# gènes pour chacun des chromosomes
boxplot(length ~ seqname, data=gtf.gene, col=1:nlevels(gtf.gene$seqname),
        xlab="Chromosome", ylab="Gene length")
