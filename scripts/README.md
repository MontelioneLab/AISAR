# scripts

Python utilities for conformer selection and scoring.

- `runSCC.py` – calculate SCC scores 
- `runRPF.py` – calculate RPF scores 
- `getRPF.py` – extract RPF scores
- `getpLDDT.py` – extract pLDDT from AF outputs
- `getScores.py` – combine scores into summary tables
- `dmPCAClustering.R` – PCA and clustering using R
  
- `selectModels.py` – select conformers based on scores
- `groupModels.py` – group models into ensembles

### Input files:
   - ESmodels: all pdb files, support filenames with "relaxed*.pdb" or "relaxed*_new.pdb"
   - RPF: input files to run RPF
   - RCI.csv: output from the RCI webserver, the RCI sequence was edited to match the pdb sequence from ESmodels. Need to add a header to the corresponding columns: Number, RCI and Residue and save as csv format. Residues with no RCI should also be listed in this file.   

### Scripts:
 - runSCC.py: calculate SCC scores for all models, and write to file scc.sc 
```
   python runSCC.py RCI.csv ESmodels > scc.sc
```
 - runRPF.py and getRPF.py: calculate RPF scores for all models, and write to file rpf.sc. 
slow step - performance can be improved by reducing the I/O (to_do list). 

```
   cd RPF 
   python runRPF.py control_RPF ../ESmodels rpfESmodels
```
   need to set the RPFcommand in the runRPF.py script. output: RPF/refESmodels

```
   cd .. 
   python ../scripts/getRPF.py RPF/rpfESmodels > rpf.sc  
```
   Runtime: minutes to hours for 6000 models, depending on the size of the protein sequence  
   output: rpf.sc 
   
- getpLDDT.py: calculate <pLDDT> scores for all models, and write to file pLDDT.sc 

```
   python ../scripts/getpLDDT.py ESmodels > pLDDT.sc 
```
 - getScores.py: combine all scores. <br>
This script only works for models with the name "relaxed****.pdb" from AFsample. If your model name is different, you will need to change the script.

```
   python ../scripts/getScores.py scores.sc pLDDT.sc scc.sc rpf.sc cluster_pc_dm.csv > scores.all  
   python ../scripts/getScores.py > scores.all (as default, this command will also readin the above files)
```
