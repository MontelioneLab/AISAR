# AISAR (<ins>AI</ins> <ins>SA</ins>mpling with NMR <ins>R</ins>ecall selection) 

Scripts and data corresponding to Huang, Ramelot, Spaman, Kobayashi, Montelione (2025) "Hidden Structural States of Proteins Revealed by Conformer Selection"

<img width="1161" alt="flowChart" src="https://github.rpi.edu/RPIBioinformatics/AISAR/assets/352/c837b9bd-0e8b-44f8-9033-6477ae9f476f">

AISAR is a computational–experimental framework for identifying fast-exchanging conformational states from NMR data. Unlike conventional NMR methods that rely on spatial restraints, AISAR combines AI-driven conformational sampling of realistic models with Bayesian-like scoring against NOESY and other NMR observables. Applied to Gaussia luciferase, AISAR reveals two interconverting states involving large rearrangements of two lids, binding pockets, and cryptic surface cavities. AISAR also identifies two distinct conformational states of the human tumor suppressor Cyclin-Dependent Kinase 2-Associated Protein 1, demonstrating its utility across diverse protein scaffolds. Validation using the NOESY Double Recall method shows that these multistate models account for more NOESY peaks than individual conformers, supporting the presence of fast-exchanging structural states in dynamic equilibrium. AISAR enables detection and evaluation of conformational heterogeneity and cryptic pockets not resolved by conventional single-state NMR analysis, providing new insights into protein structural dynamics and function.


## No required non-standard hardware 

## Software Requirements

### R Packages: 
```
bio3d: http://thegrantlab.org/bio3d_v2/tutorials/installing-bio3d (install muscle: brew install brewsci/bio/muscle) 
cluster 
```
### Python Dependencies
```
numpy
pandas
```

### RCI webserver for RCI and SCC calculation
https://www.randomcoilindex.ca/cgi-bin/rci_cgi_current.py

script/RCItools -- tools developed to generate SHIFTY input file to run RCI webserver 
  - RPFtable2SHIFTY.py: convert the chemical shift file used by RPF (bmrbtable file) to SHIFTY format 
  - nmrstar3toSHIFTY-fromBMRB.py: provide the bmrb ID number, download chemical shift assignments from the BMRB database and convert to SHIFTY format
  - nmrstar3toSHIFTY.py: convert the local bmrb file in nmrstart 3.0 format to SHIFTY format 

### ASDP/RPF for Recall calculation in batch mode 
https://github.rpi.edu/RPIBioinformatics/ASDP_public

### RPF webserver for DoubleRecall analysis 
https://montelionelab.chem.rpi.edu/rpf/

### AFsample for enhanced sampling 
https://github.com/bjornwallner/alphafoldv2.2.0

# AlphaFold-NMR R and Python Scripts with Demo 2kiw_AFsample/ and CDK2AP1-doc1/

2kiw_AFsample --> monomer and single-state conformation <br>
CDK2AP1-doc1 --> dimer and two-state conformation <br> 

Typical install times are several minutes. 

*** all paths in the scripts need to be changed to your local computer environment 

## 1. AI Enhanced sampling using AFsample 
* run_afsample6000.sh 
   - need to modify the path to fit your local computer system
   - calculate 6000 models using 1 GPU, 8 cores, 32GB RAM
* run_relax48.sh
   -   relax all 6000 models using 48 cores, 96GB RAM 
Runtime: it can take days to calculate 6000 models, depending on the size of the sequence. 

* mergeChain.py and runMergedChain.py (dimer only) 
   - merge two chains into one chain for PCA analysis 
   
* FilterAF2.py (optional): filters out bad models based on the AF log file. The python code is copied from here: https://github.rpi.edu/RPIBioinformatics/FilteringAF2_scripts

  Input sequence for AlphaFold: 2kiw.fasta 
     
  Commands: 
  
  set working dir: 2kiw_AFsample
```
   cd 2kiw_AFsample 
   sbatch ../script/run_afsample6000.sh 2kiw.fasta
```
This command calculates and relax all 6000 models using run_afsample6000.sh <br> The output models will be here: AF_models_dropout/2kiw. pTM score is reported here: AF_models_dropout/scores.sc and log from AF: slurm-xxx.out 

Once all 6000 models are calculated, then relax

```
  sbatch ../script/run_relax64.sh AF_models_dropout/scores.sc
```

```
  python FilterAF2.py -log slurm-xxx.out -rel -inD AF_models_dropout/2kiw -outD filteredModels
```
  This command filters out bad models based on the AF log file (e.g. slurm-xxx.out). slurm-xxx.out file is the output file from sbatch run_afsample6000.sh.  

  Additional processing scripts for dimer: 
  
  Merge two chains into one chain for clustering analysis
```
  python ../scripts/runMergedChain.py <twoChains> <mergedChain>
```  
  This command finds all pdb file in the <twoChains>, merge two chains (using mergeChain.py) and save them in the <mergedChain> directory. 
  
### Download pre-calculated AFsample models
2kiw: https://zenodo.org/records/15377074. Unzip and name it as 2kiw_AFsample/ESmodels/ for further analysis. <br>
CDK2AP1-doc1: https://zenodo.org/records/15015917 has 5984 models with one merged chain. Please unzip it and name it as CDK2AP1-doc1/ESmodels/ for further analysis: 

## 2. Clustering
* dmPCAClustering.R
    --> output: pc_dm_pdbs.RData, cluster_pc_dm.csv (in Rstudio, set the working dir to 2kiw_AFsample or CDK2AP1-doc1 before running the R script) 
 
We use "ward methods". To identify number of clusters --> by inspection of "Dendrogram" and pc plots.  

Runtime: it can take hours (s) to cluster 6000 models, depending on the size of the sequence and the number of cores

## 3. Scoring

### Input files:
   - ESmodels: all pdb files, support filenames with "relaxed*.pdb" or "relaxed*_new.pdb"
   - RPF: input files to run RPF
   - RCI.csv: output from the RCI webserver, the RCI sequence was edited to match the pdb sequence from ESmodels. Need to add a header to the corresponding columns: Number, RCI and Residue and save as csv format.  

### Scripts:
 - runSCC.py: calculate SCC scores for all models, and write to file scc.sc 
```
   python ../scripts/runSCC.py RCI.csv ESmodels > scc.sc
```
 - runRPF.py and getRPF.py: calculate RPF scores for all models, and write to file rpf.sc. 
slow step - performance can be improved by reducing the I/O (for future improvement). 

```
   cd RPF (for 2kiw) or cd NMRdata (for CDK2AP1-doc1) 
   python ../../scripts/runRPF.py control_RPF ../ESmodels rpfESmodels
```
   need to set the RPFcommand in the runRPF.py script. output: RPF/refESmodels

   back to the 2kiw_AFsample working directory
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
## 4. State combination
* selectModles.py: select models based on pNMR scores, create a directory with top5 models from each cluster <br>
   
``` 
 python ../scripts/selectModels.py scores.all ESmodels/ selectedModels/ | tee selectedModels.log 
```
input: scores.all: output from step 3 - Scoring <br>
output: selectedModels.log and selectedModels/ 

```
 plots: plotScores.R: R plots of these scores for model selection 
```

* groupModels.py: group all pdb files in one directory into one pdb file with multiple models

```
python ../scripts/groupModels.py selectedModels/a1 
```
output: selectedModels/a1.pdb
   
* State combination is based on the SEM plot of RMSFvsRCI and CCC scores.
  
   - make RMSF_RCI SEM plot (RMSF_RCIplotOne.R)
for 2kiw: inputs are RCI.csv and selectedModels/a1 
```
> cccA$rho.c
est     lower     upper
1 0.9484497 0.9251188 0.9646448
```
   - make RCI_pLDDT SEM plot (getRCIpLDDT.py and RCI_pLDDT.R)
     
```
python getRCIpLDDt.py <RCI.csv> <selectedModels/a1>
```
output: this python script gerenate this output -- RCI_pLDDT_selectedModels.csv and use RCI_pLDDTplot.R for the RCI_pLDDT SEM plot. 
   
## 5. Validation by DoubleRecall analysis

For selected states, get RPF.zip file by runing RPF webserver (https://www.randomcoilindex.ca/cgi-bin/rci_cgi_current.py) 
   
* DoubleRecall - ensemble A vs ensemble B:
[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/drive/1IPXZVDdxG1xpn-6tgIErWJOSLa9Rx87A)https://colab.research.google.com/drive/1IPXZVDdxG1xpn-6tgIErWJOSLa9Rx87A
   
* DoubleRecall - ensemble A vs ensembles B1+B2: 
[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/drive/1YShoUAQWdKu0EccMJgkLeeiojUWKT0SJ)https://colab.research.google.com/drive/1YShoUAQWdKu0EccMJgkLeeiojUWKT0SJ   
   

 



  


