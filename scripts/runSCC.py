import os
import re
import numpy as np
import pandas as pd

old_df = pd.read_csv("RCI1.csv")
for root, dirs, files in os.walk("ESmodels"):  
  for filename in files:
    if re.search(r"\_new.pdb$", filename):
      fn = os.path.abspath(os.path.join(root, filename))  
      with open(fn, 'r') as file:
        data = file.read()
        pLDDT_list = re.findall('ATOM\s+\d+\s+CA\s+.*?(\d+\.\d+)\s+[N|O|C]', data)

        pLDDT_array = np.array(pLDDT_list, dtype=float)

        new_df = pd.DataFrame({'RCI': old_df["RCI1"], 'pLDDT': np.concatenate((pLDDT_array[0:55],pLDDT_array[55:110]))})
        
        print(filename, new_df['RCI'].corr(new_df['pLDDT'], method='spearman'))
      
        



