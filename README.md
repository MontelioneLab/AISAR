# AlphaFold-NMR

Scripts and data corresponding to Huang, Ramelot, Spaman, Kobayashi, Montelione (2025) "Hidden Structural States of Proteins Revealed by Conformer Selection with AlphaFold-NMR"

<img width="1161" alt="flowChart" src="https://media.github.rpi.edu/user/352/files/b6534f5c-e03d-4529-a4a5-bbc697c9db04">

# Software Requirements

## R Package: 
bio3d: http://thegrantlab.org/bio3d/

## Python Dependences
AF-NMR mainly depends on the Python scientifc stack

numpy
pandas

## ASDP/RPF
To run RPF, please download ASDP software here: https://github.rpi.edu/RPIBioinformatics/ASDP_public

## RCI webserver 
https://www.randomcoilindex.ca/cgi-bin/rci_cgi_current.py


# AlphaFold-NMR Scripts with Demo (set working dir: CDK2AP1-doc1)

## 1. enhancedSampling 
* run_afsample6000.sh 
   - need to modify the path to fit your local computer system
   - calculate 6000 models and also relax all 6000 models.  

* mergeChain.py and runMergedChain.py
   - merge two chains into one chain to PCA analysis 
   
* FilterAF2.py: filters out bad models based on the AF log file. The python code is copied from here: https://github.rpi.edu/RPIBioinformatics/FilteringAF2_scripts


### CDK2AP1-doc1 example: 
  * doc1_noN.fasta: input fasta sequence. We exclude the long disordered tails and non-native tags from the input fasta sequence for AF modeling, to avoid potential influence on the pTM and \<pLDDT\> scores. 
     
  Commands: 

  > sbatch run_doc1_noN.sh (running with slrum) 
  
  This command calculates and relax all 6000 models using run_afsample6000.sh <br>
  The output models are here: AF_models_dropout/doc1_noN. pTM score is reported here: AF_models_dropout/scores.sc and log from AF: slurm-xxx.out 
  
  > python FilterAF2.py -log slurm-xxx.out -rel -inD AF_models_dropout/doc1_noN -outD filteredModels
  
  This command filters out bad models based on the AF log file (e.g. slurm-xxx.out). 

  Additional processing scripts: 
  
  Merge two chains into one chain for clustering analysis
  > sh runMergedChain.py filteredModels mergedModels
  
  This command finds all pdb file in the fileredModels, merge two chains (using mergeChain.py) and save them in the mergedModels directory. 
  
  5984 models with one merged chain (CDK2AP1-doc1/ESmodels/) are used for the following analyses:  

## 2. clustering
* dmPCAClustering.R
    --> output: pc_dm_pdbs.RData, cluster_pc_dm.csv (in Rstudio, set the working dir to CDK2AP1-doc1 before running the R script) 
 
We found that "ward methods" gives largest agglomerative coefficient. Number of clusters --> by viusal inspection of "Dendrogram" and pc plots to identify number of well-seperated clusters.  
 
## 3. scoring
* runSCC.py and getSCC.py: calulate SCC scores for all models, and write to file scc.sc 
* runRPF.py and getRPF.py: calculate RPF scores for all models, and write to file rpf.sc 
* calcpLDDTscores.py: calculate <pLDDT> scores for all models, and write to file pLDDT.sc 
* getScores.py: combine all scores

 ### CDK2AP1-doc1 example: 
   > python ../scripts/runSCC.py
   > python ../scripts/getSCC.py
   > python ../scripts/runRPF.py
   > python ../scripts/getRPF.py
   > python ../scripts/calcupLDDTscores.py 
   > python ../scripts/getScores.py > scores.all 

## 4. stateCombination
* selectModles.py: select models based on p(model|NMR) scores 

### CDK2AP1-doc1 example: 
 > sh ../scripts/selectModels.py scores.all ESmodels ".pdb"

## 5. doubleRecall analysis 

# Other tools: 
* RCItools -- tools we developed to generate SHIFTY input file to run RCI webserver 
  - RPFtable2SHIFTY.py: convert the chemical shift file used by RPF (bmrbtable file) to SHIFTY format 
  - nmrstar3toSHIFTY-fromBMRB.py: give the bmrb ID number, download chemical shift assignments from the BMRB database and convert to SHIFTY format
  - nmrstar3toSHIFTY.py: convert the local bmrb file in nmrstart 3.0 format to SHIFTY format 
* plotTools -- tools to make figures
 



  


