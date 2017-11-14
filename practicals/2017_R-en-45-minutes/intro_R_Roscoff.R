########################################################################
#                     Introduction à R... en 1h45                      #
#                                                                      #
# Hugo Varet (Institut Pasteur)                                        #
# Ecole de Bioinformatique AVIESAN-IFB                                 #
# Roscoff 2017                                                         #
########################################################################

# quelques liens utiles:
#  - http://www.r-project.org
#  - http://cran.r-project.org
#  - https://www.rstudio.com
#  - http://www.bioconductor.org
#  - https://www.rstudio.com/wp-content/uploads/2016/10/r-cheat-sheet-3.pdf
#  - http://www.sthda.com/english/wiki/r-basics-quick-and-easy

########################################################################
#                     R vu comme une calculatrice                      #
########################################################################
# symbole ">" signifie que R est prêt à recevoir une nouvelle instruction. Exemple:
2 + 3
2 * 3
2 / 3

# symbole "+" signifie que l'instruction envoyée n'est pas complète. Exemple:
2 *

# aucun symbole: R est en train d'effectuer des calculs. Exemple:
mean(rnorm(100000000))

# le symbole # permet d'écrire des commentaires, i.e. du texte non interprété par R

########################################################################
#                       utiliser des variables                         #
########################################################################
# affectation d'une valeur à une variable: <- ou =
a <- 2
b = 3
resultat <- a * b + a + b
print(resultat)

# R est sensible à la casse
print(Resultat)

ma_nouvelle_variable_avec_un_nom_a_rallonge <- 10

# attention: certains noms sont déjà utilisés pour des fonctions/objets
c # créer un vecteur
t # transposer une matrice
sum # fonction somme
mean # fonction moyenne

TRUE # booléen
FALSE # booléen
T # booléen
F # booléen

NA # not available
NaN # not a number (par exemple log(-1))
Inf # infini (par exemple 1/0)
NULL # objet nul

pi # 3.14...
letters # 26 lettres minuscules
LETTERS # 26 lettres majuscules

########################################################################
#                          types de données                            #
########################################################################
#####################################
#              numeric              #
#####################################
# "double precision floating point numbers"
x <- 3
print(x)
mode(x)
typeof(x)

# entiers
y <- as.integer(2)
print(y)
mode(y)
typeof(y)

# différence entre double et integer: integers utilisent moins d'espace mémoire

#####################################
#             character             #
#####################################
x <- "chaîne de caractères, toujours entre guillemets"
print(x)
y <- 'ou avec des guillemets simples'
print(y)

mode(x)
nchar(x)
paste(x, y, sep=" / ")

#####################################
#              logical              #
#####################################
x <- TRUE # ou T ou FALSE ou F
print(x)
mode(x)

# sera utile pour tester des choses :
# if (condition){
#   faire ça
# } else {
#   faire autre chose
# }

########################################################################
#                         structures de données                        #
########################################################################
#####################################
#             vecteurs              #
#####################################
# plusieurs élements du même type (numeric, character...)
u <- c(2, 4, 5, 1)
print(u)
v <- c(10, 5, 2, 2)
print(v)
w <- c("Pierre", "Paul", "Jacques", "Henri")
print(w)
l <- c(TRUE, FALSE, FALSE, TRUE)
print(l)

# caractéristiques d'un vecteur
length(u)
mode(u)
mode(w)
mode(l)

# sélection/suppression d'éléments d'un vecteur
u[2]
u[-2]
u[c(1, 3)]
u[l]
u >= 3
u[which(u >= 3)]
v %in% c(2, 5)
v[which(v %in% c(2, 5))]

# opérations sur des vecteurs
sort(u)
summary(u)
sum(u)
mean(u)
u + v
u * v
u / v
cbind(u, v)
rbind(u, v)

# création de séquences
1:10
seq(from=1, to=100, by=10)
seq(from=1, to=100, length=4)
rep(x=c(1, 2), times=3)
rep(x=c(1, 2), each=3)

# valeurs manquantes
u <- c(4, NA, 5, 2, NA, 3)
mean(u)
mean(u, na.rm=TRUE)

#####################################
#             facteurs              #
#####################################
mentions <- c("Passable", "AB", "AB", "B", "TB", "TB", "Passable", "B", "Passable", "TB")
print(mentions)

# vecteur avec des catégories
f <- factor(mentions)
print(f)
levels(f)
table(f)

# notion d'ordre
f <- factor(mentions, levels=c("Passable", "AB", "B", "TB"))
print(f)
levels(f)
table(f)

# NA et catégories non représentées
f <- factor(c("Passable", NA, "AB", "AB", NA, "B"), levels=c("Passable", "AB", "B", "TB"))
print(f)
levels(f)
table(f)
table(f, useNA="ifany")

#####################################
#             matrices              #
#####################################
# tableau à N lignes et P colonnes avec des éléments du même type (numeric, character...)
m <- matrix(rnorm(30), nrow=6, ncol=5)
print(m)
n <- matrix(c("a","b","c","d","e","f"), ncol=3, byrow=TRUE)
print(n)

# caractéristiques d'une matrice
ncol(m)
nrow(m)
dim(m)
length(m)
mode(m)
mode(n)

# opérations sur des matrices
mat1 <- matrix(1:6, nrow=2, ncol=3)
mat2 <- matrix(rnorm(6), nrow=2, ncol=3)
print(mat1)
print(mat2)
# élément par élément
mat1 + mat2
mat1 * mat2
# produit matriciel (attention aux dimensions)
mat1 %*% t(mat2)
t(mat1) %*% mat2
# somme, moyenne...
sum(mat1) # de tous les éléments
rowSums(mat1) # des éléments de chaque ligne
colSums(mat1) # des éléments de chaque colonne
mean(mat1)
rowMeans(mat1)
colMeans(mat1)

# sélection/suppression d'éléments d'une matrice
mat1[, c(2, 3)]
mat1[1,]
mat1[1, c(2, 3)]

#####################################
#              listes               #
#####################################
# permet de stocker des objets de types/longueurs différents
l1 <- list(n = c(TRUE, FALSE), 
           v = c(3, 4), 
           r = c("toto","plop", "tutu"), 
           mat1)
print(l1)
length(l1)
names(l1)

# liste contenant une liste
l2 <- list(a="chaîne de caractères", l1=l1)
print(l2)

# extraction d'éléments d'une liste
l1$n
l2$l1
l2$l1$v
l2[1]
l2[[1]]
is.list(l2[1])
is.list(l2[[1]])

#####################################
#            data.frame             #
#####################################
# tableau dont les colonnes ne sont pas nécessairement du même type (numeric, character...)
d <- data.frame(nom=c("Pierre", "Paul", "Henri", "Mathieu"), 
                taille=c(165, 168, 163, 170), 
                poids=c(58, 60, 62, 68))
print(d)
class(d)
typeof(d) # une data.frame est un cas particulier d'une liste

# caractéristiques d'une data.frame
ncol(d)
nrow(d)
names(d)
length(d)

# sélection de colonnes
d$taille
d[, "taille"]
d[, c("nom", "taille")]

# sélection de lignes
d[c(1, 3:4), ]
d$nom == "Pierre"
d[which(d$nom == "Pierre"),]

# résumé statistique
summary(d)

# fusion de deux data frames
d2 <- data.frame(nom=c("Paul","Henri","Louis"), age=c(34, 29, 47))
print(d2)
merge(x=d, y=d2, by="nom")
merge(x=d, y=d2, by="nom", all=TRUE)
merge(x=d, y=d2, by="nom", all.x=TRUE)
merge(x=d, y=d2, by="nom", all.y=TRUE)

# création d'une nouvelle variable
print(d)
d$age <- c(35, 42, 31, 28)
d$classe_poids <- ifelse(test=d$poids >= 60, yes=">=60", no="<60")
print(d)

########################################################################
#                                 aide                                 #
########################################################################
help(read.table)
?read.table

# sur le web:
#  - Google !!!
#  - plein de forums dédiés: https://stackoverflow.com/ par exemple
#  - mailing list: https://www.r-project.org/mail.html
#  - spéficique Bioconductor: https://support.bioconductor.org/

# ici:
#  - les formateurs !

########################################################################
#                           espace de travail                          #
########################################################################
# où suis-je ? équivalent de la commande unix 'pwd'
getwd()

# changement de répertoire courant: équivalent de la commande unix 'cd <path>'
setwd("chemin/acces/au/nouveau/repertoire/")

########################################################################
#                       lire et écrire des données                     #
########################################################################
# quelques manipulations de fichiers
f <- list.files(path="/projet/sbr/ggb/intro_R/", full.names=TRUE)
print(f)
file.copy(from=f, to=getwd())

# vérifier que les fichiers sont bien présents dans l'espace de travail
list.files(path=getwd())

# charger le fichier rnaseq_data.txt
rna <- read.table("rnaseq_data.txt", sep="\t", header=TRUE)
print(rna)
print(head(rna))

# charger le fichier rnaseq_data.csv
rna2 <- read.table("rnaseq_data.csv", sep=";", header=FALSE, 
                   col.names=c("geneid","name","WT1","WT2","WT3","KO1","KO2","KO3"))
print(head(rna2))

# exporter des données dans un fichier (qui sera écrasé s'il existe déjà !)
write.table(rna, file="rnaseq_export.txt", sep=" ", col.names=FALSE, row.names=FALSE)

########################################################################
#                           environnement R                            #
########################################################################
# liste des objets présents dans l'environnement R
ls()

# suppression d'un objet (utile si particulièrement lourd)
a <- 3
print(a)
rm(a)
print(a)
a <- 3
print(a)

# sauvegarde de tout l'environnement, i.e. tous les objets existants
save.image(file="mon_environnement.RData")

# suppression de tous les éléments présents dans la session R
rm(list=ls())
ls()
load("mon_environnement.RData")
ls()

# sauvegarde d'un objet spécifique
print(a)
save(a, file="objet_a.RData")

# chargement d'un objet/environnement
rm(a)
print(a)
load("objet_a.RData")
print(a)

########################################################################
#                            graphiques                                #
########################################################################
# plot y vs x
plot(x=d$taille, y=d$poids)
plot(formula=d$poids ~ d$taille)
plot(formula=poids ~ taille, data=d)

# boite à moustache d'une série de valeurs
boxplot(d$poids)

# histogramme d'une série de valeurs
hist(d$poids)

# diagramme en bâtons
table(d$classe_poids)
barplot(table(d$classe_poids), col=c("lightblue","orange"))

# customisation rapide
plot(formula=poids ~ taille, data=d, pch=16, col="red",
     main="Poids vs taille de 4 individus", xlab="Taille (cm)", ylab="Poids (kg)")

# liste des couleurs disponibles
colors()

########################################################################
#                            programmation                             #
########################################################################
#####################################
#             fonctions             #
#####################################
ma_fonction <- function(x, y, z=0){
  resultat <- x + y + z
  return(resultat)
}

ma_fonction(x=100, y=10)
ma_fonction(100, 10, 1000)
ma_fonction(z=10000, x=10, y=100)

#####################################
#             condition             #
#####################################
# quelques opérateurs
2 < 3
2 >= 2
2 != 3
4 == 4
2 == 3 | 3 == 3
2 == 3 & 3 == 3

a <- 1
if (a == 1){
  print("a est bien égal à 1")
} else{
  print("a n'est pas égale à 1")
}

# attention: une seule chose doit être testée
v <- c(1, 3, 0)
v == 3
if (v == 3){
  print("v est égal à 3")
} else{
  print("v n'est pas égal à 3")
}

#####################################
#              boucles              #
#####################################
for (i in 1:6){
  phrase <- paste("Voici le nombre", i)
  print(phrase)
}

prenoms <- c("pierre", "paul", "jacques", "louis")
for (i in 1:length(prenoms)){
  phrase <- paste("il ou elle s'appelle", prenoms[i])
  print(phrase)
}

for (p in prenoms){
  phrase <- paste("il ou elle s'appelle", p)
  print(phrase)
}

#####################################
#             tant que              #
#####################################
a <- 1
while (a < 4){
  print(paste("a est égal à", a))
  a <- a + 1
}

########################################################################
#                              packages                                #
########################################################################
# CRAN: 11203 packages (août 2017) avec croissance exponentielle
# Bioconductor: 1381 "software" packages (août 2017)

# chargement d'un package déjà installé
library(survival)
# rend disponible des fonctions spécifiques aux modèles de survie, par exemple:
?coxph

# installation d'un package disponible sur le CRAN
install.packages("packHV")
library(packHV)
?desc

# installation d'un package disponible sur Bioconductor
source("https://bioconductor.org/biocLite.R")
biocLite("rfPred")
# répondre "n" si R propose d'updater des packages
library(rfPred)
?rfPred_scores

########################################################################
#                        modélisation statistique                      #
########################################################################
# modèle linéaire simple
fit <- lm(formula=poids ~ taille, data=d)
fit
summary(fit)

# interprétation graphique
plot(formula=poids ~ taille, data=d, pch=16, col="red",
     main="Poids vs taille de 4 individus", xlab="Taille (cm)", ylab="Poids (kg)")
abline(a=-75.7931, b=0.8276, lty=2, lwd=3, col="grey")

########################################################################
#                       et plein d'autres choses                       #
########################################################################
# analyses exploratoires: ACP, clustering, etc
# tests statistiques
# génération automatique de rapports d'analyses en PDF/HTML via rmarkdown: mélange de texte, code et résultats
# applications web via R-Shiny (e.g. checkmyindex.pasteur.fr ou shaman.c3bi.pasteur.fr)
