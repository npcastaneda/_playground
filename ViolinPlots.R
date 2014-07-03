# Creating violin plots
# source: http://mbjoseph.github.io/blog/2013/06/24/violin/

# Simulate data
n.each <- 1000
A1 <- rnorm(n.each, 2, 1)
A2 <- rnorm(n.each, 1.5, 2)
B1 <- rnorm(n.each, 4, 1.5)
B2 <- rnorm(n.each, 0, 1)
values <- c(A1, A2, B1, B2)
treatment <- rep(c("A", "B"), each=n.each*2)
group <- rep(c(1, 2, 1, 2), each=n.each)

# Drawing bloxplots
par(bty="n")
boxplot(values ~ group*treatment, main="Box plot", col=rep(c("purple", "lightblue"), 2))

require(vioplot)
require(devtools)
require(digest)
source_gist("https://gist.github.com/mbjoseph/5852613")
plot(x=NULL, y=NULL,
     xlim = c(0.5, 2.5), ylim=c(min(values), max(values)),
     type="n", ann=FALSE, axes=F)
axis(1, at=c(1, 2),  labels=c("A", "B"))
axis(2)
for (i in unique(treatment)) {
  for (j in unique(group)){
    vioplot2(values[which(treatment == i & group == j)],
             at = ifelse(i == "A", 1, 2),
             side = ifelse(j == 1, "left", "right"),
             col = ifelse(j == 1, "purple", "lightblue"),
             add = T)
  }
}
title("Violin plot", xlab="Treatment")
legend("bottomright", fill = c("purple", "lightblue"),
       legend = c("Group 1", "Group 2"), box.lty=0)


###############################################
# Vioplot function
###############################################


vioplot2 <- function (x, ..., range = 1.5, h = NULL, ylim = NULL, names = NULL,
                      horizontal = FALSE, col = "magenta", border = "black", lty = 1,
                      lwd = 1, rectCol = "black", colMed = "white", pchMed = 19,
                      at, add = FALSE, wex = 1, drawRect = TRUE, side="both")
{
  datas <- list(x, ...)
  n <- length(datas)
  if (missing(at))
    at <- 1:n
  upper <- vector(mode = "numeric", length = n)
  lower <- vector(mode = "numeric", length = n)
  q1 <- vector(mode = "numeric", length = n)
  q2 <- vector(mode = "numeric", length = n)
  q3 <- vector(mode = "numeric", length = n)
  med <- vector(mode = "numeric", length = n)
  base <- vector(mode = "list", length = n)
  height <- vector(mode = "list", length = n)
  baserange <- c(Inf, -Inf)
  args <- list(display = "none")
  radj <- ifelse(side == "right", 0, 1)
  ladj <- ifelse(side == "left", 0, 1)
  if (!(is.null(h)))
    args <- c(args, h = h)
  med.dens <- rep(NA, n)
  for (i in 1:n) {
    data <- datas[[i]]
    data.min <- min(data)
    data.max <- max(data)
    q1[i] <- quantile(data, 0.25)
    q2[i] <- quantile(data, 0.5)
    q3[i] <- quantile(data, 0.75)
    med[i] <- median(data)
    iqd <- q3[i] - q1[i]
    upper[i] <- min(q3[i] + range * iqd, data.max)
    lower[i] <- max(q1[i] - range * iqd, data.min)
    est.xlim <- c(min(lower[i], data.min), max(upper[i],
                                               data.max))
    smout <- do.call("sm.density", c(list(data, xlim = est.xlim),
                                     args))
    med.dat <- do.call("sm.density",
                       c(list(data, xlim=est.xlim,
                              eval.points=med[i], display = "none")))
    med.dens[i] <- med.dat$estimate
    hscale <- 0.4/max(smout$estimate) * wex
    base[[i]] <- smout$eval.points
    height[[i]] <- smout$estimate * hscale
    med.dens[i] <- med.dens[i] * hscale
    t <- range(base[[i]])
    baserange[1] <- min(baserange[1], t[1])
    baserange[2] <- max(baserange[2], t[2])
  }
  if (!add) {
    xlim <- if (n == 1)
      at + c(-0.5, 0.5)
    else range(at) + min(diff(at))/2 * c(-1, 1)
    if (is.null(ylim)) {
      ylim <- baserange
    }
  }
  if (is.null(names)) {
    label <- 1:n
  }
  else {
    label <- names
  }
  boxwidth <- 0.05 * wex
  if (!add)
    plot.new()
  if (!horizontal) {
    if (!add) {
      plot.window(xlim = xlim, ylim = ylim)
      axis(2)
      axis(1, at = at, label = label)
    }
    box()
    for (i in 1:n) {
      polygon(x = c(at[i] - radj*height[[i]], rev(at[i] + ladj*height[[i]])),
              y = c(base[[i]], rev(base[[i]])),
              col = col, border = border,
              lty = lty, lwd = lwd)
      if (drawRect) {
        lines(at[c(i, i)], c(lower[i], upper[i]), lwd = lwd,
              lty = lty)
        rect(at[i] - radj*boxwidth/2,
             q1[i],
             at[i] + ladj*boxwidth/2,
             q3[i], col = rectCol)
        # median line segment
        lines(x = c(at[i] - radj*med.dens[i],
                    at[i],
                    at[i] + ladj*med.dens[i]),
              y = rep(med[i],3))
      }
    }
  }
  else {
    if (!add) {
      plot.window(xlim = ylim, ylim = xlim)
      axis(1)
      axis(2, at = at, label = label)
    }
    box()
    for (i in 1:n) {
      polygon(c(base[[i]], rev(base[[i]])),
              c(at[i] - radj*height[[i]], rev(at[i] + ladj*height[[i]])),
              col = col, border = border,
              lty = lty, lwd = lwd)
      if (drawRect) {
        lines(c(lower[i], upper[i]), at[c(i, i)], lwd = lwd,
              lty = lty)
        rect(q1[i], at[i] - radj*boxwidth/2, q3[i], at[i] +
               ladj*boxwidth/2, col = rectCol)
        lines(y = c(at[i] - radj*med.dens[i],
                    at[i],
                    at[i] + ladj*med.dens[i]),
              x = rep(med[i],3))
      }
    }
  }
  invisible(list(upper = upper, lower = lower, median = med,
                 q1 = q1, q3 = q3))
}