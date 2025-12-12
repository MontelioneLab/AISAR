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
