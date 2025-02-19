# AlphaFold-NMR

Scripts and data corresponding to Huang, Ramelot, Spaman, Kobayashi, Montelione (2025) "Hidden Structural States of Proteins Revealed by Conformer Selection with AlphaFold-NMR"

<img width="994" alt="Screen Shot 2025-02-01 at 8 25 28 PM" src="https://media.github.rpi.edu/user/352/files/6e82ef7c-df17-4e60-baaa-b8ebb76950b0">

# Usage

1. AI enhanced sampling

Input sequence: We exclude the long disordered tails and non-native tags from the input fasta sequence for AF modeling, to avoid any influence to the pTM and \<pLDDT\> scores. 
  
DataSet: 
  * CDK2AP1-doc1: 5984 models in relaxedModelsFromAFsample/
  * GLuc 
  
Scripts: CDK2AP1-doc1/scripts/AI_ES: Scripts to generate CDK2AP1-doc1 5984 models 
  * doc1_noN.fasta: input fasta sequence 
  * run_doc1_noN.sh  
  * run_afsample6000.sh 
  
  All three files needs to be in the same directory 
  
  * filter out bad models: <br> 
          https://github.rpi.edu/RPIBioinformatics/FilteringAF2_scripts <br>
  
* Commands: 

  * > sbatch run_doc1_noN.sh 
 
 This command calculates and relax all 6000 models. <br>
 
  * > XXXX



 
2. Clustering
  
scripts for CDK2AP1: 
  
3. Scoring
 
scripts for CDK2AP1: 
  
4. State combination
  
scripts for CDK2AP1:
  
5. Validation
  
scripts for CDK2AP1:
