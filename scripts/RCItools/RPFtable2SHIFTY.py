#!python

import sys

if len(sys.argv) < 2:
    print("Usage: python RPFtable2SHIFTY.py <filename>")
    sys.exit(1)

filename = sys.argv[1]

cs_result_AA={}
cs_result_HA={}
cs_result_HN={}
cs_result_N15={}
cs_result_CA={}
cs_result_CB={}
cs_result_CO={}

d = {'CYS': 'C', 'ASP': 'D', 'SER': 'S', 'GLN': 'Q', 'LYS': 'K',
     'ILE': 'I', 'PRO': 'P', 'THR': 'T', 'PHE': 'F', 'ASN': 'N', 
     'GLY': 'G', 'HIS': 'H', 'LEU': 'L', 'ARG': 'R', 'TRP': 'W', 
     'ALA': 'A', 'VAL':'V', 'GLU': 'E', 'TYR': 'Y', 'MET': 'M'}


try:
    with open(filename, 'r') as file:
        cs_result = [line.strip().split() for line in file.readlines()]

except FileNotFoundError:
    print(f"Error: The file '{filename}' was not found.")
except Exception as e:
    print(f"An error occurred: {e}")

    
for cs_result_row in cs_result:
    atom_ID = cs_result_row[3]
    seq_ID = cs_result_row[1]
    Comp_ID = cs_result_row[2]
    Val = cs_result_row[5]

    cs_result_AA[seq_ID] = d[Comp_ID]
    if (atom_ID == 'H'):
        cs_result_HN[seq_ID] = Val
    if (atom_ID == 'HA'):
        cs_result_HA[seq_ID] = Val
    if (atom_ID == 'N'):
        cs_result_N15[seq_ID] = Val
    if (atom_ID == 'CA'):
        cs_result_CA[seq_ID] = Val
    if (atom_ID == 'CB'):
        cs_result_CB[seq_ID] = Val
    if (atom_ID == 'C'):
        cs_result_CO[seq_ID] = Val
        
print("#NUM AA HA CA CB CO N HN")
for key in cs_result_AA:
    cs_list = [key, cs_result_AA[key], str(cs_result_HA.get(key, 0.00)), str(cs_result_CA.get(key, 0.00)), str(cs_result_CB.get(key, 0.00)), str(cs_result_CO.get(key, 0.00)), str(cs_result_N15.get(key, 0.00)), str(cs_result_HN.get(key, 0.00))]
    print(' '.join(cs_list))

