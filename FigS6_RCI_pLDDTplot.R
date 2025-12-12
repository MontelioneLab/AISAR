#RCI_pLDDT plot 

df <- read.table("RCI_pLDDT_selectedModels.csv", sep=",", header=TRUE)
dfcolab <- read.table("colabpLDDT.txt", sep="", header=TRUE) 

pLDDTAavg <- (df$a5_1.pdb+df$a5_2.pdb+df$a5_3.pdb+df$a5_4.pdb+df$a5_5.pdb)/500
pLDDTBavg <- (df$b3_1.pdb+df$b3_2.pdb+df$b3_3.pdb+df$b3_4.pdb+df$b3_5.pdb)/500
pLDDTColabavg <- (dfcolab$rank_001.pdb+dfcolab$rank_002.pdb+dfcolab$rank_003.pdb+dfcolab$rank_004.pdb+dfcolab$rank_005.pdb)/500

pLDDTavg <- (pLDDTAavg+pLDDTBavg+pLDDTColabavg)/3

pLDDT_0.5 <- replace(pLDDTavg, pLDDTavg <= 0.5, NA) # pLDDT > 0.5

summation0.5 <- c((pLDDT_0.5+df$RCI/0.6)) # pLDDT > 0.5 
mD <- mean(summation0.5, na.rm=TRUE)
sdD <- sd(summation0.5, na.rm=TRUE)
SEM <- (sdD/sqrt(sum(!is.na(summation0.5))-1))

summation_A <- c((pLDDTAavg+df$RCI/0.6)) #total
summation_B <- c((pLDDTBavg+df$RCI/0.6)) #total
summation_colab <- c((pLDDTColabavg+df$RCI/0.6)) #total

par(mfrow = c(2, 1)) 
par(mar=c(2,2,1,1))

plot(dfcolab$Number, type="S", summation_colab, col="magenta", xlab="", ylab="", ylim=c(0.35,1.6), xlim=c(1,170), lwd=2, xaxt='n', xaxs="r", yaxs="r")
axis(side=1, at=c(1,20, 40, 60, 80, 100, 120, 140, 160, 180)) 
lines(df$Number, type="S", summation_B, col="green", lwd=2)
lines(df$Number, type="S", summation_A, col="blue", lwd=2)

rect(10, 1.04, 18, 1.09, col="cyan", border="NA")
rect(23, 1.04, 28, 1.09, col="lightblue", angle=90, density=20)
rect(36, 1.04, 51, 1.09, col="gray", border="NA")
rect(53, 1.04, 62, 1.09, col="gray", border="NA")
rect(66, 1.04, 73, 1.09, col="gray", border="NA")
rect(102, 1.04, 107, 1.09, col="gray", border="NA")
rect(108, 1.04, 120, 1.09, col="gray", border="NA")
rect(124, 1.04, 133, 1.09, col="gray", border="NA")
rect(137, 1.04, 144, 1.09, col="gray", border="NA")

rect(146, 1.04, 154, 1.09, col="red", angle=90, density=20)
rect(159, 1.04, 162, 1.09, col="red", angle=90, density=20)

abline(h=mD, col="grey", lty=3, lwd=2)
abline(h=mD+12.71*SEM, col="grey", lty=3, lwd=2)
text(mD, "95% CI",adj = c(0.5,-1.15))
abline(h=mD-12.71*SEM, col="grey", lty=3, lwd=2)

plot(dfcolab$Number, df$RCI/0.6, type="o", col="black", xlab="Residue Number", ylab="Score", pch="o", lty=1, ylim=c(-0.1,1.1), xlim=c(1,170), xaxt='n', yaxt='n', xaxs="r", yaxs="r")
axis(side=1, at=c(1,20, 40, 60, 80, 100, 120, 140, 160, 180)) 
axis(side=2, at=c(0.10, 0.30, 0.50, 0.70, 0.90))

lines(df$Number, df$a5_1.pdb/100, col="blue", lty=2)
lines(df$Number, df$a5_2.pdb/100, col="blue", lty=2)
lines(df$Number, df$a5_3.pdb/100, col="blue", lty=2)
lines(df$Number, df$a5_4.pdb/100, col="blue", lty=2)
lines(df$Number, df$a5_5.pdb/100, col="blue", lty=2)
lines(df$Number, pLDDTAavg, col="blue", lwd=2)

lines(df$Number, df$b3_1.pdb/100, col="green", lty=2)
lines(df$Number, df$b3_2.pdb/100, col="green", lty=2)
lines(df$Number, df$b3_3.pdb/100, col="green", lty=2)
lines(df$Number, df$b3_4.pdb/100, col="green", lty=2)
lines(df$Number, df$b3_5.pdb/100, col="green", lty=2)
lines(df$Number, pLDDTBavg, col="green", lwd=2)

lines(df$Number, dfcolab$rank_001.pdb/100, col="magenta", lty=2)
lines(df$Number, dfcolab$rank_002.pdb/100, col="magenta", lty=2)
lines(df$Number, dfcolab$rank_003.pdb/100, col="magenta", lty=2)
lines(df$Number, dfcolab$rank_004.pdb/100, col="magenta", lty=2)
lines(df$Number, dfcolab$rank_005.pdb/100, col="magenta", lty=2)
lines(df$Number, pLDDTavg_colab, col="magenta", lwd=2)

abline(h=0.5, col="grey", lty=4, lwd=1)
abline(h=0.7, col="grey", lty=4, lwd=1)
abline(h=0.9, col="grey", lty=4, lwd=1)

rect(1, -0.05, 9, -0.09, col="blue", border="NA")
rect(10, -0.05, 18, -0.09, col="cyan", border="NA")
rect(19, -0.05, 34, -0.09, col="light blue", border="NA")
rect(35, -0.05, 78, -0.09, col="grey", border="NA")
rect(79, -0.05, 101, -0.09, col="green", border="NA")
rect(102, -0.05, 144, -0.09, col="grey", border="NA")
rect(145, -0.05, 168, -0.09, col="red", border="NA")


