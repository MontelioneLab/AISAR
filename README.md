# AlphaFold-NMR

Scripts and data corresponding to Huang, Ramelot, Spaman, Kobayashi, Montelione (2025) "Hidden Structural States of Proteins Revealed by Conformer Selection with AlphaFold-NMR"

<img width="994" alt="Screen Shot 2025-02-01 at 8 25 28 PM" src="https://media.github.rpi.edu/user/352/files/6e82ef7c-df17-4e60-baaa-b8ebb76950b0">

# Usage

Data and scripts for CDK2AP1-doc1 AF-NMR analysis: 

1. AI enhanced sampling: CDK2AP1-doc1/AI_ES

  * doc1_noN.fasta: input fasta sequence. We exclude the long disordered tails and non-native tags from the input fasta sequence for AF modeling, to avoid any influence to the pTM and \<pLDDT\> scores. 
  * run_doc1_noN.sh  
  * run_afsample6000.sh 
  * FilterAF2.py

  All files needs to be in the same directory 
  
    
  Commands: 

  > sbatch run_doc1_noN.sh
  
  This command calculates and relax all 6000 models. <br>
  
  > python FilterAF2.py -rel -inD AF_models_dropout/doc1_noN -outD filteredAFsample
  
  This command filters out bad models. https://github.rpi.edu/RPIBioinformatics/FilteringAF2_scripts


  Results: 5984 models passes the filtering and stored here: CDK2AP1-doc1/relaxedModelsFromAFsample/
  
2. Clustering
  
scripts for CDK2AP1: 
  
3. Scoring
 
scripts for CDK2AP1: 
  
4. State combination
  
scripts for CDK2AP1:
  
5. Validation
  
scripts for CDK2AP1:
