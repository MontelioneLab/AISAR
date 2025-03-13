import os
import sys
import re
import subprocess

fromDir = sys.argv[1]
mergedDir = sys.argv[2]

os.makedirs(mergedDir, exist_ok=True)

for root, dirs, files in os.walk(fromdir):  
  for filename in files:
    if re.search(r"\.pdb$", filename):
       fn = os.path.abspath(os.path.join(root, filename))  
       cmd = "python mergeChain.py < {fn}  > {mergedDir}/{filename}" 
       print(cmd)
       subprocess.call([cmd], shell = True)

