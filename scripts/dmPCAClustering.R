
################# distance metrix and PCA analysis ##########################
library(bio3d)
setup.ncore(10)

# Set the working directory so that the "ESmodels" folder is in the current path

pdbfiles <- list.files("ESmodels", pattern=".pdb", full.names=TRUE) 
pdbs <- pdbaln(pdbfiles, super5=TRUE, ncore=10)
pdbs.aa <- read.all(pdbs)


dm <- dm(pdbs.aa, all.atom=TRUE)

save(dm, pdbs, pdbs.aa, file = "dm.RData") # achive 


pc <- pca.array(dm)
save(pc, dm, pdbs, pdbs.aa, file = "dm_pc.RData") # achive 


################## clustering #############################

library(cluster)
setup.ncore(10)

# Reload PCA results (allows you to skip recomputing dm and pc)
#load("dm_pc.RData")
 
plot.pca.scree(pc) 

#use ward method 
hc2 <- agnes(pc$z[,1:3], method = "ward")

# Agglomerative coefficient
hc2$ac

pltree(hc2, cex = 0.6, hang = -1, main = "Dendrogram of agnes-ward")

# k - number of clusters 
grps <- cutree(hc2, k=1) # k=1 one cluster for 2KOB   
#grps <- cutree(hc2, k=4) # 4 clusters for GLuc and CDK2AP1 
plot(pc, col=grps)

cluster = data.frame(unlist(pdbs.aa$id), pc$z[,1:3],unlist(grps))
write.table(cluster, "cluster_pc_dm.csv", sep = ",", row.names = FALSE, col.names = FALSE, quote = FALSE)


