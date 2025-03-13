library(bio3d)
setup.ncore(10)

#based on Talos 
l1 = seq(2,21)
l2 = seq(25,51)

coreIndex = c(l1, l2)

### start rmsf align 

#working directory: scores 

a_affiles <- list.files("../selectedModels/a1/", pattern=".pdb", full.names=TRUE)    #afsample, nmr, colab
a_pdbfiles <-pdbsplit(a_affiles, ncore=10)
a_pdbs <- pdbaln(a_pdbfiles, super5=TRUE, ncore=10)
a_pdbs.aa <- read.all(a_pdbs)
xyzA <- a_pdbs$xyz
ca.inds <- atom.select(a_pdbs, elety="CA", resno=coreIndex)
xyzA <- fit.xyz(xyzA[1, ], xyzA, fixed.inds=ca.inds$xyz,mobile.inds=ca.inds$xyz)
rA <- rmsf(xyzA)


b_affiles <- list.files("../selectedModels/b2/", pattern=".pdb", full.names=TRUE)    #afsample, nmr, colab
b_pdbfiles <-pdbsplit(b_affiles, ncore=10)
b_pdbs <- pdbaln(b_pdbfiles, super5=TRUE, ncore=10)
b_pdbs.aa <- read.all(b_pdbs)
xyzB <- b_pdbs$xyz
ca.inds <- atom.select(b_pdbs, elety="CA", resno=coreIndex)
xyzB <- fit.xyz(xyzB[1, ], xyzB, fixed.inds=ca.inds$xyz,mobile.inds=ca.inds$xyz)
rB <- rmsf(xyzB)

nmr_affiles <- list.files("../selectedModels/2kw6/", pattern=".pdb", full.names=TRUE)    #afsample, nmr, colab
nmr_pdbfiles <-pdbsplit(nmr_affiles, ncore=10)
nmr_pdbs <- pdbaln(nmr_pdbfiles, super5=TRUE, ncore=10)
nmr_pdbs.aa <- read.all(nmr_pdbs)
xyzNMR <- nmr_pdbs$xyz
ca.inds <- atom.select(nmr_pdbs, elety="CA", resno=coreIndex+60)
xyzNMR <- fit.xyz(xyzNMR[1, ], xyzNMR, fixed.inds=ca.inds$xyz,mobile.inds=ca.inds$xyz)
rNMR <- rmsf(xyzNMR)

colab_affiles <- list.files("../selectedModels/AF2/", pattern=".pdb", full.names=TRUE)    #afsample, nmr, colab
colab_pdbfiles <-pdbsplit(colab_affiles, ncore=10)
colab_pdbs <- pdbaln(colab_pdbfiles, super5=TRUE, ncore=10)
colab_pdbs.aa <- read.all(colab_pdbs)
xyzColab <- colab_pdbs$xyz
ca.inds <- atom.select(colab_pdbs, elety="CA", resno=coreIndex+60)
xyzColab <- fit.xyz(xyzColab[1, ], xyzColab, fixed.inds=ca.inds$xyz,mobile.inds=ca.inds$xyz)
rColab <- rmsf(xyzColab)


#combine A/B
#ab_pdbfiles <-pdbsplit(b_affiles, ncore=10)
ab_pdbs <- pdbaln(c(a_pdbfiles, b_pdbfiles), super5=TRUE, ncore=10)
ab_pdbs.aa <- read.all(ab_pdbs)
xyzAB <- ab_pdbs$xyz
ca.inds <- atom.select(ab_pdbs, elety="CA", resno=coreIndex)
xyzAB <- fit.xyz(xyzAB[1, ], xyzAB, fixed.inds=ca.inds$xyz,mobile.inds=ca.inds$xyz)
rAB <- rmsf(xyzAB)


rci_df <- read.table("RCI1.csv", sep=",", header=TRUE)


rASCC <- cor(rci_df$RCI1, rA, method = 'spearman', use="complete.obs")
#0.270 

rBSCC <- cor(rci_df$RCI1, rB, method = 'spearman', use="complete.obs")
#0.206 


rABSCC <- cor(rci_df$RCI1, rAB, method = 'spearman', use="complete.obs")
#0.131

rAPCC <- cor(rci_df$RCI1, rA, method = 'pearson', use="complete.obs")
#0.757
rABPCC <- cor(rci_df$RCI1, rAB, method = 'pearson', use="complete.obs")
#0.668

library("epiR")
ccc <- epiR::epi.ccc(rci_df$RCI1[1:55]*12.7, rA[1:55], ci="z-transform", conf.level=0.95)
ccc$rho.c
#0.39

ccc <- epiR::epi.ccc(rci_df$RCI1[1:55]*12.7, rB[1:55], ci="z-transform", conf.level=0.95)
ccc$rho.c
#0.14

ccc <- epiR::epi.ccc(rci_df$RCI1[1:55]*12.7, rAB[1:55], ci="z-transform", conf.level=0.95)
ccc$rho.c
#0.70

ccc <- epiR::epi.ccc(rci_df$RCI1[1:55]*12.7, rNMR[11:65], ci="z-transform", conf.level=0.95)
ccc$rho.c
#0.58

ccc <- epiR::epi.ccc(rci_df$RCI1[1:55]*12.7, rColab[11:65], ci="z-transform", conf.level=0.95)
ccc$rho.c
#0.63 

par(mfrow = c(2, 1)) 
par(mar=c(2,2,1,1))

rci_rmsf = rci_df$RCI1*12.7 - rAB
rciA_rmsf = rci_df$RCI1*12.7 - rA 
rciB_rmsf = rci_df$RCI1*12.7 - rB
rciNMR_rmsf = rci_df$RCI1[1:55]*12.7 - rNMR[11:65]
#rciColab_rmsf = rci_df$RCI1*12.7 - rColab

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
#lines(rci_df$Number[1:55]+60, rciNMR_rmsf, col="grey", type="s", lwd=2, lty=5) # group a


abline(h=mD, col="grey", lty=3, lwd=2)
abline(h=mD+12.71*SEM, col="grey", lty=3, lwd=2)
text(mD, "95%CI",adj = c(20,0))
abline(h=mD-12.71*SEM, col="grey", lty=3, lwd=2)


plot(rci_df$Number[1:55]+60, rci_df$RCI[1:55]*12.7, type="o", col="black", xlab="Residue Number", ylab="Score", pch="o", lty=1, xaxt='n', xaxs="r",ylim=c(-0.03, 2))
axis(side=1, at=c(10,20,30,40,50,60,70, 80, 90, 100, 110)) 
#axis(side=2, at=c(0.10, 0.30, 0.50, 0.70, 0.90))

#lines(rci_df$Number[1:55], rall[1:55], col="blue", lwd=2) #all models 
lines(rci_df$Number[1:55]+60, rA[1:55], col="blue", lwd=2) # group a
lines(rci_df$Number[1:55]+60, rB[1:55], col="green", lwd=2) # group a

#lines(rci_df$Number[1:55], rAB[1:55], col="green", lwd=2) # group a
lines(rci_df$Number[1:55]+60, rAB[1:55], col="purple", lwd=2) # group a
lines(rci_df$Number[1:55]+60, rNMR[11:65], col="grey", lwd=2, lty=4) # group a
#lines(rci_df$Number[1:55], rColab[11:65], col="pink", lwd=2, lty=2) # group a

rect(62, -0.05, 81, -0.01, col="gray", border="NA")
rect(85, -0.05, 111, -0.01, col="gray", border="NA")




############ RCI_pLDDT plot#####################

#working directory - selectedModels
dfa <- read.table("RCI_pLDDT_a1.csv", sep=",", header=TRUE)
dfb <- read.table("RCI_pLDDT_b2.csv", sep=",", header=TRUE)

hetNOE <- read.table("../hetNOE_out", sep=" ", header=TRUE)


pLDDTAavg <- (dfa$a1_1.pdb+dfa$a1_2.pdb+dfa$a1_3.pdb+dfa$a1_4.pdb+dfa$a1_5.pdb)/500
pLDDTBavg <- (dfb$b2_1.pdb+dfb$b2_2.pdb+dfb$b2_3.pdb+dfb$b2_4.pdb+dfb$b2_5.pdb)/500

pLDDTavg <- (pLDDTAavg + pLDDTBavg)/2

hNOE <- replace(hetNOE, hetNOE <= -100, NA)

hNOESCC_FL <- cor(dfa$RCI1[1:55], hNOE$Value, method = 'spearman', use="complete.obs")

cor(hNOE$Value, pLDDTAavg[1:55], method = 'spearman', use="complete.obs")
cor(hNOE$Value, pLDDTBavg[1:55], method = 'spearman', use="complete.obs")

cor(dfa$RCI1[1:55], hNOE$Value, method = 'pearson', use="complete.obs")

pLDDT_0.5 <- replace(pLDDTavg, pLDDTavg <= 0.5, NA) # pLDDT > 0.5

summation0.5 <- c((pLDDT_0.5+dfa$RCI1/0.6)) # pLDDT > 0.5 


mD <- mean(summation0.5, na.rm=TRUE)
sdD <- sd(summation0.5, na.rm=TRUE)
SEM <- (sdD/sqrt(sum(!is.na(summation0.5))-1))

#summation_all <- c((pLDDTavg+dfa$RCI1/0.6)) #total
summation_A <- c((pLDDTAavg+dfa$RCI1/0.6)) #total
summation_B <- c((pLDDTBavg+dfa$RCI1/0.6)) #total

par(mfrow = c(3, 1)) 
par(mar=c(2,2,1,1))


plot(dfa$Number[1:55]+60, type="S", summation_A[1:55], col="blue", xlab="", ylab="", ylim=c(0.7,1.1),lwd=2, xaxt='n', xaxs="r", yaxs="r")
axis(side=1, at=c(10,20,30,40,50,60, 70, 80, 90, 100, 110)) 

rect(62, 1.035, 81, 1.045, col="orange", border="NA") #helix
rect(85, 1.035, 111, 1.045, col="orange", border="NA") #helix

lines(dfb$Number[1:55]+60, summation_B[1:55], type="S", col="green", lwd=2)



abline(h=mD, col="grey", lty=3, lwd=2)
abline(h=mD+12.71*SEM, col="grey", lty=3, lwd=2)
text(mD, "95%CI",adj = c(10,0))
abline(h=mD-12.71*SEM, col="grey", lty=3, lwd=2)

plot(dfa$Number[1:55]+60, dfa$RCI[1:55]/0.6, type="o", col="black", xlab="Residue Number", ylab="Score", pch="o", lty=1, ylim=c(-0.1,1.1), xaxt='n', yaxt='n', xaxs="r", yaxs="r")
axis(side=1, at=c(10,20, 30,40, 50,60, 70,80,90,100, 110)) 
axis(side=2, at=c(0.10, 0.30, 0.50, 0.70, 0.90))

lines(dfa$Number[1:55]+60, dfa$a1_1.pdb[1:55]/100, col="blue", lty=2)
lines(dfa$Number[1:55]+60, dfa$a1_2.pdb[1:55]/100, col="blue", lty=2)
lines(dfa$Number[1:55]+60, dfa$a1_3.pdb[1:55]/100, col="blue", lty=2)
lines(dfa$Number[1:55]+60, dfa$a1_4.pdb[1:55]/100, col="blue", lty=2)
lines(dfa$Number[1:55]+60, dfa$a1_5.pdb[1:55]/100, col="blue", lty=2)
lines(dfa$Number[1:55]+60, pLDDTAavg[1:55], col="blue", lwd=2)

lines(dfb$Number[1:55]+60, dfb$b2_1.pdb[1:55]/100, col="green", lty=2)
lines(dfb$Number[1:55]+60, dfb$b2_2.pdb[1:55]/100, col="green", lty=2)
lines(dfb$Number[1:55]+60, dfb$b2_3.pdb[1:55]/100, col="green", lty=2)
lines(dfb$Number[1:55]+60, dfb$b2_4.pdb[1:55]/100, col="green", lty=2)
lines(dfb$Number[1:55]+60, dfb$b2_5.pdb[1:55]/100, col="green", lty=2)
lines(dfb$Number[1:55]+60, pLDDTBavg[1:55], col="green", lwd=2)

abline(h=0.5, col="grey", lty=4, lwd=1)
abline(h=0.7, col="grey", lty=4, lwd=1)
abline(h=0.9, col="grey", lty=4, lwd=1)

barplot(hNOE$Value-0.5, width = 0.3, space=2.25, border = NA, col="black", ylab="RCI/0.6, 0.01*pLDDT Scores", pch="o", lty=1, ylim=c(-1.3,0.6), xlim=c(1,55), xaxt='n', yaxt='n', xaxs="r", yaxs="r")
axis(side=1, at=c(60,70, 80, 90, 100, 110, 120)) 
axis(side=2, at=c(-1.5, -1.0, -0.5, 0, 0.5, 1.0), labels = c(-1.0, -0.5, 0, 0.5, 1.0, 1.5))

abline(h=0, col="black", lty=1, lwd=1)


SCC1 <- cor(dfa$a1_1.pdb[1:55], dfa$RCI1[1:55], method = 'spearman', use="complete.obs")
SCC2 <- cor(dfa$a1_2.pdb[1:55], dfa$RCI1[1:55], method = 'spearman', use="complete.obs")
SCC3 <- cor(dfa$a1_3.pdb[1:55], dfa$RCI1[1:55], method = 'spearman', use="complete.obs")
SCC4 <- cor(dfa$a1_4.pdb[1:55], dfa$RCI1[1:55], method = 'spearman', use="complete.obs")
SCC5 <- cor(dfa$a1_5.pdb[1:55], dfa$RCI1[1:55], method = 'spearman', use="complete.obs")
SCCavg <- cor(pLDDTAavg[1:55], dfa$RCI1[1:55], method = 'spearman', use="complete.obs")

SCC1 <- cor(dfb$b2_1.pdb[1:55], dfb$RCI1[1:55], method = 'spearman', use="complete.obs")
SCC2 <- cor(dfb$b2_2.pdb[1:55], dfb$RCI1[1:55], method = 'spearman', use="complete.obs")
SCC3 <- cor(dfb$b2_3.pdb[1:55], dfb$RCI1[1:55], method = 'spearman', use="complete.obs")
SCC4 <- cor(dfb$b2_4.pdb[1:55], dfb$RCI1[1:55], method = 'spearman', use="complete.obs")
SCC5 <- cor(dfb$b2_5.pdb[1:55], dfb$RCI1[1:55], method = 'spearman', use="complete.obs")
SCCavg <- cor(pLDDTBavg[1:55], dfb$RCI1[1:55], method = 'spearman', use="complete.obs")



