import os
import re
import subprocess
import glob

for root, dirs, files in os.walk("rpfESmodels"):  
    for name in dirs:
        if re.search(r"\.pdb", name):
            ovw_file = glob.glob(os.path.join(os.path.join(root, name)), '*.ovw'))
            if not ovw_file:
                print("No .ovw file found.")
            else: 
                with open(ovw_file, 'r') as f:
                    text = f.read()
                    recall = re.search('Final Recall-score for input query structures: (\d\.\d\d)', text)
                    dp     = re.search('DP-Score: (-*\d.\d+)', text)
                    precision = re.search('Final Precision-score for input query structures: (\d\.\d\d)', text)
                    print(name, recall.group(1), precision.group(1), dp.group(1))
