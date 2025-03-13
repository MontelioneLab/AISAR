import os
import re
import numpy as np

for root, dirs, files in os.walk("ESmodels"):  
    for filename in files:
         if re.search(r"^relaxed[\w\_]*\.pdb$", filename):
                fn = os.path.abspath(os.path.join(root, filename))  

                with open(fn, 'r') as file:
                    data = file.read()
                    pLDDT_list = re.findall('ATOM\s+\d+\s+CA\s+.*?(\d+\.\d+)\s+[N|O|C]', data)
                    pLDDT_array = np.array(pLDDT_list, dtype=float)
                    print(filename, pLDDT_array.mean())

