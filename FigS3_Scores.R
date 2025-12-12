library(bio3d)
setup.ncore(10)

library(RColorBrewer)

map2color<-function(x,pal,limits=NULL){
  if(is.null(limits)) limits=range(x)
  print(limits)
  pal[findInterval(x,seq(limits[1],limits[2],length.out=length(pal)+1), all.inside = TRUE)]
}

df<-read.table("scores.all", header=TRUE)

# Define a 3x6 layout
par(mfrow=c(3,6))
par(mar=c(4,4,2,0.5))

###pTM 
df2=df[order(df$pTM), ] #color by the score
mycol<-map2color(df2$pTM,brewer.pal(10, "Spectral"))

#layout(matrix(c(1,2), ncol=2), widths=c(4, 1))
par(fig = c(0, 0.26, 0.67, 1.0))  # Position inside subplot
par(mar=c(4,4,2,0.5))
plot(df2$PCA1, df2$PCA2, mgp=c(2,1,0), main = "pTM", pch=20, cex=df2$pTM*df2$pTM*2, xlab="PC1", ylab="PC2", col=mycol) 

par(fig = c(0.26, 0.27, 0.75, 1.0), new=TRUE)  # Position inside subplot
par(mar = c(0, 0, 2, 0))

score <- seq(min(df2$pTM),max(df2$pTM),length.out=11)
image(1, 1:10, t(matrix(1:10)), col = brewer.pal(10, "Spectral"), axes = FALSE)

axis(4, at = 0.5:10.5, labels = round(score, 3), las = 1)


###Recall  
df2=df[order(df$Recall), ] #color by the score
mycol<-map2color(df2$Recall,brewer.pal(10, "Spectral"))

par(fig = c(0.33, 0.59, 0.67, 1.0), new=TRUE)  # Position inside subplot
par(mar=c(4,4,2,0.5))
plot(df2$PCA1, df2$PCA2, mgp=c(2,1,0), main="Recall", pch=20, cex=df2$pTM*df2$pTM*2, xlab="PC1", ylab="PC2", col=mycol) 

par(fig = c(0.59, 0.60, 0.75, 1.0), new=TRUE)  # Position inside subplot
par(mar = c(0, 0, 2, 0))

score <- seq(min(df2$Recall),max(df2$Recall),length.out=11)
image(1, 1:10, t(matrix(1:10)), col = brewer.pal(10, "Spectral"), axes = FALSE)
axis(4, at = 0.5:10.5, labels = round(score, 3), las = 1)


###Recall*pTM  
df2=df[order(sqrt(df$pTM*(df$Recall-min(df$Recall))/(max(df$Recall)-min(df$Recall)))), ] #color by the score

pNOE = sqrt((df2$Recall-min(df$Recall))/(max(df$Recall)-min(df$Recall))*df2$pTM)

mycol<-map2color(pNOE, brewer.pal(10, "Spectral"))

par(fig = c(0.66, 0.92, 0.67, 1.0), new=TRUE)  # Position inside subplot
par(mar=c(4,4,2,0.5))
plot(df2$PCA1, df2$PCA2, mgp=c(2,1,0), main="pNOE", pch=20, cex=df2$pTM*df2$pTM*2, xlab="PC1", ylab="PC2", col=mycol) 

par(fig = c(0.92, 0.93, 0.75, 1.0), new=TRUE)  # Position inside subplot
par(mar = c(0, 0, 2, 0))

score <- seq(min(pNOE),max(pNOE),length.out=11)
image(1, 1:10, t(matrix(1:10)), col = brewer.pal(10, "Spectral"), axes = FALSE)
axis(4, at = 0.5:10.5, labels = round(score, 2), las = 1)

###pLDDT 
df2=df[order(df$pLDDT), ] #color by the score
mycol<-map2color(df2$pLDDT,brewer.pal(10, "Spectral"))

par(fig = c(0, 0.26, 0.34, 0.67), new=TRUE)  # Position inside subplot
par(mar=c(4,4,2,0.5))
plot(df2$PCA1, df2$PCA2, mgp=c(2,1,0), main="<pLDDT>", pch=20, cex=df2$pTM*df2$pTM*2, xlab="PC1", ylab="PC2", col=mycol) 

par(fig = c(0.26, 0.27, 0.42, 0.67), new=TRUE)  # Position inside subplot
par(mar = c(0, 0, 2, 0))

score <- seq(min(df2$pLDDT),max(df2$pLDDT),length.out=11)
image(1, 1:10, t(matrix(1:10)), col = brewer.pal(10, "Spectral"), axes = FALSE)

axis(4, at = 0.5:10.5, labels = round(score, 3), las = 1)


###SCC

df$SCC[df$SCC > 0] <- 0

df2=df[order(df$SCC*-1), ] #color by the score
mycol<-map2color(df2$SCC*-1,brewer.pal(10, "Spectral"))

par(fig = c(0.33, 0.59, 0.34, 0.67), new=TRUE)  # Position inside subplot
par(mar=c(4,4,2,0.5))
plot(df2$PCA1, df2$PCA2, mgp=c(2,1,0), main="|SCC|", pch=20, cex=df2$pTM*df2$pTM*2, xlab="PC1", ylab="PC2", col=mycol) 

par(fig = c(0.59, 0.60, 0.42, 0.67), new=TRUE)  # Position inside subplot
par(mar = c(0, 0, 2, 0))

score <- seq(min(df2$SCC*-1),max(df2$SCC*-1),length.out=11)
image(1, 1:10, t(matrix(1:10)), col = brewer.pal(10, "Spectral"), axes = FALSE)
axis(4, at = 0.5:10.5, labels = round(score, 2), las = 1)

###pLDDt*SCC

df2 <- df[order(sqrt(df$pLDDT/100 * df$SCC * -1)), ]  # Sort by the transformed score
pRCI <- sqrt(df2$pLDDT/100 * df2$SCC*-1)
mycol<-map2color(pRCI,brewer.pal(10, "Spectral"))

par(fig = c(0.66, 0.92, 0.34, 0.67), new=TRUE)  # Position inside subplot
par(mar=c(4,4,2,0.5))

plot(df2$PCA1, df2$PCA2, mgp=c(2,1,0), pch=20, main="pRCI", cex=df2$pTM*df2$pTM*2, xlab="PC1", ylab="PC2", col=mycol) 

par(fig = c(0.92, 0.93, 0.42, 0.67), new=TRUE)  # Position inside subplot
par(mar = c(0, 0, 2, 0))

score <- seq(min(pRCI),max(pRCI),length.out=11)
image(1, 1:10, t(matrix(1:10)), col = brewer.pal(10, "Spectral"), axes = FALSE)
axis(4, at = 0.5:10.5, labels = round(score, 2), las = 1)


### overall

df2 <- df[order(sqrt(df$pTM*(df$Recall-min(df$Recall))/(max(df$Recall)-min(df$Recall))) + sqrt(df$pLDDT*df$SCC/100*-1)), ] #color by the score

pNOE <-sqrt((df2$Recall-min(df2$Recall))/(max(df2$Recall)-min(df2$Recall))*df2$pTM)
pRCI <- sqrt(df2$pLDDT/100 * df2$SCC*-1)

pNMR <- (pNOE+pRCI)/2
mycol<-map2color(pNMR,brewer.pal(10, "Spectral"))

par(fig = c(0, 0.26, 0, 0.34), new=TRUE)  # Position inside subplot
par(mar=c(4,4,2,0.5))

plot(df2$PCA1, df2$PCA2, mgp=c(2,1,0), main="pNMR", pch=20, cex=df2$pTM*df2$pTM*2, xlab="PC1", ylab="PC2", col=mycol) 

par(fig = c(0.26, 0.27, 0.08, 0.34), new=TRUE)  # Position inside subplot
par(mar = c(0, 0, 2, 0))

score <- seq(min(pNMR),max(pNMR),length.out=11)
image(1, 1:10, t(matrix(1:10)), col = brewer.pal(10, "Spectral"), axes = FALSE)
axis(4, at = 0.5:10.5, labels = round(score, 2), las = 1)

### F-score 

df$F <- 2*df$Recall*df$Precision/(df$Recall+df$Precision)

df2 <- df[order(df$F), ] #color by the score

mycol<-map2color(df2$F,brewer.pal(10, "Spectral"))

par(fig = c(0.33, 0.59, 0, 0.34), new=TRUE)  # Position inside subplot
par(mar=c(4,4,2,0.5))
plot(df2$PCA1, df2$PCA2, mgp=c(2,1,0), main="F-score", pch=20, cex=df2$pTM*df2$pTM*2, xlab="PC1", ylab="PC2", col=mycol) 

par(fig = c(0.59, 0.60, 0.08, 0.34), new=TRUE)  # Position inside subplot
par(mar = c(0, 0, 2, 0))

score <- seq(min(pF),max(pF),length.out=11)
image(1, 1:10, t(matrix(1:10)), col = brewer.pal(10, "Spectral"), axes = FALSE)
axis(4, at = 0.5:10.5, labels = round(score, 2), las = 1)

###pNMR-F
df2=df[order(sqrt((df$F-min(df$F))/(max(df$F)-min(df$F))*df$pTM) + sqrt(df$pLDDT*df$SCC/100*-1)), ] #color by the score

pNMR2 <- (sqrt((df2$F-min(df2$F))/(max(df2$F)-min(df2$F))*df2$pTM) + sqrt(df2$pLDDT*df2$SCC/100*-1))/2
mycol<-map2color(pNMR2,brewer.pal(10, "Spectral"))

par(fig = c(0.66, 0.92, 0, 0.34), new=TRUE)  # Position inside subplot
par(mar=c(4,4,2,0.5))

plot(df2$PCA1, df2$PCA2, mgp=c(2,1,0), pch=20, main="pNMR-F", cex=df2$pTM*df2$pTM*2, xlab="PC1", ylab="PC2", col=mycol) 

par(fig = c(0.92, 0.93, 0.08, 0.34), new=TRUE)  # Position inside subplot
par(mar = c(0, 0, 2, 0))

score <- seq(min(pNMR2),max(pNMR2),length.out=11)
image(1, 1:10, t(matrix(1:10)), col = brewer.pal(10, "Spectral"), axes = FALSE)
axis(4, at = 0.5:10.5, labels = round(score, 2), las = 1)

