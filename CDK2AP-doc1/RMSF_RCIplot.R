library(bio3d)
setup.ncore(10)

#based on Talos 
l1 = seq(2,21)
l2 = seq(25,51)

coreIndex = c(l1, l2)

### start rmsf align 

#working directory: CDK2AP-doc1

a_affiles <- list.files("output/selectedModels/a1/", pattern=".pdb", full.names=TRUE)    
a_pdbs <- pdbaln(a_affiles, super5=TRUE, ncore=10)
a_pdbs.aa <- read.all(a_pdbs)
xyzA <- a_pdbs$xyz
ca.inds <- atom.select(a_pdbs, elety="CA", resno=coreIndex)
xyzA <- fit.xyz(xyzA[1, ], xyzA, fixed.inds=ca.inds$xyz,mobile.inds=ca.inds$xyz)
rA <- rmsf(xyzA)


b_affiles <- list.files("output/selectedModels/b2/", pattern=".pdb", full.names=TRUE)    
b_pdbs <- pdbaln(b_affiles, super5=TRUE, ncore=10)
b_pdbs.aa <- read.all(b_pdbs)
xyzB <- b_pdbs$xyz
ca.inds <- atom.select(b_pdbs, elety="CA", resno=coreIndex)
xyzB <- fit.xyz(xyzB[1, ], xyzB, fixed.inds=ca.inds$xyz,mobile.inds=ca.inds$xyz)
rB <- rmsf(xyzB)

#combine A/B
ab_pdbs <- pdbaln(c(a_affiles, b_affiles), super5=TRUE, ncore=10)
ab_pdbs.aa <- read.all(ab_pdbs)
xyzAB <- ab_pdbs$xyz
ca.inds <- atom.select(ab_pdbs, elety="CA", resno=coreIndex)
xyzAB <- fit.xyz(xyzAB[1, ], xyzAB, fixed.inds=ca.inds$xyz,mobile.inds=ca.inds$xyz)
rAB <- rmsf(xyzAB)


rci_df <- read.table("RCI1.csv", sep=",", header=TRUE)

library("epiR")
cccA <- epiR::epi.ccc(rci_df$RCI1[1:55]*12.7, rA[1:55], ci="z-transform", conf.level=0.95)
cccA$rho.c
#0.39

cccB <- epiR::epi.ccc(rci_df$RCI1[1:55]*12.7, rB[1:55], ci="z-transform", conf.level=0.95)
cccB$rho.c
#0.14

cccAB <- epiR::epi.ccc(rci_df$RCI1[1:55]*12.7, rAB[1:55], ci="z-transform", conf.level=0.95)
cccAB$rho.c
#0.70

par(mfrow = c(2, 1)) 
par(mar=c(2,2,1,1))

rci_rmsf = rci_df$RCI1*12.7 - rAB
rciA_rmsf = rci_df$RCI1*12.7 - rA 
rciB_rmsf = rci_df$RCI1*12.7 - rB

diff_ave <- (rci_rmsf[1:55]+rciA_rmsf[1:55]+rciB_rmsf[1:55])/3

mD <- mean(diff_ave, na.rm=TRUE)
sdD <- sd(diff_ave, na.rm=TRUE)
SEM <- (sdD/sqrt(sum(!is.na(diff_ave))-1))

par(mfrow = c(2, 1)) 
par(mar=c(2,2,1,1))

plot(rci_df$Number[1:55]+60, rciB_rmsf[1:55], type="S", col="green", xlab="", ylab="", lwd=2, xaxt='n', xaxs="r", yaxs="r", ylim=c(-0.5, 1))
axis(side=1, at=c(10, 20, 30,40, 50, 60, 70, 80, 90, 100, 110)) 

rect(62, 0.3, 81, 0.35, col="orange", border="NA") #helix
rect(85, 0.3, 111, 0.35, col="orange", border="NA") #helix

lines(rci_df$Number+60, rciA_rmsf, col="blue", type="s", lwd=2) # group a
lines(rci_df$Number+60, rci_rmsf, col="purple", type="s", lwd=2) # group a

abline(h=mD, col="grey", lty=3, lwd=2)
abline(h=mD+12.71*SEM, col="grey", lty=3, lwd=2)
text(mD, "95%CI",adj = c(20,0))
abline(h=mD-12.71*SEM, col="grey", lty=3, lwd=2)


plot(rci_df$Number[1:55]+60, rci_df$RCI[1:55]*12.7, type="o", col="black", xlab="Residue Number", ylab="Score", pch="o", lty=1, xaxt='n', xaxs="r",ylim=c(-0.03, 2))
axis(side=1, at=c(10,20,30,40,50,60,70, 80, 90, 100, 110)) 

lines(rci_df$Number[1:55]+60, rA[1:55], col="blue", lwd=2) # group a
lines(rci_df$Number[1:55]+60, rB[1:55], col="green", lwd=2) # group a

lines(rci_df$Number[1:55]+60, rAB[1:55], col="purple", lwd=2) # group a

rect(62, -0.05, 81, -0.01, col="gray", border="NA")
rect(85, -0.05, 111, -0.01, col="gray", border="NA")


