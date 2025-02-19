# AlphaFold-NMR

Scripts and data corresponding to Huang, Ramelot, Spaman, Kobayashi, Montelione (2025) "Hidden Structural States of Proteins Revealed by Conformer Selection with AlphaFold-NMR"

<img width="994" alt="Screen Shot 2025-02-01 at 8 25 28 PM" src="https://media.github.rpi.edu/user/352/files/6e82ef7c-df17-4e60-baaa-b8ebb76950b0">

# Usage

1. AI enhanced sampling

Input sequence: It is better to exclude the long disordered tails and non-native tags from the input fasta sequence for AF modeling, which may influence the pTM and <pLDDT> scores. 
  
scripts used: 
  

DataSet: 
  a. CDK2AP1: 5984 models in relaxedModelsFromAFsample/  
    scripts used for generating 5984 models CDK2AP1/scripts/AI_ES:
      a.1. calculate and relax all 6000 models: run_afsample6000.sh
      a.2. filter out bad models: 
          https://github.rpi.edu/RPIBioinformatics/FilteringAF2_scripts
  
  b. GLuc
  
2. Clustering
  
scripts for CDK2AP1: 
  
3. Scoring
 
scripts for CDK2AP1: 
  
4. State combination
  
scripts for CDK2AP1:
  
5. Validation
  
scripts for CDK2AP1:
