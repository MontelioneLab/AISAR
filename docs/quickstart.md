

2. Prepare Inputs

Each dataset (e.g. CDK2AP1/) should contain:

CDK2AP1/
├─ ESmodels/        # AFsample / AlphaFold models (.pdb)
├─ RPF/             # Input/output for RPF scoring
└─ RCI.csv          # RCI output edited to match PDB sequence

RCI.csv must have at least:

Number

RCI

Residue

and include residues even if RCI is missing.
