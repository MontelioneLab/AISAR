
################# distance metrix and PCA analysis ##########################
library(bio3d)
setup.ncore(10)

#set the working directory to the folder with ESmodels 

pdbfiles <- list.files("ESmodels", pattern=".pdb", full.names=TRUE) 
pdbs <- pdbaln(pdbfiles, super5=TRUE, ncore=10)
pdbs.aa <- read.all(pdbs)

dm <- dm(pdbs.aa, all.atom=TRUE)

pc <- pca.array(dm)
save(pc, dm, pdbs, pdbs.aa, file = "dm_pc.RData") # achive 


################## clustering #############################

library(cluster)
setup.ncore(10)

#redo clustering, and skip the PCA analysis, uncomment load... 
#load("dm_pc.RData")
 
plot.pca.scree(pc) 

#use ward method 
hc2 <- agnes(pc$z[,1:3], method = "ward")

# Agglomerative coefficient
hc2$ac

pltree(hc2, cex = 0.6, hang = -1, main = "Dendrogram of agnes-ward")

grps <- cutree(hc2, k=4)
plot(pc, col=grps)

cluster = data.frame(unlist(pdbs.aa$id), pc$z[,1:3],unlist(grps))
write.csv(cluster, "cluster_pc_dm.csv", row.names=FALSE)

