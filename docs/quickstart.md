# 🚀 Quick Start

Follow these numbered steps to run AISAR scoring and conformer selection.

## 1. Install Requirements

### Python

```bash
pip install numpy pandas
```

R:
install.packages(c("cluster", "DescTools", "RColorBrewer", "bio3d"))

# macOS MUSCLE (for bio3d):
```bash
brew install brewsci/bio/muscle
```

### 2. Prepare Input Files
Your dataset directory should contain:

```
<protein>/
├─ ESmodels/        # All AFsample / AlphaFold PDB models
├─ RPF/             # Folder for RPF scoring
└─ RCI.csv          # Edited RCI output (Number, RCI, Residue)
```
Requirements for RCI.csv
- Columns: Number, RCI, Residue
- Sequence must match PDB sequence in ESmodels
- Include residues even if RCI is missi

### 3. Compute SCC Scores
From within your dataset directory:
```
python scripts/runSCC.py RCI.csv ESmodels > scc.sc
```
Output: scc.sc

### 4. Compute RPF Scores

This is the slowest step. Inside RPF/:

```
cd RPF
python ../scripts/runRPF.py control_RPF ../ESmodels rpfESmodels
```
Make sure to set RPFcommand correctly inside runRPF.py.

Extract RPF scores:
```
cd ..
python scripts/getRPF.py RPF/rpfESmodels > rpf.sc
```
Output: rpf.sc

### 5. Compute pLDDT Scores
```
python scripts/getpLDDT.py ESmodels > pLDDT.sc
```
Output: pLDDT.sc

### 6. Perform PCA and Clustering (Optional but recommended)

In R:
```
source("scripts/dmPCAClustering.R")
```

This produces:
- PCA projections
- clusters
Output: cluster_pc_dm.csv 
### 7. Combine All Scores Into One Table
```
python scripts/getScores.py scores.sc pLDDT.sc scc.sc rpf.sc cluster_pc_dm.csv > scores.all
```

Or use default filenames:
```
python scripts/getScores.py > scores.all
```
Output: scores.all

### 8. Select Conformers Based on Combined Scores

```
python scripts/selectModels.py scores.all ESmodels 5 | tee selected_models.log
```
Outputs:
selected_models.txt

State sets (A, B, C, D…)






