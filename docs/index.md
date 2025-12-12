# AISAR  
### AI Sampling with NMR Recall Selection

**AISAR** (<ins>AI</ins> <ins>SA</ins>mpling with NMR <ins>R</ins>ecall selection) is a computational–experimental framework for identifying hidden, fast-exchanging conformational states from NMR data.

This repository contains scripts and datasets (2KOB, CDK2AP1, GLuc) used in:

**Huang, Ramelot, Spaman, Kobayashi & Montelione (2025)**  
*“Hidden Structural States of Proteins Revealed by Conformer Selection”*

![AISAR workflow](https://github.rpi.edu/RPIBioinformatics/AISAR/assets/352/c837b9bd-0e8b-44f8-9033-6477ae9f476f)

---

## What AISAR does

- Uses **AFsample/AlphaFold** for deep conformational sampling  
- Scores models using **pLDDT, SCC, RPF, and clustering**  
- Selects **multi-state ensembles** supported by NOESY and RCI  
- Validates using **DoubleRecall** analysis

👉 Start with the [Quick Start guide](quickstart.md).

---

## Contents

- [Quick Start](quickstart.md) – install, run, and reproduce the workflow  
- [Scripts & Workflow](scripts.md) – details of all scripts and how they connect  
- [Data & Downloads](data.md) – Zenodo links and dataset structure  


---
title: AISAR Documentation
layout: default
---

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

- RPF/DoubleRecall webserver:  
  https://montelionelab.chem.rpi.edu/rpf/

- RCI server (RCI & SCC):  
  https://www.randomcoilindex.ca/cgi-bin/rci_cgi_current.py

---

## 📄 Citation

If you use AISAR, please cite:

**Huang, Ramelot, Spaman, Kobayashi & Montelione (2025)**  
*Hidden Structural States of Proteins Revealed by Conformer Selection*

---
