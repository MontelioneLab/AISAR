# AISAR (<ins>AI</ins> <ins>SA</ins>mpling with NMR <ins>R</ins>ecall selection) 

Scripts and datasets (2KOB, CDK2AP1 and GLuc) used in Huang, Ramelot, Spaman, Kobayashi, & Montelione (2025) "Hidden Structural States of Proteins Revealed by Conformer Selection"

<img width="1161" alt="flowChart" src="https://github.rpi.edu/RPIBioinformatics/AISAR/assets/352/c837b9bd-0e8b-44f8-9033-6477ae9f476f">

AISAR is a computational–experimental framework for identifying fast-exchanging conformational states from NMR data. Unlike conventional NMR methods that rely on spatial restraints, AISAR combines AI-driven conformational sampling of realistic models with Bayesian-like scoring against NOESY and other NMR observables. Applied to Gaussia luciferase, AISAR reveals two interconverting states involving large rearrangements of two lids, binding pockets, and cryptic surface cavities. AISAR also identifies two distinct conformational states of the human tumor suppressor Cyclin-Dependent Kinase 2-Associated Protein 1, demonstrating its utility across diverse protein scaffolds. Validation using the NOESY Double Recall method shows that these multistate models account for more NOESY peaks than individual conformers, supporting the presence of fast-exchanging structural states in dynamic equilibrium. AISAR enables detection and evaluation of conformational heterogeneity and cryptic pockets not resolved by conventional single-state NMR analysis, providing new insights into protein structural dynamics and function.


## No required non-standard hardware 

## Software Requirements

### R Packages: 
```
bio3d (http://thegrantlab.org/bio3d_v2/tutorials/installing-bio3d)
    - bio3d package uses the program muscle: brew install brewsci/bio/muscle 
cluster
DescTools
RColorBrewer 
```
### Python Dependencies
```
numpy
pandas
```

### RCI webserver for RCI and SCC calculation
https://www.randomcoilindex.ca/cgi-bin/rci_cgi_current.py

### ASDP/RPF for Recall calculation in batch mode 
https://github.rpi.edu/RPIBioinformatics/ASDP_public

### RPF webserver for DoubleRecall analysis 
https://montelionelab.chem.rpi.edu/rpf/

### AFsample for enhanced sampling 
https://github.com/bjornwallner/alphafoldv2.2.0

### Contents 
AISAR/
├─ scripts/        # Python scripts used for conformer selection
├─ 2KOB/        # Data and models for 2KOB
├─ CDK2AP1/     # Data and models for CDK2AP1
└─ GLuc/        # Data and models for GLuc
  
### Download pre-calculated AFsample models
2KOB: https://zenodo.org/records/15377074. Unzip and name it as 2kiw_AFsample/data_runs/ESmodels/ for further analysis. <br>
CDK2AP1: https://zenodo.org/records/15015917 has 5984 models with one merged chain. Please unzip it and name it as CDK2AP1/data_runs/ESmodels/ for further analysis
GLuc: 

### Validation by DoubleRecall analysis

For selected states, run RPF webserver (https://www.randomcoilindex.ca/cgi-bin/rci_cgi_current.py) and download the zip file

* DoubleRecall - ensemble A vs ensemble B:
[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/drive/1IPXZVDdxG1xpn-6tgIErWJOSLa9Rx87A)https://colab.research.google.com/drive/1IPXZVDdxG1xpn-6tgIErWJOSLa9Rx87A
   
* DoubleRecall - ensemble A vs ensembles B1+B2: 
[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/drive/1YShoUAQWdKu0EccMJgkLeeiojUWKT0SJ)https://colab.research.google.com/drive/1YShoUAQWdKu0EccMJgkLeeiojUWKT0SJ   
   

 



  


