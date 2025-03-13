import os
import sys
import re
import subprocess


# Set RPF executable path
RPFcommand = "/Users/janet/Box/Montelione-Lab-Box/DoubleRecall/ASDP_develop-CA/bin/rpf"

if len(sys.argv) < 4:
    print("Usage: python runRPF.py <control-file> <input_ESmodels> <output_RPFdirectory>")
    sys.exit(1) 

control_file = sys.argv[1]
input_dir = sys.argv[2]
output_dir = sys.argv[3]

    
os.makedirs(output_dir, exist_ok=True)

for root, dirs, files in os.walk(input_dir):  
    for filename in files:
        if re.search(r"pdb$", filename):

            print(f"Processing: {filename}")

            output_file = os.path.join(output_dir, filename)
            
            if not os.path.exists(output_file): #only do the calculaition for new structures
                fn = os.path.abspath(os.path.join(root, filename))

                cmd = [
                    RPFcommand,
                    "-c", control_file,
                    "-o", output_file,
                    "-q", fn,
                ]
                
                print("Running command:", " ".join(cmd))
                subprocess.call([" ".join(cmd)], shell = True)
            else:
                print(f"{filename} found. skipping the calculation") 
