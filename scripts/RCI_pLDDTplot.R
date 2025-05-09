#RCI_pLDDT plot 
df <- read.table("RCI_pLDDT_selectedModels.csv", sep=",", header=TRUE)

pLDDTavg <- (df$a1_1.pdb+df$a1_2.pdb+df$a1_3.pdb+df$a1_4.pdb+df$a1_5.pdb)/500

pLDDT_0.5 <- replace(pLDDTavg, pLDDTavg <= 0.5, NA) # pLDDT > 0.5

summation0.5 <- c((pLDDT_0.5+df$RCI/0.6)) # pLDDT > 0.5 
mD <- mean(summation0.5, na.rm=TRUE)
sdD <- sd(summation0.5, na.rm=TRUE)
SEM <- (sdD/sqrt(sum(!is.na(summation0.5))-1))

summation_all <- c((pLDDTavg+df$RCI/0.6)) #total

par(mfrow = c(2, 1)) 
par(mar=c(2,2,1,1))

plot(df$Number, type="S", summation_all, col="blue", xlab="", ylab="", ylim=c(0.6,1.4),lwd=2, xaxt='n', xaxs="r", yaxs="r")
axis(side=1, at=c(1,20, 40, 60, 80, 100, 120, 140, 160, 180)) 

abline(h=mD, col="grey", lty=3, lwd=2)
abline(h=mD+12.71*SEM, col="grey", lty=3, lwd=2)
text(mD, "95%CI",adj = c(-9.8,-0.5))
abline(h=mD-12.71*SEM, col="grey", lty=3, lwd=2)

plot(df$Number, df$RCI/0.6, type="o", col="black", xlab="Residue Number", ylab="Score", pch="o", lty=1, ylim=c(-0.1,1.1), xaxt='n', yaxt='n', xaxs="r", yaxs="r")
axis(side=1, at=c(1,20, 40, 60, 80, 100, 120, 140, 160, 180)) 
axis(side=2, at=c(0.10, 0.30, 0.50, 0.70, 0.90))

lines(df$Number, df$a1_1.pdb/100, col="blue", lty=2)
lines(df$Number, df$a1_2.pdb/100, col="blue", lty=2)
lines(df$Number, df$a1_3.pdb/100, col="blue", lty=2)
lines(df$Number, df$a1_4.pdb/100, col="blue", lty=2)
lines(df$Number, df$a1_5.pdb/100, col="blue", lty=2)
lines(df$Number, pLDDTavg, col="blue", lwd=2)

abline(h=0.5, col="grey", lty=4, lwd=1)
abline(h=0.7, col="grey", lty=4, lwd=1)
abline(h=0.9, col="grey", lty=4, lwd=1)

SCC0.5 <- cor(pLDDT_0.5, df$RCI, method = 'spearman', use="complete.obs")
SCC_FL <- cor(pLDDTavg, df$RCI, method = 'spearman', use="complete.obs")


