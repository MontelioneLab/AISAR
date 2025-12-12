
---

### `docs/scripts.md`

```markdown
---
title: Scripts & Workflow
layout: default
---

# 📁 scripts/

Python and R utilities for scoring, clustering, and model selection.

## Main scripts

- **runSCC.py** – calculate SCC scores for all models  
- **runRPF.py** – run RPF scoring (slow, I/O heavy)  
- **getRPF.py** – extract RPF scores into `rpf.sc`  
- **getpLDDT.py** – extract pLDDT from AFsample/AF outputs into `pLDDT.sc`  
- **getScores.py** – combine scores into `scores.all`  
- **dmPCAClustering.R** – PCA + clustering of distance matrices  
- **selectModels.py** – select conformers based on scores  
- **groupModels.py** – group selected models into ensembles

## Input conventions

- **ESmodels/** – all PDB models  
  - supports `relaxed*.pdb` or `relaxed*_new.pdb`
- **RPF/** – input/output for RPF runs  
- **RCI.csv** – edited RCI output with columns: `Number`, `RCI`, `Residue`

Then follow the commands from the [Quick Start](quickstart.md) to generate:

- `scc.sc` – SCC scores  
- `rpf.sc` – RPF scores  
- `pLDDT.sc` – pLDDT scores  
- `scores.all` – combined scoring table  
