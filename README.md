# AlphaFold-NMR Protocol (under construction) 

Scripts and data corresponding to Huang, Ramelot, Spaman, Kobayashi, Montelione (2025) "Hidden Structural States of Proteins Revealed by Conformer Selection with AlphaFold-NMR"

<img width="1161" alt="flowChart" src="https://media.github.rpi.edu/user/352/files/b6534f5c-e03d-4529-a4a5-bbc697c9db04">

# Software Requirements

## R Packages: 
```
bio3d: http://thegrantlab.org/bio3d/
cluster 
```
## Python Dependences
AF-NMR mainly depends on the Python scientifc stack

```
numpy
pandas
```

## RCI webserver 
https://www.randomcoilindex.ca/cgi-bin/rci_cgi_current.py

## ASDP/RPF
To run RPF, please download ASDP software here: https://github.rpi.edu/RPIBioinformatics/ASDP_public

## RPF webserver
For doubleRecall analysis: https://montelionelab.chem.rpi.edu/rpf/

# AlphaFold-NMR R and Python Scripts with Demo

*** all paths in the scripts need to be changed to your local path 

## 1. AI Enhanced sampling 
* run_afsample6000.sh 
   - need to modify the path to fit your local computer system
   - calculate 6000 models and also relax all 6000 models.  

* mergeChain.py and runMergedChain.py
   - merge two chains into one chain to PCA analysis 
   
* FilterAF2.py: filters out bad models based on the AF log file. The python code is copied from here: https://github.rpi.edu/RPIBioinformatics/FilteringAF2_scripts

``` 
  Input sequence for AlphaFold: doc1_noN.fasta. 
  We exclude the long disordered tails and non-native tags from the input fasta sequence for AF modeling, to avoid potential influence on the pTM and <pLDDT> scores. 
     
  Commands: 
  > cd CDK2AP1-doc1 (set working dir: CDK2AP1-doc1)
  
  > sbatch run_doc1_noN.sh (running with slrum) 
  This command calculates and relax all 6000 models using run_afsample6000.sh <br>
  The output models are here: AF_models_dropout/doc1_noN. pTM score is reported here: AF_models_dropout/scores.sc and log from AF: slurm-xxx.out 
  
  > python FilterAF2.py -log slurm-xxx.out -rel -inD AF_models_dropout/doc1_noN -outD filteredModels
  This command filters out bad models based on the AF log file (e.g. slurm-xxx.out). 

  Additional processing scripts: 
  
  Merge two chains into one chain for clustering analysis
  > python ../scripts/runMergedChain.py filteredModels mergedModels
  
  This command finds all pdb file in the fileredModels, merge two chains (using mergeChain.py) and save them in the mergedModels directory. 
```  
### Download pre-filtered AFsample models
https://zenodo.org/records/15015917 has 5984 models with one merged chain. Please unzip it and name it as CDK2AP1-doc1/ESmodels/ for the following analyse. 

## 2. Clustering
* dmPCAClustering.R
    --> output: pc_dm_pdbs.RData, cluster_pc_dm.csv (in Rstudio, set the working dir to CDK2AP1-doc1 before running the R script) 
 
We found that "ward methods" gives largest agglomerative coefficient. Number of clusters --> by viusal inspection of "Dendrogram" and pc plots to identify number of well-seperated clusters.  
 
## 3. Scoring

### Input files:
   - ESmodels: all pdb files, support filenames with "relaxed*.pdb" or "relaxed*_new.pdb"
   - NMRdata: input files to run RPF
   - RCI1.csv: from RCI webserver, the sequence was edited to match with merged sequence from ESmodels

### Scripts:
 - runSCC.py: calulate SCC scores for all models, and write to file scc.sc 
```
   > python ../scripts/runSCC.py RCI1.csv ESmodels > scc.sc
```
 - runRPF.py and getRPF.py: calculate RPF scores for all models, and write to file rpf.sc. 
slow step - performance can be improved by only output recall, precision, f-measure and dp scores and skips others. 
```
   working directory: NMRdata
   > python ../../scripts/runRPF.py control_RPF ../ESmodels rpfESmodels 
   need to set the RPFcommand in the runRPF.py script 
   > python ../../scripts/getRPF.py rpfESmodels > rpf.sc  
```
   output: NMRdata/rpfESmodels and NMRdata/rpf.sc 
   
- getpLDDT.py: calculate <pLDDT> scores for all models, and write to file pLDDT.sc 

```
   > python ../scripts/getpLDDT.py ESmodels > pLDDT.sc 
```
 - getScores.py: combine all scores. <br>
This script only works for models with the name "relaxed****.pdb" from AFsample. If your model name is different, you will need to change the script. 
   
```
   > python ../scripts/getScores.py scores.sc pLDDT.sc scc.sc rpf.sc cluster_pc_dm.csv > scores.all  
   > python ../scripts/getScores.py > scores.all 
```
## 4. State combination
* selectModles.py: select models based on p(model|NMR) scores, create a diretory with top5 models from each cluster <br>
   
``` 
 > sh ../scripts/selectModels.py scores.all ESmodels/ selectedModels/ > selectedModels.txt 
 scores.all: output from step 3 - Scoring
```
output: selectedModels.txt and selectedModels/ 
   
* R script for RMSF vs RCI stateCombination comparision (comming soon) 
   
## 5. Validation 

# Other tools: 
* RCItools -- tools we developed to generate SHIFTY input file to run RCI webserver 
  - RPFtable2SHIFTY.py: convert the chemical shift file used by RPF (bmrbtable file) to SHIFTY format 
  - nmrstar3toSHIFTY-fromBMRB.py: give the bmrb ID number, download chemical shift assignments from the BMRB database and convert to SHIFTY format
  - nmrstar3toSHIFTY.py: convert the local bmrb file in nmrstart 3.0 format to SHIFTY format 
* plotTools -- tools to make figures
 



  


