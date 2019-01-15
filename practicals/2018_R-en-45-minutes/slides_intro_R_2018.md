---
title: "Introduction à R"
author: "Hugo Varet, Olivier Kirsh et Jacques van Helden"
date: '2019-01-15'
output:
  slidy_presentation:
    smart: no
    slide_level: 2
    self_contained: yes
    fig_caption: yes
    fig_height: 6
    fig_width: 7
    highlight: tango
    incremental: no
    keep_md: yes
    smaller: yes
    theme: cerulean
    toc: yes
    widescreen: yes
  ioslides_presentation:
    slide_level: 2
    self_contained: no
    colortheme: dolphin
    fig_caption: yes
    fig_height: 6
    fig_width: 7
    fonttheme: structurebold
    highlight: tango
    smaller: yes
    toc: yes
    widescreen: yes
  html_document:
    self_contained: no
    fig_caption: yes
    highlight: zenburn
    theme: cerulean
    toc: yes
    toc_depth: 3
    toc_float: yes
  pdf_document:
    fig_caption: yes
    highlight: zenburn
    toc: yes
    toc_depth: 3
  beamer_presentation:
    colortheme: dolphin
    fig_caption: yes
    fig_height: 6
    fig_width: 7
    fonttheme: structurebold
    highlight: tango
    incremental: no
    keep_tex: no
    slide_level: 2
    theme: Montpellier
    toc: yes
font-import: http://fonts.googleapis.com/css?family=Risque
subtitle: Ecole de Bioinformatique Aviesan-IFB 2018
font-family: Garamond
transition: linear
---




## Se connecter au serveur RStudio de Roscoff

<http://r.sb-roscoff.fr/auth-sign-in>

## Aller dans son dossier de travail

Définir une variable qui indique le chemin du dossier de travail


```r
work.dir <- "~/intro_R" 
```

S’il n’existe pas encore, créer le dossier de travail.
(Commande Unix équivalente: "mkdir -p ~/intro_R")


```r
dir.create(work.dir, recursive = TRUE, showWarnings = FALSE)
```

Aller dans ce dossier de travail.
(Commande Unix équivalente: "cd ~/intro_R")


```r
setwd(work.dir)	
```

Où suis-je ? 
(Commande Unix équivalente: "pwd")


```r
getwd()
```

Qu'y a-t-il par ici ? 
(Commande Unix équivalente: "ls")


```r
list.files()
```

## R vu comme une calculatrice


```r
2 + 3
4 * 5
6 / 4
```

## Notion de variable/objet



```r
a <- 2      ## Assigner une valeur à une variable
print(a)    ## Afficher la valeur de la variable a
```


```r
b <- 3      ## Assigner une valeur à une seconde variable
c <- a + b  ## Effectuer un calcul avec 2 variables
print(c)    ## Afficher le contenu de la variable c
```



```r
a <- 7      ## Changer la valeur de a
print(c)    ## Note: le contenu de c n'est pas modifié
```


## Télécharger un fichier

La commande `download()` permet de télécharger un fichier à partir d'un serveur. 


```r
## download.file(url = "https://goo.gl/9QVAg6", destfile = "expression.txt")
```


```r
## download.file(url = "https://goo.gl/NQWnHg", destfile = "annotation.csv")
```

## Chargement des données

Charger le contenu du fichier "expression.txt" dans une variable nommée "exprs".


```r
exprs <- read.table(file = "expression.txt", header = TRUE, sep = "\t")
```

Accéder à l'aide d'une fonction


```r
help(read.table)
```

Notation alternative


```r
?read.table
```


## Affichage de l'objet "exprs"

Imprimer toutes les valeurs.


```r
print(exprs)
```

```
                id    WT1   WT2    KO1   KO2
1  ENSG00000034510 235960 94264 202381 91336
2  ENSG00000064201    116    71     64    56
3  ENSG00000065717    118   174    124   182
4  ENSG00000099958    450   655    301   472
5  ENSG00000104164   4736  5019   4845  4934
6  ENSG00000104783   9002  8623   7720  7142
7  ENSG00000105229   1295  2744   1113  2887
8  ENSG00000105723   3353  7449   3589  7202
9  ENSG00000116199   2044  4525   2604  4902
10 ENSG00000118939   7022  2526   6269  3068
11 ENSG00000119285  15783 17359  18591 20077
12 ENSG00000121680   3133  2775   2045  2796
13 ENSG00000125384   1380  3079    869  2419
14 ENSG00000129562  12089  7958  10708  7683
15 ENSG00000129932   1744  2247   1513  3104
16 ENSG00000134198    122    66     44    16
17 ENSG00000135452    635   427    662   291
18 ENSG00000140416     83   246    136   267
19 ENSG00000147274  16013 17642  15055 18804
20 ENSG00000148090    552  1062    615  1082
21 ENSG00000148248  62324 33973  56862 37710
22 ENSG00000157036   1225  1475   1275  1373
23 ENSG00000157869   1201  1034   1025   858
24 ENSG00000159433     31   788     30   675
25 ENSG00000161692    695  1825    746  1851
26 ENSG00000167005  26866 23111  24888 22661
27 ENSG00000168517    273   112    190    77
28 ENSG00000169570    202   181    207   209
29 ENSG00000172216   3515  1981   3204  3174
30 ENSG00000175221   1988  4788   2115  5306
31 ENSG00000183161   2238   974   2089   996
32 ENSG00000185324   1236  2163   1048  2024
33 ENSG00000188985   3415  1703   3587  2096
34 ENSG00000196867    209   189    293   192
35 ENSG00000197081  14741 36309  14941 29645
36 ENSG00000198586   1216  4545   1660  3932
37 ENSG00000214121   4044  2575   3019  2506
38 ENSG00000225630   1405  8135   1569  7866
39 ENSG00000226742    158    94    153   178
40 ENSG00000238241     90    43    122   143
41 ENSG00000248751    518   718    411   597
42 ENSG00000250202    261   163    177   191
43 ENSG00000251106     94   114     63    86
44 ENSG00000253991     77    78    134    92
45 ENSG00000254470   3025  3707   2558  4066
46 ENSG00000262814  15470 11450  11656 13821
47 ENSG00000267228   3801  2465   2787  2301
48 ENSG00000267699   1488  1086   1374   939
49 ENSG00000269293    424   162    310   120
50 ENSG00000279329     55    76     58    70
```

## Affichage des premières lignes de l'objet


```r
head(exprs)
```

```
               id    WT1   WT2    KO1   KO2
1 ENSG00000034510 235960 94264 202381 91336
2 ENSG00000064201    116    71     64    56
3 ENSG00000065717    118   174    124   182
4 ENSG00000099958    450   655    301   472
5 ENSG00000104164   4736  5019   4845  4934
6 ENSG00000104783   9002  8623   7720  7142
```

## Un peu plus de lignes


```r
head(exprs, n = 15)
```

```
                id    WT1   WT2    KO1   KO2
1  ENSG00000034510 235960 94264 202381 91336
2  ENSG00000064201    116    71     64    56
3  ENSG00000065717    118   174    124   182
4  ENSG00000099958    450   655    301   472
5  ENSG00000104164   4736  5019   4845  4934
6  ENSG00000104783   9002  8623   7720  7142
7  ENSG00000105229   1295  2744   1113  2887
8  ENSG00000105723   3353  7449   3589  7202
9  ENSG00000116199   2044  4525   2604  4902
10 ENSG00000118939   7022  2526   6269  3068
11 ENSG00000119285  15783 17359  18591 20077
12 ENSG00000121680   3133  2775   2045  2796
13 ENSG00000125384   1380  3079    869  2419
14 ENSG00000129562  12089  7958  10708  7683
15 ENSG00000129932   1744  2247   1513  3104
```

## Caractéristiques d'un tableau

Dimensions


```r
dim(exprs)    ## Dimensions
ncol(exprs)   ## Nombre de colonnes
nrow(exprs)   ## Nombre de lignes
```

Noms des lignes et colonnes


```r
colnames(exprs)
rownames(exprs)
```


## Résumé rapide des données par colonne


```r
  summary(exprs)
```

```
               id          WT1              WT2               KO1                KO2         
 ENSG00000034510: 1   Min.   :    31   Min.   :   43.0   Min.   :    30.0   Min.   :   16.0  
 ENSG00000064201: 1   1st Qu.:   264   1st Qu.:  203.2   1st Qu.:   228.5   1st Qu.:  223.5  
 ENSG00000065717: 1   Median :  1338   Median : 1903.0   Median :  1324.5   Median : 2060.0  
 ENSG00000099958: 1   Mean   :  9358   Mean   : 6498.6   Mean   :  8356.0   Mean   : 6489.5  
 ENSG00000104164: 1   3rd Qu.:  3730   3rd Qu.: 4727.2   3rd Qu.:  3491.2   3rd Qu.: 4926.0  
 ENSG00000104783: 1   Max.   :235960   Max.   :94264.0   Max.   :202381.0   Max.   :91336.0  
 (Other)        :44                                                                          
```

## Sélection de colonnes d'un tableau

Valeurs stockées dans la colonne nommée "WT1"


```r
exprs$WT1
```

Notation alternative


```r
exprs[, "WT1"]  ## Sélection de la colonne WT1
```

Sélection de plusieurs colonnes. 


```r
exprs[, c("WT1", "WT2")]
```

Sélection de colonnes par leur indice


```r
exprs[, 2]
exprs[, c(2, 3)]
```

## Histogramme des valeurs d'expression pour WT1


```r
hist(exprs$WT1)
```

<img src="figures/07_tests_multiplesunnamed-chunk-26-1.png" width="60%" style="display: block; margin: auto;" />

## Histogramme du logarithme de ces valeurs


```r
hist(log(exprs$WT1))
```

<img src="figures/07_tests_multiplesunnamed-chunk-27-1.png" width="60%" style="display: block; margin: auto;" />

## Nuages de points -- Expressions KO1 vs WT1


```r
plot(x = log(exprs$WT1), y = log(exprs$KO1))
```

<img src="figures/07_tests_multiplesunnamed-chunk-28-1.png" width="60%" style="display: block; margin: auto;" />

## Personnalisation des paramètres graphiques


```r
plot(x = log(exprs$WT1),   ## données pour l’abscisse
     y = log(exprs$KO1),   ## données pour l’ordonnée
     main = "Expression KO1 vs WT1",  ## Titre principal
     xlab = "WT1",  ## légende de l’axe X
     ylab = "KO1",  ## légende de l’axe Y
     pch = 16,      ## caractère pour marquer les points
     las = 1,       ## écrire les échelles horizontalement
     col = "red")   ## couleur des points
grid()  ## Ajout d’une grille
abline(a = 0, b = 1)   ## Ajouter la droite X = Y (intercept a = 0, pente b = 1).
```

<img src="figures/07_tests_multiplesunnamed-chunk-29-1.png" width="60%" style="display: block; margin: auto;" />

## Sélection de lignes d'un tableau

Sélection des lignes 4 et 11 du tableau des expressions


```r
exprs[c(4, 11), ]
```

Indices des lignes correspondant aux IDs ENSG00000253991 et ENSG00000099958


```r
which(exprs$id %in% c("ENSG00000253991", "ENSG00000099958"))
```

Afficher les lignes correspondantes


```r
exprs[which(exprs$id %in% c("ENSG00000253991", "ENSG00000099958")), ]
```

## Calculs sur des colonnes

Calcul de moyennes par ligne (`rowMeans`) pour un sous-ensemble donné des colonnes (WT1 et WT2).


```r
rowMeans(exprs[,c("WT1","WT2")])
```

Ajout de colonnes avec les expressions moyennes des WT et des KO.
 

```r
exprs$meanWT <- rowMeans(exprs[,c("WT1","WT2")])
exprs$meanKO <- rowMeans(exprs[,c("KO1","KO2")])

head(exprs) ## Check the result
```

Fold-change KO vs WT


```r
exprs$FC <- exprs$meanKO / exprs$meanWT
head(exprs) ## Check the result
```

Moyenne de tous les échantillons


```r
exprs$mean <- rowMeans(exprs[,c("WT1","WT2","KO1","KO2")])
```

## MA-plot: log2FC vs intensité

$M$ est le logarithme en base 2 du rapport d'expression.

$$M = log_{2} (\text{FC}) = log_{2} \left( \frac{\text{KO}}{\text{WT}} \right) = log_2 (\text{KO}) - log_2(\text{WT})$$


```r
exprs$M <- log2(exprs$FC)
```

$A$ (average intensity) est la moyenne des logarithmes des valeurs d'expression.

$$A = \frac{1}{2} log_2 (\text{KO} \cdot \text{WT}) = \frac{1}{2} \left( log_2 (\text{KO}) + log_2(\text{WT}) \right)$$

```r
exprs$A <- rowMeans(log2(exprs[,c("meanWT", "meanKO")]))
```



## MA-plot: log2FC vs intensité


```r
plot(x = exprs$A, y = exprs$M, main = "MA plot", las = 1,
     col = "blue", pch = 16, xlab = "A = intensity", ylab = "M = log2FC")
grid(lty = "solid", col = "lightgray")
abline(h = 0)
```

<img src="figures/07_tests_multiplesunnamed-chunk-39-1.png" width="60%" style="display: block; margin: auto;" />

## Charger les annotations des gènes


```r
annot <- read.table(file = "annotation.csv", header = TRUE, sep = ";")
dim(annot)   ## Vérifier les dimensions
head(annot)  ## Afficher quelques lignes
```

Combien de gènes par chromosome ?


```r
table(annot$chr)
```

Question: combien de gènes sur le chromosome 8 ? Et sur le X ?


## Diagramme en bâtons -- gènes par chromosomes


```r
barplot(sort(table(annot$chr)), horiz = TRUE, las = 1,
        main = "Genes per chromosome", ylab = "Chromosome", 
        col = "lightblue", xlab = "Number of genes")
```

<img src="figures/07_tests_multiplesunnamed-chunk-42-1.png" width="40%" style="display: block; margin: auto;" />


## Sélectionner les données du chromosome 8

1ere étape: fusionner les deux tableaux exprs et annot


```r
exprs.annot <- merge(exprs, annot, by = "id")
head(exprs.annot)
```

2eme étape: sous-ensemble des lignes pour lesquelles chr vaut 8


```r
exprs8 <- exprs.annot[which(exprs.annot$chr == 8),]
print(exprs8)
```

## Exporter exprs8 dans un fichier


```r
write.table(x = exprs8, file = "exprs8.txt", sep = "\t",
            row.names = TRUE, col.names = NA)
```

## A ajouter: ALLER PLUS LOIN (optionnel)

- charger un tableau complet de données (RNA-seq ou ChIP-seq et refaire quelques plots)
- hist(breaks = 100)
- apply
- sort, order
- lm() ?

