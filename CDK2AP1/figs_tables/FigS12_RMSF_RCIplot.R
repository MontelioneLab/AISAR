library(bio3d)
setup.ncore(10)

#based on Talos 
l1 = seq(2,21)
l2 = seq(25,51)

coreIndex = c(l1, l2) # for rmsf alignment 


#set R's working directory: CDK2AP1/figs_tables 

### start rmsf  
calculate_rmsf_multi <- function(pdb_dirs, coreIndex, ncore = 10) {
  affiles <- unlist(lapply(pdb_dirs, function(dir) {
    list.files(dir, pattern = ".pdb", full.names = TRUE)
  }))
  
  pdbs <- pdbaln(affiles, super5 = TRUE, ncore = ncore)
  pdbs.aa <- read.all(pdbs)
  xyz <- pdbs$xyz
  ca.inds <- atom.select(pdbs, elety = "CA", resno = coreIndex)
  xyz <- fit.xyz(xyz[1, ], xyz, fixed.inds = ca.inds$xyz, mobile.inds = ca.inds$xyz)
  rmsf(xyz)
}

rA <- calculate_rmsf_multi("selectedModels/a1", coreIndex) #rmsf of state 1
rB <- calculate_rmsf_multi("selectedModels/b2", coreIndex) #rmsf of state 2
rAB <- calculate_rmsf_multi(c("selectedModels/a1","selectedModels/b2"), coreIndex) # rmsf of state 1+2
rNMR <- calculate_rmsf_multi("2kw6", coreIndex) # rmsf of nmr 

rci_df <- read.table("RCI1.csv", sep=",", header=TRUE)

library("epiR")
cccA <- epiR::epi.ccc(rci_df$RCI1[1:55]*12.7, rA[1:55], ci="z-transform", conf.level=0.95)
cccA$rho.c
#0.3863847 0.2510224 0.5069253

cccB <- epiR::epi.ccc(rci_df$RCI1[1:55]*12.7, rB[1:55], ci="z-transform", conf.level=0.95)
cccB$rho.c
#0.1433968 0.07501077 0.2104403

cccAB <- epiR::epi.ccc(rci_df$RCI1[1:55]*12.7, rAB[1:55], ci="z-transform", conf.level=0.95)
cccAB$rho.c
#0.7036326 0.5758535 0.7978547

cccNMR <- epiR::epi.ccc(rci_df$RCI1[1:55]*12.7, rNMR[1:55], ci="z-transform", conf.level=0.95)
cccNMR$rho.c
#0.6501938 0.5241182 0.7483824


par(mfrow = c(2, 1)) 
par(mar=c(2,2,1,1))

#SEM plot 
rci_rmsf = rci_df$RCI1*12.7 - rAB
rciA_rmsf = rci_df$RCI1*12.7 - rA 
rciB_rmsf = rci_df$RCI1*12.7 - rB

diff_ave <- (rci_rmsf[1:55]+rciA_rmsf[1:55]+rciB_rmsf[1:55])/3

mD <- mean(diff_ave, na.rm=TRUE)
sdD <- sd(diff_ave, na.rm=TRUE)
SEM <- (sdD/sqrt(sum(!is.na(diff_ave))-1))

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

#data 
plot(rci_df$Number[1:55]+60, rci_df$RCI[1:55]*12.7, type="o", col="black", xlab="Residue Number", ylab="Score", pch="o", lty=1, xaxt='n', xaxs="r",ylim=c(-0.03, 2))
axis(side=1, at=c(10,20,30,40,50,60,70, 80, 90, 100, 110)) 

lines(rci_df$Number[1:55]+60, rA[1:55], col="blue", lwd=2) # group a
lines(rci_df$Number[1:55]+60, rB[1:55], col="green", lwd=2) # group a

lines(rci_df$Number[1:55]+60, rAB[1:55], col="purple", lwd=2) # group a

lines(rci_df$Number[1:55]+60, rNMR[1:55], col="grey", lwd=2, lty=4) # group a

rect(62, -0.05, 81, -0.01, col="gray", border="NA")
rect(85, -0.05, 111, -0.01, col="gray", border="NA")


