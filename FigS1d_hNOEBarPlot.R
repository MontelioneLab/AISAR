dfhNOE <- read.table("RCI_hetNOE.csv", sep=",", header=TRUE)

par(mfrow = c(1, 1)) 
par(mar=c(2,2,1,1))

barplot(dfhNOE$hetNOE-0.5, width=0.84, border = NA, col="black", pch="o", xlab="Residue Number", ylab="hetNOE", ylim=c(-1.5,1), lty=1, yaxt='n', xaxs="r", yaxs="r")
axis(side=2, at=c(-1.5, -1.0, -0.5, 0, 0.5), labels = c(-1.0, -0.5, 0, 0.5, 1.0))
axis(side=1, at=c(1,20, 40, 60, 80, 100, 120, 140, 160, 180)) 
abline(h=0, col="black", lty=1, lwd=1)

