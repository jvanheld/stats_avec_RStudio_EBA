## ----setup, include=FALSE, size="huge"-----------------------------------
library(knitr)
## Default parameters for displaying the slides
knitr::opts_chunk$set(echo = TRUE, eval=TRUE, fig.width = 7, fig.height = 5, fig.align = "center", size = "tiny", warning = FALSE, results = TRUE, message = FALSE, comment = "")

## ------------------------------------------------------------------------
2 + 5

## ------------------------------------------------------------------------
a <- 2
print(a)

## ------------------------------------------------------------------------
b <- 5
c <- a + b
print(c)

## ------------------------------------------------------------------------
a <- 3 ## Change the value of a
print(c) ## Print the value of c

## Check whether c equals a + b
c == a + b

## ------------------------------------------------------------------------
a <- 27 ## Change the value of a
c <- a + b
print(c) ## Print the value of c

## Check whether c  equals a + b
c == a + b

## ------------------------------------------------------------------------
three.numbers <- c(27,12,3000)
print(three.numbers)

## ------------------------------------------------------------------------
x <- 0:14
print(x)

## ------------------------------------------------------------------------
x <- 1:10 # Define a series from 1 to 10
print(x)
y <- x^2 # Compute the square of each number
print(y)

## ----scatter_plot, fig.path="figures/", fig.width=7, fig.height=5, fig.align="center"----
x <- -10:10
y <- x^2
plot(x,y)

## ----line_plot, fig.path="figures/", fig.width=7, fig.height=5, fig.align="center"----
x <- -10:10
y <- x^2
plot(x,y, type="l")

## ------------------------------------------------------------------------
# The # symbol allows to insert comments in R code

# Define  a vector named "whoami", and 
# containing two names
whoami <- c("Denis", "Siméon")
print(whoami) # Comment at the end of a line

## ------------------------------------------------------------------------
# Define  a vector named "names", and 
# containing two names
whoami <- c("Denis", "Siméon")

# Paste the values of a vector of string 
print(paste(sep=" ", whoami[1], whoami[2]))

## ----eval=FALSE----------------------------------------------------------
## x <- 0:14   # Define the X values from 0 to 14
## y <- dpois(x, lambda = 2.5) # Poisson density
## print(y) # Check the result

## ----dpois_plot, fig.path="figures/", fig.width=7, fig.height=4, fig.align="center"----
x <- 0:14   # Define the X values from 0 to 14
y <- dpois(x, lambda = 2.5) # Poisson density
plot(x,y) # Check the result

## ------------------------------------------------------------------------
help(plot)

## ------------------------------------------------------------------------
?plot

## ----dpois_plot_h, fig.path="figures/", fig.width=7, fig.height=4, fig.align="center"----
x <- 0:14
lambda <- 2.54
y <- dpois(x, lambda)
plot(x,y, type="h")

## ----dpois_plot_h_main, fig.path="figures/", fig.width=7, fig.height=4, fig.align="center"----
plot(x,y, type="h", lwd=5, col="blue",
     main="Poisson density")

## ----dpois_plot_h_xylab, fig.path="figures/", fig.width=7, fig.height=4, fig.align="center"----
plot(x,y, type="h", lwd=5, col="blue",
     main="Poisson density",
     xlab="x = number of successes",
     ylab="P(X=x)")

## ----dpois_plot_h_legend, fig.path="figures/", fig.width=7, fig.height=4, fig.align="center"----
plot(x,y, type="h", lwd=5, col="blue",
     main="Poisson density",
     xlab="x = number of successes",
     ylab="P(X=x)")
legend("topright", paste("lambda =", lambda))

## ----dpois_series_lambda0_01, fig.path="figures/", fig.width=7, fig.height=4, fig.align="center"----
lambda <- 0.01
x <- 0:20
plot(x, dpois(x,lambda=lambda), type="h",   
     col="darkblue", lwd=5, xlab="X",ylab="dpois(x)")
legend("topright", paste("lambda=",lambda))

## ----dpois_series_lambda0_1, fig.path="figures/", fig.width=7, fig.height=4, fig.align="center"----
lambda <- 0.1
x <- 0:20
plot(x, dpois(x,lambda=lambda), type="h",   
     col="darkblue", lwd=5, xlab="X",ylab="dpois(x)")
legend("topright", paste("lambda=",lambda))

## ----dpois_series_lambda1, fig.path="figures/", fig.width=7, fig.height=4, fig.align="center"----
lambda <- 1
x <- 0:20
plot(x, dpois(x,lambda=lambda), type="h",   
     col="darkblue", lwd=5, xlab="X",ylab="dpois(x)")
legend("topright", paste("lambda=",lambda))

## ----dpois_series_lambda2, fig.path="figures/", fig.width=7, fig.height=4, fig.align="center"----
lambda <- 2
x <- 0:20
plot(x, dpois(x,lambda=lambda), type="h",   
     col="darkblue", lwd=5, xlab="X",ylab="dpois(x)")
legend("topright", paste("lambda=",lambda))

## ----dpois_series_lambda5, fig.path="figures/", fig.width=7, fig.height=4, fig.align="center"----
lambda <- 5
x <- 0:20
plot(x, dpois(x,lambda=lambda), type="h",   
     col="darkblue", lwd=5, xlab="X",ylab="dpois(x)")
legend("topright", paste("lambda=",lambda))

## ----dpois_series_lambda5_range40, fig.path="figures/", fig.width=7, fig.height=4, fig.align="center"----
lambda <- 5
x <- 0:40
plot(x, dpois(x,lambda=lambda), type="h",   
     col="darkblue", lwd=5, xlab="X",ylab="dpois(x)")
legend("topright", paste("lambda=",lambda))

## ----dpois_series_lambda10, fig.path="figures/", fig.width=7, fig.height=4, fig.align="center"----
lambda <- 10
x <- 0:(4*lambda)
plot(x, dpois(x,lambda=lambda), type="h",   
     col="darkblue", lwd=5, xlab="X",ylab="dpois(x)")
legend("topright", paste("lambda=",lambda))

## ----dpois_series_lambda20, fig.path="figures/", fig.width=7, fig.height=4, fig.align="center"----
lambda <- 20
x <- 0:(4*lambda)
plot(x, dpois(x,lambda=lambda), type="h",   
     col="darkblue", lwd=2, xlab="X",ylab="dpois(x)")
legend("topright", paste("lambda=",lambda))

## ----dpois_series_lambda30, fig.path="figures/", fig.width=7, fig.height=4, fig.align="center"----
lambda <- 30
x <- 0:(2*lambda)
plot(x, dpois(x,lambda=lambda), type="h",   
     col="darkblue", lwd=2, xlab="X",ylab="dpois(x)")
legend("topright", paste("lambda=",lambda))

## ----dpois_series_lambda50, fig.path="figures/", fig.width=7, fig.height=4, fig.align="center"----
lambda <- 50
x <- 0:(2*lambda)
plot(x, dpois(x,lambda=lambda), type="h",   
     col="darkblue", lwd=2, xlab="X",ylab="dpois(x)")
legend("topright", paste("lambda=",lambda))

## ----dpois_series_lambda100, fig.path="figures/", fig.width=7, fig.height=4, fig.align="center"----
lambda <- 100
x <- 0:(2*lambda)
plot(x, dpois(x,lambda=lambda), type="h",   
     col="darkblue", lwd=2, xlab="X",ylab="dpois(x)")
legend("topright", paste("lambda=",lambda))

## ----dpois_series_lambda1000, fig.path="figures/", fig.width=7, fig.height=4, fig.align="center"----
lambda <- 1000
x <- 0:(2*lambda)
plot(x, dpois(x,lambda=lambda), type="h",   
     col="darkblue", lwd=2, xlab="X",ylab="dpois(x)")
legend("topright", paste("lambda=",lambda))

## ----dpois_series_lambda10000, fig.path="figures/", fig.width=7, fig.height=4, fig.align="center"----
lambda <- 10000
x <- 0:(2*lambda)
plot(x, dpois(x,lambda=lambda), type="h",   
     col="darkblue", lwd=2, xlab="X",ylab="dpois(x)")
legend("topright", paste("lambda=",lambda))

## ----dpois_series_lambda10000_rescaled, fig.path="figures/", fig.width=7, fig.height=4, fig.align="center"----
plot(95000:105000, dpois(95000:105000,lambda=100000), type="h", col="darkblue", xlab="X",ylab="dpois(x)")

## ------------------------------------------------------------------------
sessionInfo()

