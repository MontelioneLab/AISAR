#!python

import re

pTM = {}
dp = {}
recall = {}
precision = {}
pca1 = {}
pca2 = {}
pca3 = {}
pLDDT = {}
grp = {}
scc = {}


with open("scores.sc") as f:
    for line in f:
        result = re.search(r"result_([\w|\_|\d]+).pkl\s+(\d+\.\d+)", line)
        if result:
            pTM[result.group(1)] = result.group(2)

with open("pLDDT.sc") as f:
    for line in f:
        result = re.search(r"relaxed_([\w|\_|\d]+)_new.pdb\s+(\d+\.\d+)", line)
        if result:
            pLDDT[result.group(1)] = result.group(2)

with open("scc.sc") as f:
    for line in f:
        result = re.search(r"relaxed_([\w|\_|\d]+)_new.pdb\s+(-*\d+\.\d+)", line)
        if result:
            scc[result.group(1)] = result.group(2)

with open("rpf.sc") as f:
    for line in f:
        result = re.search(r"relaxed_([\w|\_|\d]+)_new.pdb\s+(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)", line)
        if result:
            #print(result.group(1), result.group(2))
            recall[result.group(1)] = result.group(2)
            precision[result.group(1)] = result.group(3)
            dp[result.group(1)] = result.group(4)
            
with open("cluster_pc_dm.csv") as f:
    for line in f:
        result = re.search(r"split_chain\/[relaxed_]*([\w|\_|\d]+)_new_A.pdb\",(-*\d+\.\d+),(-*\d+\.\d+),(-*\d+\.\d+),(\d)", line)
        name = re.sub(r'_new', '', result.group(1))
        if result:
            name = result.group(1)
            pca1[name] = result.group(2) 
            pca2[name] = result.group(3)
            pca3[name] = result.group(4) 
            grp[name] = result.group(5)

print("MODEL   pTM     pLDDT   PCA1    PCA2    PCA3    Recall  DP      SCC     Cluster")
for name in pca1.keys():
    print(name, float(pTM[name]), pLDDT[name], pca1[name], pca2[name], pca3[name], recall[name], dp[name], scc[name], grp[name])


        
        
