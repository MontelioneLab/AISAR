import os
import sys
import re
import glob


if len(sys.argv) < 2:
    print("Usage: python getRPF.py <RPFdirectory>")
    sys.exit(1)

rpf_dir = sys.argv[1] 

for root, dirs, files in os.walk(rpf_dir):  
    for name in dirs:
        if name.endswith(".pdb"): 
            ovw_fileList = glob.glob(os.path.join(os.path.join(root, name), '*.ovw'))

            ovw_file = ovw_fileList[0]
            if not ovw_file:
                print(f"No .ovw file found for {name}.")
            else: 
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
