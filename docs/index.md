# AISAR Documentation

Welcome to the AISAR documentation site.  
Here you will find practical guides, workflow instructions, and dataset information for running the AISAR conformer selection pipeline.

AISAR (AI Sampling with NMR Recall Selection) provides tools for:
- scoring AlphaFold/AFsample conformers  
- selecting structural states supported by NMR data  
- validating ensembles using DoubleRecall  

If you’re new to AISAR, start with the Quick Start guide below.

---

## 📘 Documentation Overview

### 👉 [Quick Start Guide](quickstart.md)
Step-by-step instructions for running AISAR:
- install dependencies  
- compute SCC, RPF, pLDDT  
- combine scores  
- perform PCA/clustering  
- select and assemble conformers  
- validate with DoubleRecall  

---

### 🧪 [Scripts & Workflow](scripts.md)
Descriptions of all Python and R scripts:
- what each script does  
- required inputs  
- expected outputs  
- example commands  

---

### 📊 [Data & Downloads](data.md)
Information on:
- ESmodels directory structure  
- RCI inputs  
- RPF inputs  
- AFsample model downloads (Zenodo links)  

---

## 🔗 Additional Resources

- AISAR GitHub Repository:  
  https://github.rpi.edu/RPIBioinformatics/AISAR

- AFsample (enhanced AlphaFold sampling):  
  https://github.com/bjornwallner/alphafoldv2.2.0

- ASDP/RPF (batch Recall scoring): <br>
  https://github.rpi.edu/RPIBioinformatics/ASDP_public

- RPF/DoubleRecall webserver:  
  https://montelionelab.chem.rpi.edu/rpf/

- RCI server (RCI & SCC):  
  https://www.randomcoilindex.ca/cgi-bin/rci_cgi_current.py

---

## 📄 Citation

If you use AISAR, please cite:

**Huang, Ramelot, Spaman, Kobayashi & Montelione (2026)**  
*Hidden Structural States of Proteins Revealed by Conformer Selection*

---
