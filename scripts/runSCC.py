import os
import os
import sys
import re
import numpy as np
import pandas as pd


if len(sys.argv) < 3:
    print("Usage: python runSCC.py <RCI.csv> <ESmodels_directory>")
    sys.exit(1)


rci_file = sys.argv[1] 
models_dir = sys.argv[2] 

# Load RCI1.csv
if not os.path.exists(rci_file):
  print(f"Error: File '{rci_file}' not found.")
  sys.exit(1)

try:
  old_df = pd.read_csv(rci_file)
except pd.errors.EmptyDataError:
  print(f"Error: File '{rci_file}' is empty.")
  sys.exit(1)

# Check if the models directory exists
if not os.path.isdir(models_dir):
  print(f"Error: Directory '{models_dir}' not found.")
  sys.exit(1)

for root, dirs, files in os.walk(models_dir):  
  for filename in files:
    if re.search(r"\.pdb$", filename):
      fn = os.path.abspath(os.path.join(root, filename))
      try:
        with open(fn, 'r') as file:
          data = file.read()

        pLDDT_list = re.findall('ATOM\s+\d+\s+CA\s+.*?(\d+\.\d+)\s+[?:N|O|C]', data)

        if not pLDDT_list:  
          print(f"Warning: No pLDDT values found in {filename}")
          continue

        pLDDT_array = np.array(pLDDT_list, dtype=float)

        pdb_df = pd.DataFrame({
            'Number': np.arange(1, len(pLDDT_array) + 1),  # 1-based residue numbering
            'pLDDT': pLDDT_array
        })

        #if len(pLDDT_array) != len(old_df["RCI1"]):
        #  print(f"Skipping {filename}: Length mismatch ({len(pLDDT_array)} vs {len(old_df['RCI1'])})")
        #  continue

        #new_df = pd.DataFrame({'RCI': old_df["RCI1"], 'pLDDT': pLDDT_array})

        new_df = pd.merge(old_df, pdb_df, on='Number', how='left')
        
        correlation = new_df['RCI'].corr(new_df['pLDDT'], method='spearman')
        print(filename, correlation)

      except Exception as e:
        print(f"Error processing {filename}: {e}")      
        



