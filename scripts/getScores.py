import re
import sys
import csv
import os

# Default file names
default_scores_file = "scores.sc"
default_pLDDT_file = "pLDDT.sc"
default_scc_file = "scc.sc"
default_rpf_file = "rpf.sc"
default_pca_file = "cluster_pc_dm.csv"

def print_usage():
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

with open(scores_file) as f:
    for line in f:
        result = re.search(r"result_([\w\_\d]+)\.pkl\s+(\d+\.\d+)", line)
        if result:
            pTM[result.group(1)] = result.group(2)

with open(pLDDT_file) as f:
    for line in f:
        result = re.search(r"relaxed_([\w\_\d]+)\.pdb\s+(\d+\.\d+)", line)
        if result:
            name = re.sub(r'_new', '', result.group(1))
            pLDDT[name] = result.group(2)

with open(scc_file) as f:
    for line in f:
        result = re.search(r"relaxed_([\w\_\d]+)\.pdb\s+(-*\d+\.\d+)", line)
        if result:
            name = re.sub(r'_new', '', result.group(1))
            scc[name] = result.group(2)

with open(rpf_file) as f:
    for line in f:
        result = re.search(r"relaxed_([\w\_\d]+)\.pdb\s+(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)", line)
        if result:
            name = re.sub(r'_new', '', result.group(1))
            recall[name] = result.group(2)
            precision[name] = result.group(3)
            dp[name] = result.group(4)

with open(pca_file) as f:
    reader = csv.reader(f)
    for row in reader:
        filename = os.path.basename(row[0])
        result = re.match(r"(?:relaxed_)?([\w\d_]+)\.pdb", filename)
        name = re.sub(r'_new_A', '', result.group(1))
        name = re.sub(r'_A', '', name)
        if result:
            pca1[name] = row[1]
            pca2[name] = row[2]
            pca3[name] = row[3]
            grp[name] = row[4]

# pTM was only weighted 0.2 from the AFsample, so it is /0.2 to rescale back as a monomer
# for Doc-1 as a dimer, no need do /0.2
print(f"{'MODEL':<40} {'pTM':>7} {'pLDDT':>7} {'PCA1':>7} {'PCA2':>7} {'PCA3':>7} {'Recall':>7} {'DP':>7} {'SCC':>7} {'Cluster':<7}")
for name in pca1.keys():
    print(f"{name:<40} {float(pTM.get(name, -1.0))/0.2:7.3f} {float(pLDDT.get(name, -1.0)):7.3f} {float(pca1.get(name, -1.0)):7.3f} "
          f"{float(pca2.get(name, -1.0)):7.3f} {float(pca3.get(name, -1.0)):7.3f} {float(recall.get(name, 1.0)):7.3f} "
          f"{float(dp.get(name, 1.0)):7.3f} {float(scc.get(name, 1.0)):7.3f} {int(grp.get(name, -1)):7}")
