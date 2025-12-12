library(bio3d)
setup.ncore(10)


# ranges for rmsf alignment 
l1 = seq(7,19)
l2 = seq(34,81)
l3 = seq(95,143)

coreIndex = c(l1, l2, l3)

# read in rci and pLDDT 
df <- read.table("RCI_pLDDT_selectedModels.csv", sep=",", header=TRUE)

newRCI <- df$RCI*12.7

### calculate rmsf from average of pLDDT 
library(minpack.lm) 
library(zeallot)


### calculate rmsf
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


### calculate ccc 
library(DescTools)
compare_ccc_variants <- function(rci, rmsf) {
  
  df <- data.frame(rci = rci, rmsf = rmsf)
  df <- df[complete.cases(df) & is.finite(df$rci) & is.finite(df$rmsf), ]
  
  if (nrow(df) == 0) return(CCC_standard = NA)
  
  #Standard CCC
  ccc_standard <- DescTools::CCC(df$rci, df$rmsf)$rho.c
  
  # Return a named list of CCC values
  return(CCC_standard = ccc_standard)
}

rA5 <- calculate_rmsf_multi(c("selectedModels/a5/"), coreIndex)
rB5 <- calculate_rmsf_multi(c("selectedModels/b3/"), coreIndex)
rAB5 <- calculate_rmsf_multi(c("selectedModels/a5", "selectedModels/b3/"), coreIndex)
rNMR <- calculate_rmsf_multi("7d2o", coreIndex)

compare_ccc_variants(newRCI, rA5) #0.1501854 0.03033139 0.2657818
compare_ccc_variants(newRCI, rB5) #0.3303135 0.2369665 0.4176173
compare_ccc_variants(newRCI, rAB5) #0.5542292 0.4548897 0.6399455

compare_ccc_variants(newRCI, rNMR) #0.2998336 0.256979 0.3415114


rci_rmsf = newRCI - rAB5
rA_rmsf = newRCI - rA5
rB_rmsf = newRCI - rB5

diff_ave <- (rA_rmsf+rB_rmsf+rci_rmsf)/3

mD <- mean(diff_ave, na.rm=TRUE)
sdD <- sd(diff_ave, na.rm=TRUE)
SEM <- (sdD/sqrt(sum(!is.na(diff_ave))-1))

par(mfrow = c(3, 1)) 
par(mar=c(2,2,1,1))

#SEM plot Fig 3a 
plot(df$Number, rB_rmsf, type="S", col="green", xlab="", ylab="", lwd=2, xaxt='n', xaxs="r", yaxs="r", xlim=c(1,170), ylim=c(-7, 7))
axis(side=1, at=c(1, 20, 40, 60, 80, 100, 120, 140, 160, 180)) 

rect(10, 0.49, 18, 0.99, col="cyan", border="NA")
rect(23, 0.49, 28, 0.99, col="lightblue", angle=90, density=20)
rect(36, 0.49, 51, 0.99, col="gray", border="NA")
rect(53, 0.49, 62, 0.99, col="gray", border="NA")
rect(66, 0.49, 73, 0.99, col="gray", border="NA")
rect(102, 0.49, 107, 0.99, col="gray", border="NA")
rect(108, 0.49, 120, 0.99, col="gray", border="NA")
rect(124, 0.49, 133, 0.99, col="gray", border="NA")
rect(137, 0.49, 144, 0.99, col="gray", border="NA")

rect(146, 0.49, 154, 0.99, col="red", angle=90, density=20)
rect(159, 0.49, 162, 0.99, col="red", angle=90, density=20)


lines(rA_rmsf, col="blue", type="s", lwd=2) # group a
lines(rci_rmsf, col="purple", type="s", lwd=2) # group a

abline(h=mD, col="grey", lty=3, lwd=2)
abline(h=mD+12.71*SEM, col="grey", lty=3, lwd=2)
text(mD, "95%CI",adj = c(0.5, -0.8))
abline(h=mD-12.71*SEM, col="grey", lty=3, lwd=2)


# rmsf plot Fig 3a
plot(df$Number, newRCI, type="o", col="black", xlab="Residue Number", ylab="Score", pch="o", lty=1, xaxt='n', xaxs="r",xlim=c(1,170), ylim=c(-0.03, 10))
axis(side=1, at=c(1, 20, 40, 60, 80, 100, 120, 140, 160, 180)) 

lines(rNMR, col="gray", typ="l", lwd=2, lty=2)
lines(rA5, col="blue", lwd=2) 
lines(rB5, col="green", lwd=2) 
lines(rAB5, col="purple", lwd=2) 

rect(7, -0.5, 19, -0.15, col="gray", border="NA")
rect(34, -0.5, 81, -0.15, col="gray", border="NA")
rect(95, -0.5, 143, -0.15, col="gray", border="NA")


####### compare rmsf with 10 models, 20 models for each cluster, used for Fig S4
rA10 <- calculate_rmsf_multi(c("selectedModels-10/a5/"), coreIndex)
rA20 <- calculate_rmsf_multi(c("selectedModels-20/a5/"), coreIndex)
rb10 <- calculate_rmsf_multi(c("selectedModels-10/b3/"), coreIndex)
rb20 <- calculate_rmsf_multi(c("selectedModels-20/b3/"), coreIndex)
rAB10 <- calculate_rmsf_multi(c("selectedModels-10/a5", "selectedModels-10/b3/"), coreIndex)
rAB20 <- calculate_rmsf_multi(c("selectedModels-20/a5", "selectedModels-20/b3/"), coreIndex)

compare_ccc_variants(newRCI, rA10) #0.1808579 0.06176437 0.2948737
compare_ccc_variants(newRCI, rA20) #0.1960302 0.05185644 0.3321994
compare_ccc_variants(newRCI, rb10) #0.3138956 0.2218131 0.400429
compare_ccc_variants(newRCI, rb20) #0.3312273 0.2429435 0.4140691
compare_ccc_variants(newRCI, rAB10) #0.5473301 0.4486601 0.6328176
compare_ccc_variants(newRCI, rAB20) #0.4859187 0.3753009 0.5828896


rC5 <- calculate_rmsf_multi(c("selectedModels/c2/"), coreIndex)
rC10 <- calculate_rmsf_multi(c("selectedModels-10/c2/"), coreIndex)
rC20 <- calculate_rmsf_multi(c("selectedModels-20/c2/"), coreIndex)

rD5 <- calculate_rmsf_multi(c("selectedModels/d4/"), coreIndex)
rD10 <- calculate_rmsf_multi(c("selectedModels-10/d4/"), coreIndex)
rD20 <- calculate_rmsf_multi(c("selectedModels-20/d4/"), coreIndex)

rAC5 <- calculate_rmsf_multi(c("selectedModels/a5", "selectedModels/c2/"), coreIndex)
rAC10 <- calculate_rmsf_multi(c("selectedModels-10/a5", "selectedModels-10/c2/"), coreIndex)
rAC20 <- calculate_rmsf_multi(c("selectedModels-20/a5", "selectedModels-20/c2/"), coreIndex)
rAD5 <- calculate_rmsf_multi(c("selectedModels/a5", "selectedModels/d4/"), coreIndex)
rAD10 <- calculate_rmsf_multi(c("selectedModels-10/a5", "selectedModels-10/d4/"), coreIndex)
rAD20 <- calculate_rmsf_multi(c("selectedModels-20/a5", "selectedModels-20/d4/"), coreIndex)


# rmsf plot for Fig S5
plot(df$Number, newRCI, type="o", col="black", xlab="Residue Number", ylab="Score", pch="o", lty=1, xaxt='n', xaxs="r",xlim=c(1,170), ylim=c(-0.03, 20))
axis(side=1, at=c(1, 20, 40, 60, 80, 100, 120, 140, 160, 180)) 


rect(10, 2.49, 18, 2.99, col="cyan", border="NA")
rect(23, 2.49, 28, 2.99, col="lightblue", angle=90, density=20)
rect(36, 2.49, 51, 2.99, col="gray", border="NA")
rect(53, 2.49, 62, 2.99, col="gray", border="NA")
rect(66, 2.49, 73, 2.99, col="gray", border="NA")
rect(102, 2.49, 107, 2.99, col="gray", border="NA")
rect(108, 2.49, 120, 2.99, col="gray", border="NA")
rect(124, 2.49, 133, 2.99, col="gray", border="NA")
rect(137, 2.49, 144, 2.99, col="gray", border="NA")

rect(146, 2.49, 154, 2.99, col="red", angle=90, density=20)
rect(159, 2.49, 162, 2.99, col="red", angle=90, density=20)


lines(rAC5, col="pink", lwd=2)
lines(rAD5, col="orange", lwd=2)
lines(rA5, col="blue", lwd=2) 
lines(rB5, col="green", lwd=2) 
lines(rAB5, col="purple", lwd=2) 


# results used for the Fig S4 plot 
compare_ccc_variants(newRCI, rC5) #0.259246 0.1761976 0.3386298
compare_ccc_variants(newRCI, rC10) #0.3253818 0.2305196 0.4141174
compare_ccc_variants(newRCI, rC20) #0.2945629 0.191941 0.390813

compare_ccc_variants(newRCI, rD5) #0.4067703 0.3162575 0.4899442
compare_ccc_variants(newRCI, rD10) #0.3748919 0.2796716 0.462809
compare_ccc_variants(newRCI, rD20) #0.3258857 0.2377596 0.4086905


compare_ccc_variants(newRCI, rAD5) #0.1266065 0.04892583 0.2027647
compare_ccc_variants(newRCI, rAD10) #0.126091 0.04586634 0.2046995
compare_ccc_variants(newRCI, rAD20) #0.1184763 0.03688616 0.1984973

compare_ccc_variants(newRCI, rAC5) #0.06639325 -0.01460087 0.1465218
compare_ccc_variants(newRCI, rAC10) #0.07073427 -0.01348872 0.1539606
compare_ccc_variants(newRCI, rAC20) #0.06929832 -0.0159699 0.1535659


rBC5 <- calculate_rmsf_multi(c("selectedModels/c2", "selectedModels/b3/"), coreIndex)
rBC10 <- calculate_rmsf_multi(c("selectedModels-10/c2", "selectedModels-10/b3/"), coreIndex)
rBC20 <- calculate_rmsf_multi(c("selectedModels-20/c2", "selectedModels-20/b3/"), coreIndex)
rBD5 <- calculate_rmsf_multi(c("selectedModels/b3", "selectedModels/d4/"), coreIndex)
rBD10 <- calculate_rmsf_multi(c("selectedModels-10/b3", "selectedModels-10/d4/"), coreIndex)
rBD20 <- calculate_rmsf_multi(c("selectedModels-20/b3", "selectedModels-20/d4/"), coreIndex)
rCD5 <- calculate_rmsf_multi(c("selectedModels/c2", "selectedModels/d4/"), coreIndex)
rCD10 <- calculate_rmsf_multi(c("selectedModels-10/c2", "selectedModels-10/d4/"), coreIndex)
rCD20 <- calculate_rmsf_multi(c("selectedModels-20/c2", "selectedModels-20/d4/"), coreIndex)

compare_ccc_variants(newRCI, rCD5) #0.5309342 0.4228409 0.6241312
compare_ccc_variants(newRCI, rCD10) #0.4850967 0.3716982 0.584232
compare_ccc_variants(newRCI, rCD20) #0.4540864 0.3368844 0.5574311

compare_ccc_variants(newRCI, rBD5) #0.08547594 0.002142989 0.1676299
compare_ccc_variants(newRCI, rBD10) #0.0832716 -0.002087595 0.1674261
compare_ccc_variants(newRCI, rBD20) #0.08006925 -0.00680568 0.1657446

compare_ccc_variants(newRCI, rBC5) #0.07343561 -0.004106194 0.1500996
compare_ccc_variants(newRCI, rBC10) #0.07296536 -0.007084194 0.1520857
compare_ccc_variants(newRCI, rBC20) #0.07282087 -0.008791746 0.1534698


#top 100, Fig S8bc 

l1 = seq(7,19)
l2 = seq(34,81)
l3 = seq(95,143)

coreIndex = c(l1, l2, l3)


rAall <- calculate_rmsf_multi("selectedModels-100/a5", coreIndex)
rBall <- calculate_rmsf_multi("selectedModels-100/b3", coreIndex)
rABall <- calculate_rmsf_multi(c("selectedModels-100/a5", "selectedModels-100/b3"), coreIndex)

compare_ccc_variants(newRCI, rAall) #0.2227962 0.077606 0.3587326
compare_ccc_variants(newRCI, rBall) #0.3858398 0.2867194 0.4767869
compare_ccc_variants(newRCI, rABall) #0.44476 0.3283174 0.5478869


#Fig S8bc
par(mfrow = c(1, 1)) 

plot(df$Number, newRCI, type="o", col="black", xlab="Residue Number", ylab="Score", pch="o", lty=1, xaxt='n', xaxs="r",xlim=c(0,170), ylim=c(-0.03, 10))
axis(side=1, at=c(1, 20, 40, 60, 80, 100, 120, 140, 160, 180)) 

lines(rAall, col="blue", lwd=2) 
lines(rBall, col="green", lwd=2) 
lines(rABall, col="purple", lwd=2) 
lines(rAB5, col="grey", lwd=2) 

#rect(7, -0.5, 19, -0.15, col="gray", border="NA")
#rect(34, -0.5, 81, -0.15, col="gray", border="NA")
#rect(95, -0.5, 143, -0.15, col="gray", border="NA")

rect(75, -0.5, 101, -0.15, col="green", border="NA")
rect(146, -0.5, 168, -0.15, col="red", border="NA")



