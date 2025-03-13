import pynmrstar
import sys

if len(sys.argv) < 2:
    print("Usage: python nmrstat3SHIFTY-fromBMRB.py <bmrbID>")
    sys.exit(1)

bmrbID = sys.argv[1]


entry = pynmrstar.Entry.from_database(bmrbID)

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

for chemical_shift_loop in entry.get_loops_by_category("_Atom_chem_shift"):
    cs_result = chemical_shift_loop.get_tag(['Entity_ID','seq_ID', 'Comp_ID', 'Atom_ID', 'Val'])

    for cs_result_row in cs_result:
        atom_ID = cs_result_row[3]
        seq_ID = cs_result_row[1]
        Comp_ID = cs_result_row[2]
        Val = cs_result_row[4]

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
        
#print(cs_result_sets)
print("#NUM AA HA CA CB CO N HN")
for key in cs_result_AA:
    cs_list = [key, cs_result_AA[key], str(cs_result_HA.get(key, 0.00)), str(cs_result_CA.get(key, 0.00)), str(cs_result_CB.get(key, 0.00)), str(cs_result_CO.get(key, 0.00)), str(cs_result_N15.get(key, 0.00)), str(cs_result_HN.get(key, 0.00))]
    print(' '.join(cs_list))

