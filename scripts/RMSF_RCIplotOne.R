library(bio3d)
setup.ncore(10)

#working directory: 2kiw/full

rci_df <- read.table("RCI.csv", sep=",", header=TRUE)
coreIndex <- which(rci_df$RCI * 12.7 < 0.4)

### start rmsf align 

a_affiles <- list.files("selectedModels/a1/", pattern=".pdb", full.names=TRUE)    
a_pdbs <- pdbaln(a_affiles, super5=TRUE, ncore=10)
a_pdbs.aa <- read.all(a_pdbs)
xyzA <- a_pdbs$xyz

ca.inds <- atom.select(a_pdbs, elety="CA", resno=coreIndex)
xyzA <- fit.xyz(xyzA[1, ], xyzA, fixed.inds=ca.inds$xyz,mobile.inds=ca.inds$xyz)
rA <- rmsf(xyzA)


library("epiR")
cccA <- epiR::epi.ccc(rci_df$RCI*12.7, rA[1:103], ci="z-transform", conf.level=0.95)
cccA$rho.c
#> cccA$rho.c
#est     lower     upper
#1 0.9484497 0.9251188 0.9646448

rciA_rmsf = rci_df$RCI*12.7 - rA[1:103] 

diff_ave <- rciA_rmsf

mD <- mean(diff_ave, na.rm=TRUE)
sdD <- sd(diff_ave, na.rm=TRUE)
SEM <- (sdD/sqrt(sum(!is.na(diff_ave))-1))

par(mfrow = c(2, 1)) 
par(mar=c(2,2,1,1))

plot(rci_df$Number, rciA_rmsf, type="S", col="blue", xlab="", ylab="", lwd=2, xaxt='n', xaxs="r", yaxs="r", ylim=c(-2, 1))
axis(side=1, at=c(10, 20, 30,40, 50, 60, 70, 80, 90, 100, 110)) 

abline(h=mD, col="grey", lty=3, lwd=2)
abline(h=mD+12.71*SEM, col="grey", lty=3, lwd=2)
text(mD, "95%CI",adj = c(20,0))
abline(h=mD-12.71*SEM, col="grey", lty=3, lwd=2)


plot(rci_df$Number, rci_df$RCI*12.7, type="o", col="black", xlab="Residue Number", ylab="Score", pch="o", lty=1, xaxt='n', xaxs="r",ylim=c(-0.03, 5))
axis(side=1, at=c(10,20,30,40,50,60,70, 80, 90, 100, 110)) 

lines(rci_df$Number, rA[1:103], col="blue", lwd=2) # group a
abline(h=0.4, col="grey", lty=3, lwd=2)


