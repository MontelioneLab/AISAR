library(RColorBrewer)

par(mfrow = c(1, 1)) 
par(mar=c(4,4,1,1))

t1027pca <- read.csv("pca_dm_figS9b.csv", sep=",",stringsAsFactors = FALSE)

nmr <- t1027pca[grepl("nmr", t1027pca$unlist.pdbs.aa.id), ]
fla <- t1027pca[grepl("9fla", t1027pca$unlist.pdbs.aa.id), ]
colab <- t1027pca[grepl("rank", t1027pca$unlist.pdbs.aa.id), ]
afsample <- t1027pca[grepl("relax", t1027pca$unlist.pdbs.aa.id), ]

plot(t1027pca$X1, t1027pca$X2, pch=20, col="grey", xlab = "PC1(34.06%)", ylab="PC2(25.18%)")
points(nmr$X1, nmr$X2, col="cyan", pch=15)
points(fla$X1, fla$X2, col="pink", pch=23, bg="pink")

grp3 <- t1027pca[t1027pca$unlist.grps. == 3,]
grp4 <- t1027pca[t1027pca$unlist.grps. == 4,]
grp5 <- t1027pca[t1027pca$unlist.grps. == 5,]
grp6 <- t1027pca[t1027pca$unlist.grps. == 6,]

points(grp6$X1, grp6$X2, col="blue", pch=16)
points(grp5$X1, grp5$X2, col="green", pch=16)
points(colab$X1, colab$X2, col="red", pch=17)



