import os
import sys
import re
import glob
import shutil


if len(sys.argv) < 2:
    print("Usage: python getRPF.py <RPFdirectory>")
    sys.exit(1)

rpf_dir = sys.argv[1] 

for root, dirs, files in os.walk(rpf_dir):  
    for name in dirs:
        dir_path = os.path.join(root, name)
        if name.endswith(".pdb"):
            ovw_fileList = glob.glob(os.path.join(dir_path, '*.ovw'))

            if not ovw_fileList:
                print(name)
                print(f"Error: No .ovw file found for {name}.")
                print(f"Error: Remove this dir: {dir_path}.")
                shutil.rmtree(dir_path)
            else:
                ovw_file = ovw_fileList[0] 
                with open(ovw_file, 'r') as f:
                    text = f.read()
                    recall_match = re.search('Final Recall-score for input query structures: (\d\.\d\d)', text)
                    dp_match     = re.search('DP-Score: (-*\d.\d+)', text)
                    precision_match = re.search('Final Precision-score for input query structures: (\d\.\d\d)', text)

                    # Extract values or set "N/A" if not found
                    recall = recall_match.group(1) if recall_match else "N/A"
                    precision = precision_match.group(1) if precision_match else "N/A"
                    dp = dp_match.group(1) if dp_match else "N/A"

                    print(name, recall, precision, dp)
