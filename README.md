# AISAR (<ins>AI</ins> <ins>SA</ins>mpling with NMR <ins>R</ins>ecall selection) 

Scripts and datasets (2KOB, CDK2AP1 and GLuc) used in Huang, Ramelot, Spaman, Kobayashi, & Montelione (2025) "Hidden Structural States of Proteins Revealed by Conformer Selection"

<img width="1161" alt="flowChart" src="https://github.rpi.edu/RPIBioinformatics/AISAR/assets/352/c837b9bd-0e8b-44f8-9033-6477ae9f476f">

AISAR is a computational–experimental framework for identifying fast-exchanging conformational states from NMR data. Unlike conventional NMR methods that rely on spatial restraints, AISAR combines AI-driven conformational sampling of realistic models with Bayesian-like scoring against NOESY and other NMR observables. Applied to Gaussia luciferase, AISAR reveals two interconverting states involving large rearrangements of two lids, binding pockets, and cryptic surface cavities. AISAR also identifies two distinct conformational states of the human tumor suppressor Cyclin-Dependent Kinase 2-Associated Protein 1, demonstrating its utility across diverse protein scaffolds. Validation using the NOESY Double Recall method shows that these multistate models account for more NOESY peaks than individual conformers, supporting the presence of fast-exchanging structural states in dynamic equilibrium. AISAR enables detection and evaluation of conformational heterogeneity and cryptic pockets not resolved by conventional single-state NMR analysis, providing new insights into protein structural dynamics and function.

## 📘 Documentation

The full AISAR documentation is available in the `docs/` folder:

- 👉 **[Quick Start Guide](docs/quickstart.md)**  
- 🧪 **[Scripts & Workflow](docs/scripts.md)**  
- 📊 **[Data & Downloads](docs/data.md)**  
- 🏠 **[Documentation Home](docs/index.md)**  


## 🔧 Software Requirements

### R packages used:

- **bio3d**  
  Documentation and installation:  
  `http://thegrantlab.org/bio3d_v2/tutorials/installing-bio3d`  
  MUSCLE is required for sequence alignment. On macOS (Homebrew):  
  `brew install brewsci/bio/muscle`

- **cluster**

- **DescTools**

- **RColorBrewer**

The workflow can be run in **RStudio**, which is the recommended environment for convenient script editing, visualization, and interactive analysis.

### Python Dependencies
```
numpy
pandas
```

## 🌐 External Tools / Webservers Needed

### RCI webserver (RCI+SCC):
https://www.randomcoilindex.ca/cgi-bin/rci_cgi_current.py

### ASDP/RPF (batch Recall scoring): 
https://github.rpi.edu/RPIBioinformatics/ASDP_public

### RPF webserver (DoubleRecall): 
https://montelionelab.chem.rpi.edu/rpf/

### AFsample (AI enhanced sampling): 
https://github.com/bjornwallner/alphafoldv2.2.0

## 📂 Repository Structure 
```
AISAR/
├─ docs/        # Documentation  (Quick Start, Scripts, Data)
├─ scripts/     # Python scripts used for conformer selection
├─ 2KOB/        # Data and models for 2KOB
├─ CDK2AP1/     # Data and models for CDK2AP1
└─ GLuc/        # Data and models for GLuc
```  
## 📥 Download pre-calculated AFsample models
- 2KOB: https://zenodo.org/records/17917670 <br>
Unzip into: 2KOB/data_runs/ESmodels/  <br>
- CDK2AP1: https://zenodo.org/records/15015917 <br>
Unzip into: CDK2AP1/data_runs/ESmodels/ <br> 
- GLuc: https://zenodo.org/records/17917708 <br>
Unzip into: GLuc/data_runs/ESmodels/


   

 



  


