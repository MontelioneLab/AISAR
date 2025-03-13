#!python

import re
import sys 

# Default file names
default_scores_file = "scores.sc"
default_pLDDT_file = "pLDDT.sc"
default_scc_file = "scc.sc"
default_rpf_file = "rpf.sc"
default_pca_file = "cluster_pc_dm.csv"

def print_usage():
    """Prints usage instructions for the script."""
    print("\nUsage: python getScores.py [scores.sc] [pLDDT.sc] [scc.sc] [rpf.sc] [cluster_pc_dm.csv]")
    print("\nArguments:")
    print("  scores.sc         (optional) Default: scores.sc")
    print("  pLDDT.sc          (optional) Default: pLDDT.sc")
    print("  scc.sc            (optional) Default: scc.sc")
    print("  rpf.sc            (optional) Default: rpf.sc")
    print("  cluster_pc_dm.csv (optional) Default: cluster_pc_dm.csv")
    print("\nIf no arguments are provided, the script will use the default file names.")
    print("Example:")
    print("  python getScores.py my_scores.sc my_pLDDT.sc my_scc.sc my_rpf.sc my_cluster.csv")
    sys.exit(1)

# Check for "--help" or incorrect usage
if "--help" in sys.argv or "-h" in sys.argv:
    print_usage()
    
# Use command-line arguments if provided, otherwise use default values
scores_file = sys.argv[1] if len(sys.argv) > 1 else default_scores_file
pLDDT_file = sys.argv[2] if len(sys.argv) > 2 else default_pLDDT_file
scc_file = sys.argv[3] if len(sys.argv) > 3 else default_scc_file
rpf_file = sys.argv[4] if len(sys.argv) > 4 else default_rpf_file
pca_file = sys.argv[5] if len(sys.argv) > 5 else default_pca_file

#print(f"Using files:\n  - pTM: {scores_file}\n  - pLDDT: {pLDDT_file}\n  - SCC: {scc_file}\n  - RPF: {rpf_file}\n  - PCA: {pca_file}")


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
        result = re.search(r"result_([\w|\_|\d]+)\.pkl\s+(\d+\.\d+)", line)
        if result:
            pTM[result.group(1)] = result.group(2)

with open("pLDDT.sc") as f:
    for line in f:
        result = re.search(r"relaxed_([\w|\_|\d]+)\.pdb\s+(\d+\.\d+)", line)
        name = re.sub(r'_new', '', result.group(1))
        if result:
            pLDDT[name] = result.group(2)

with open("scc.sc") as f:
    for line in f:
        result = re.search(r"relaxed_([\w|\_|\d]+)\.pdb\s+(-*\d+\.\d+)", line)
        name = re.sub(r'_new', '', result.group(1))
        if result:
            scc[name] = result.group(2)

with open("rpf.sc") as f:
    for line in f:
        result = re.search(r"relaxed_([\w|\_|\d]+)\.pdb\s+(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)", line)
        name = re.sub(r'_new', '', result.group(1))
        if result:
            #print(result.group(1), result.group(2))
            recall[name] = result.group(2)
            precision[name] = result.group(3)
            dp[name] = result.group(4)
            
with open("cluster_pc_dm.csv") as f:
    for line in f:
        result = re.search(r"[relaxed_]*([\w\d_]+)\.pdb,(-*\d+\.\d+),(-*\d+\.\d+),(-*\d+\.\d+),(\d)", line)
        name = re.sub(r'_new', '', result.group(1))
        if result:
            pca1[name] = result.group(2) 
            pca2[name] = result.group(3)
            pca3[name] = result.group(4) 
            grp[name] = result.group(5)

print("MODEL   pTM     pLDDT   PCA1    PCA2    PCA3    Recall  DP      SCC     Cluster")
for name in pca1.keys():
    print(
        name,
        pTM.get(name, -1),  # Default to -1 if missing
        pLDDT.get(name, -1),
        pca1.get(name, -1),
        pca2.get(name, -1),
        pca3.get(name, -1),
        recall.get(name, 1), # NA to 1 
        dp.get(name, 1), # NA to 1
        scc.get(name, 1), # NA to 1 
        grp.get(name, -1), 
    )
        
        
