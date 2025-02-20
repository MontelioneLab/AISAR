# AlphaFold-NMR

Scripts and data corresponding to Huang, Ramelot, Spaman, Kobayashi, Montelione (2025) "Hidden Structural States of Proteins Revealed by Conformer Selection with AlphaFold-NMR"

<img width="994" alt="Screen Shot 2025-02-01 at 8 25 28 PM" src="https://media.github.rpi.edu/user/352/files/6e82ef7c-df17-4e60-baaa-b8ebb76950b0">

# Usage

Data and scripts for CDK2AP1-doc1 AF-NMR analysis: 

1. AI enhanced sampling: CDK2AP1-doc1/AIenhandedSampling

  * doc1_noN.fasta: input fasta sequence. We exclude the long disordered tails and non-native tags from the input fasta sequence for AF modeling, to avoid any potential influence on the pTM and \<pLDDT\> scores. 
     
  Commands: 

  > sbatch run_doc1_noN.sh (running with slrum) 
  
  This command calculates and relax all 6000 models using run_afsample6000.sh <br>
  The output models are here: AF_models_dropout/doc1_noN. pTM score is reported here: AF_models_dropout/scores.sc 
  
  > python FilterAF2.py -rel -inD AF_models_dropout/doc1_noN -outD filteredModles
  
  This command filters out bad models. The python code is copied from here: https://github.rpi.edu/RPIBioinformatics/FilteringAF2_scripts

  Addtional processing scripts to merge two chains into one chain for clustering analysis
  > sh runMergedChain.py filteredModels mergedModels
  
  This command finds all pdb file in the fileredModels, merge two chains (using mergeChain.py) and save them in the mergedModels directory. 
  
  5984 models with one merged chain (CDK2AP1-doc1/ESmodels/) are used for the following analyses:  
  
2. Clustering
  
R scripts for CDK2AP1: 

 dmPCAClustering.R --> output: doc1_noN_dm_pc_merged.RData, cluster_all_dm.csv
  
3. Scoring
 
scripts for CDK2AP1: 
 * RPF scores: runRPF
 * pLDDT scores: 
 * combine all scores: 
 * plots: 
  
4. State combination
  
scripts for CDK2AP1:
  
5. Validation
  
scripts for CDK2AP1:
