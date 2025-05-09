import os
import re
import numpy as np
import pandas as pd
import sys


if len(sys.argv) < 3:
    print("Usage: python getRCIpLDDT.py <RCI.csv> <AFDir>")
    sys.exit(1)


rci_file = sys.argv[1]
AFmodels_dir = sys.argv[2]

rci_df = pd.read_csv(rci_file)


first = True
new_df = None

for root, dirs, files in os.walk(AFmodels_dir):  
  for filename in sorted(files):
    if re.search(r"\d.pdb$", filename):
      print("reading", filename)
      fn = os.path.abspath(os.path.join(root, filename))  
      with open(fn, 'r') as file:
        data = file.read()
        pLDDT_list = re.findall('ATOM\s+\d+\s+CA\s+[a-zA-Z]+\s+A\s+(\d+)\s+.*?(\d+\.\d+)\s+[N|O|C]', data)
        #print(pLDDT_list, len(pLDDT_list))

        pLDDT_array = np.array(pLDDT_list, dtype=float)

        if first:
          new_df = pd.DataFrame(pLDDT_list, columns=['Number', filename])
          new_df = pd.concat([new_df, rci_df], axis=1)
          first = False
        else:
          new_df[filename] = pd.Series(pLDDT_array[:,1])
          
new_df.to_csv(f"RCI_pLDDT_{AFmodels_dir}.csv")      



