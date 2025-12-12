#RCI_pLDDT plot 
df <- read.table("RCI_pLDDT_selectedModels.csv", sep=",", header=TRUE)

pLDDTAavg <- (df$a1_1.pdb+df$a1_2.pdb+df$a1_3.pdb+df$a1_4.pdb+df$a1_5.pdb)/500
pLDDTBavg <- (df$b2_1.pdb+df$b2_2.pdb+df$b2_3.pdb+df$b2_4.pdb+df$b2_5.pdb)/500

pLDDTavg <- (pLDDTAavg + pLDDTBavg)/2

pLDDT_0.5 <- replace(pLDDTavg, pLDDTavg <= 0.5, NA) # pLDDT > 0.5

summation0.5 <- c((pLDDT_0.5+df$RCI1/0.6)) # pLDDT > 0.5 
mD <- mean(summation0.5, na.rm=TRUE)
sdD <- sd(summation0.5, na.rm=TRUE)
SEM <- (sdD/sqrt(sum(!is.na(summation0.5))-1))

summation_allA <- c((pLDDTAavg+df$RCI1/0.6)) #total
summation_allB <- c((pLDDTBavg+df$RCI1/0.6)) #total

par(mfrow = c(2, 1)) 
par(mar=c(2,2,1,1))

plot(df$Number[1:55]+60, type="S", summation_all[1:55], col="blue", xlab="", ylab="", ylim=c(0.7,1.1),lwd=2, xaxt='n', xaxs="r", yaxs="r")
axis(side=1, at=c(60, 70, 80, 90, 100, 110, 120)) 

rect(62, 1.04, 81, 1.05, col="orange", border="NA") #helix1
rect(85, 1.04, 111, 1.05, col="orange", border="NA") #helix2


abline(h=mD, col="grey", lty=3, lwd=2)
abline(h=mD+12.71*SEM, col="grey", lty=3, lwd=2)
text(mD, "95%CI",adj = c(-9.8,-0.5))
abline(h=mD-12.71*SEM, col="grey", lty=3, lwd=2)

plot(df$Number[1:55]+60, df$RCI1[1:55]/0.6, type="o", col="black", xlab="Residue Number", ylab="Score", pch="o", lty=1, ylim=c(-0.1,1.1), xaxt='n', yaxt='n', xaxs="r", yaxs="r")
axis(side=1, at=c(60, 70, 80, 90, 100, 110, 120)) 
axis(side=2, at=c(0.10, 0.30, 0.50, 0.70, 0.90))

lines(df$Number[1:55]+60, df$a1_1.pdb[1:55]/100, col="blue", lty=2)
lines(df$Number[1:55]+60, df$a1_2.pdb[1:55]/100, col="blue", lty=2)
lines(df$Number[1:55]+60, df$a1_3.pdb[1:55]/100, col="blue", lty=2)
lines(df$Number[1:55]+60, df$a1_4.pdb[1:55]/100, col="blue", lty=2)
lines(df$Number[1:55]+60, df$a1_5.pdb[1:55]/100, col="blue", lty=2)
lines(df$Number[1:55]+60, pLDDTAavg[1:55], col="blue", lwd=2)

lines(df$Number[1:55]+60, df$b2_1.pdb[1:55]/100, col="green", lty=2)
lines(df$Number[1:55]+60, df$b2_2.pdb[1:55]/100, col="green", lty=2)
lines(df$Number[1:55]+60, df$b2_3.pdb[1:55]/100, col="green", lty=2)
lines(df$Number[1:55]+60, df$b2_4.pdb[1:55]/100, col="green", lty=2)
lines(df$Number[1:55]+60, df$b2_5.pdb[1:55]/100, col="green", lty=2)
lines(df$Number[1:55]+60, pLDDTBavg[1:55], col="green", lwd=2)

abline(h=0.5, col="grey", lty=4, lwd=1)
abline(h=0.7, col="grey", lty=4, lwd=1)
abline(h=0.9, col="grey", lty=4, lwd=1)

SCC_state1 <- cor(pLDDTAavg, df$RCI1, method = 'spearman', use="complete.obs")
SCC_state2 <- cor(pLDDTBavg, df$RCI1, method = 'spearman', use="complete.obs")


