#!python

import os
import sys
import re

def print_usage():
    """Prints usage instructions for the script."""
    print("\nUsage: python groupModels.py <dir> ")
    print("\nArguments:")
    print("  <dir>         Directory containing .pdb ")
    print("\nExample:")
    print("  python groupModels.py selectedModels/a1")
    sys.exit(1)

# Check for --help or incorrect usage
if "--help" in sys.argv or "-h" in sys.argv:
    print_usage()

# Ensure correct number of arguments
if len(sys.argv) != 2:
    print("Error: Incorrect number of arguments.")
    print_usage()

dir2group = sys.argv[1]
newfname = dir2group + ".pdb"
num = 0
with open(newfname, "w") as OF: 
    for root, dirs, files in os.walk(dir2group):
        for filename in sorted(files):
            if re.search(r"\.pdb$", filename):
                fn = os.path.abspath(os.path.join(root, filename))  
                with open(fn, 'r') as IF:
                    num +=1
                    print("MODEL     ", num, file=OF)
                    for line in IF:
                        # here we discard any MODEL or END present in the lines, only
                        # look for the ATOM or TER records and store them for later
                        if line.startswith("ATOM") or line.startswith("REMARK") or line.startswith("TER"):
                            print("%s  " % line.strip(), file=OF)
                    print("ENDMDL", file=OF)
    print("END", file=OF)
