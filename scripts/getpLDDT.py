import os
import re
import sys
import numpy as np

if len(sys.argv) < 2:
    print("Usage: python getpLDDT.py <ESmodels_directory>")
    sys.exit(1)

models_dir = sys.argv[1] 

for root, dirs, files in os.walk(models_dir):  
    for filename in files:
         if filename.endswith(".pdb"):
                fn = os.path.abspath(os.path.join(root, filename))  

                with open(fn, 'r') as file:
                    data = file.read()
                    pLDDT_list = re.findall('ATOM\s+\d+\s+CA\s+.*?(\d+\.\d+)\s+[N|O|C]', data)
                    pLDDT_array = np.array(pLDDT_list, dtype=float)
                    print(filename, pLDDT_array.mean())

