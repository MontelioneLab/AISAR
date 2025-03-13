#!/usr/bin/env python

import os
import sys

tmp = ""
tmp_wd = ""
tmpname = ""
inDir = "."     # directory to get the files from
outDir = "."    # directory to ouput the files
fname = ""      # File name to work on
Energy = []     # store energies
Names = []      # store file names
Filter = []     # stores filetered out model names
Logfile = ""    # log file to extract info from
kind = ""       # kind of input, RTT or AF2/AF_sample
relax = 0       # work on relaxed models
debug = 0       # default debug level, 0
ranges = []     # well defined to trim for filtering
chain = ""
Finalfiles = []
Filteredfiles = []
Ei = 0.0
Ef = 0.0
viol = 0
excl = 0
Ei_cut = 1.0e30
Ef_cut = 1.0e30

# Show description and usage.
sname = os.path.basename(__file__)
if len(sys.argv) < 4 or sys.argv[1] == "-h":
    print("\n")
    print("\t  **", sname, "(RTT, 2024) \n")
    print("\t  Python script to extract/filter energy data from AF2 output and paste the energy along with ")
    print("\t       the name of the model on REMARK records for future reference in checking or cleaning ")
    print("\t       It creates outDir if requested. If not will dump results on current directory so, I  ")
    print("\t       recommend to use always an outDir for holding the files (AF2_sample usually 6000)    ")
    print("\n")
    print("\t  (1) - If using slurm output (i.e from queue system) the final files are appended with af2 ")
    print("\t      - If using local output (i.e. local relax) the final files are appended with rtt      ")
    print("\t      - If not given -relax nor -unrelax, it will run automatically for both cases          ")
    print("\t  (2) outDir will hold: ")
    print("\t      - the unrelax or relax models from inDir ")
    print("\t  (3) Current dir will hold: ")
    print("\t      - (a) multimodel file with all models grouped together (ex. Good_relax_af2.pdb)       ")
    print("\t      - (b) multimodel file with all *filtered* out models (ex. Filtered_out_relax_rtt.pdb) ")
    print("\t      - (c) text file with a list of filtered out models (ex. Filteredout_unrelax_rtt.txt)  ")
    print("\t      - (d) text file with a list of \"good\" models names  (ex. List_good_urelax_rtt.txt)  ")
    print("\t  (4) If not -relax nor -unrelax given, both sets (relaxed and unrelaxed) worked in turn  \n")
    print("\t USAGE:\t", sname, "-log logFile -inD SomeDir -outD SomeOtherDir -deb <int> -relax|-unrelax  \n")
    print("\t ARGUMENTS: ")
    print("\t\t -help          \t ( displays this text help message                        ) ")
    print("\t\t -log  <string> \t ( log_file to use either from slurm (af2) or local (rtt) ) ")
    print("\t\t -inD  <string> \t ( directory path to take input coords from    )             ")
    print("\t\t -outD <string> \t ( directory path to put the filtered output   )             ")
    print("\t\t -well <string> \t ( well defined to trim, ex: A20..A98,B2..B52  )             ")
    print("\t\t -Ei   <float>  \t ( cutoff for initial E filtering [def 1.0e30] )             ")
    print("\t\t -Ef   <float>  \t ( cutoff for final E filtering   [def 1.0e30] )             ")
    print("\t\t -rel           \t ( pick only relaxed models to work wwith      )             ")
    print("\t\t -unre          \t ( pick only unrelaxed models to work with     )             ")
    print("\t\t -deb  <int>    \t ( level of debug info, from 1-10              )           \n")
    print("\t Examples: ")
    print("\t\t", sname, "-log Log -inD ../StoredModels -outD Filtered -relax ")
    print("\t\t", sname, "-log Log -well A20..A90,B2..B54 -inD Inpurdir -outD Results -unrelax ")
    print("\n")
    exit

# -- analyze args in command line
x = 0
while x < len(sys.argv):
    if "-l" in sys.argv[x] :       # Log file
        x += 1
        Logfile = sys.argv[x]
    elif "-re" in sys.argv[x] :    # pick relaxed models
        relax = 1
    elif "-un" in sys.argv[x] :    # pick unrelaxed models
        relax = -1
    elif "-in" in sys.argv[x] :    # directory to get the files from
        x += 1
        inDir = sys.argv[x]
    elif "-ou" in sys.argv[x] :    # directory to put the files out
        x += 1
        outDir = sys.argv[x]
    elif "-Ei" in sys.argv[x] :    # cutoff to filter initial E (def 1.0e15)
        x += 1
        Ei_cut = float(sys.argv[x])
    elif "-Ef" in sys.argv[x] :    # cutoff to filter final E (def 1.0)
        x += 1
        Ef_cut = float(sys.argv[x])
    elif "-we" in sys.argv[x] :    # well defined ranges for trimming
        x += 1
        tmp_wd = sys.argv[x]
    elif "-de" in sys.argv[x] :    # debug level [def 0]
        x += 1
        debug = int(sys.argv[x])
    x += 1

## --------------- subroutines ----------------
# -- Do final filtering and writing of files.
def GetEnergies(relax, kind):
    global tmpname, Finalfiles, Filteredfiles
    tmpname = ""
    notgood = ""
    avoid = 0
    FromName = ""
    FinalName = ""
    fname = ""
    okname = ""
    ivio = 0
    iexi = 0
    itot = 0
    iene = 0

    if relax < 0:
      FI = open("Filtered_out_unrelax_" + kind + ".txt", "w") 
      FO = open("List_good_unrelax_" + kind + ".txt", "w")
    else: 
      FI = open("Filtered_out_relax_" + kind + ".txt", "w")
      FO = open("List_good_relax_" + kind + ".txt", "w") 

    for idx in range(len(Names)):
        avoid = 0
        FromName = Names[idx]
        # -- Check that input file exists and is not zero size
        if relax < 0:
            FromName = FromName.replace("relaxed", "unrelaxed")
        okname = os.path.join(inDir, FromName)

        
        if not os.path.isfile(okname) or os.path.getsize(okname) == 0:
            print(os.path.isfile(okname))
            print(os.path.getsize(okname))
            iexi += 1
            # -- debug
            if debug >= 1:
                print(" *not found*", FromName, "does not exist or is zero size")
            continue
        fn, viol, excl, Ei, Ef = Filter[idx]
        if relax < 0:
           fn = fn.replace("relaxed", "unrelaxed") 
        if fn != FromName:
            print(" ** Record with diff name:", fn, FromName, file=FI)
        # -- adjusting FromName and FinalName to relax or unrelax
        FromName = FromName.replace(".pdb", "")
        fname = FromName
        FinalName = FromName + "_new.pdb"
        FromName = os.path.join(inDir, FromName + ".pdb")
        FinalName = os.path.join(outDir, FinalName)
        # -- Filter by residue violation/exclusion > 0
        if int(viol) > 0 or int(excl) > 0:
            ivio += 1
            Filteredfiles.append(FinalName)
            print(" *Filtered*  %-55s  [%3d %3d]" % (fn, int(viol), int(excl)), file=FI)
            #TrimPrint(FromName, FinalName, fname, idx)
            continue
        # -- Filter by energy
        if float(Ei) >= Ei_cut or float(Ef) >= Ef_cut:
            iene += 1
            Filteredfiles.append(FinalName)
            print(" *Filtered*", fn, "[%13.5e %13.5e]" % (float(Ei), float(Ef)), file=FI)
            #TrimPrint(FromName, FinalName, fname, idx)
            continue
        # -- final writing, adding Epot in REMARK
        fn = fname + "_new.pdb"
        print(fn, file=FO)
        #print(" FromName", FromName, "FinalName", FinalName, "fname", fname, file=FI)
        TrimPrint(FromName, FinalName, fname, idx)
        Finalfiles.append(FinalName)
        itot += 1
    FI.close()
    FO.close()
    # -- grouping models in a multimodel file
    AgrupaModels("final")
    #AgrupaModels("filtered")
    print(" Summary ------------------------------")
    print("%5d original files loaded" % len(Names))
    print("%5d final filtered models" % itot)
    print("%5d files were filtered out by viol/excl" % ivio)
    print("%5d files were filtered out by energy" % iene)
    print("%5d files were not found" % iexi)
    print("--------------------------------------")
    if debug >= 1:
        ir = 0
        for fname in Filter:
            ir += 1
            f, v, e, ei, ef = fname
            print(" **Filter record**", f, 
                  "[%3d %3d]" % (int(v), int(e)), 
                  "[%13.5e %13.5e]" % (float(Ei), float(Ef)))

# -- Trimming and printing file
def TrimPrint(FromName, FinalName, fnm, idx):
    OldName = ""
    with open(FromName, "r") as IN:
        with open(FinalName, "w") as RL:
            for line in IN:
                if line.startswith("MODEL"):
                    continue
                # -- trimming records to well-defined
                if line.startswith("ATOM"):
                    chain = line[21]
                    resno = int(line[23:27])
                    allow = 1
                    for t in ranges:
                        ch, rn1, rn2 = t
                        if chain == ch and (resno < rn1 or resno > rn2):
                            allow = -1
                    if allow < 0:
                        continue
                if OldName != FromName:
                    OldName = FromName
                    Eini, Efin = Energy[idx]
                    print("REMARK File: %s Epot: %13.5e" % (fnm,float(Efin)), file=RL)
                    print("REMARK Eini: %13.5e  Efin: %13.5e" % (float(Eini),float(Efin)), file=RL)
                    print("%s  " % line.strip(), file=RL)
                else:
                    print("%s  " % line.strip(), file=RL)

# -- Group all models into a single multimodel file
def AgrupaModels(final):
    OldF = ""
    At = []   # collection of ATOM records
    fnm = []  # file names
    Ff = []
    nm = 0    # number of models
    it = 0
    if final == "final":
        Allfname = "Good_relax_" + kind + ".pdb" if relax > 0 else "Good_unrelax_" + kind + ".pdb"
        Ff = Finalfiles
    else:
        Allfname = "Filtered_out_relax_" + kind + ".pdb" if relax > 0 else "Filtered_out_unrelax_" + kind + ".pdb"
        Ff = Filteredfiles
    with open(Allfname, "w") as OA:
        for f in Ff:
            with open(f, "r") as IF:
                if f != OldF:
                    OldF = f
                    nm += 1
                    print("MODEL     ", nm, file=OA)
                for line in IF:
                    # here we discard any MODEL or END present in the lines, only
                    # look for the ATOM or TER records and store them for later
                    if line.startswith("ATOM") or line.startswith("REMARK") or line.startswith("TER"):
                        print("%s  " % line.strip(), file=OA)
                print("ENDMDL", file=OA)
        print("END", file=OA)

# -- get ranges from well defined, if supplied
if tmp_wd != "":
    tmp_wd = tmp_wd.replace("..", " ")
    wd = tmp_wd.split(",")
    for rng in wd:
        r1, r2 = rng.split(" ")
        ch1 = r1[0]
        ch2 = r2[0]
        rn1 = int(r1[1:])
        rn2 = int(r2[1:])
        if ch1 == ch2:
            ranges.append((ch1, rn1, rn2))

# -- create directory, if asked, for ouput
if not os.path.exists(outDir):
    os.makedirs(outDir)

# -- load and extract info from log file.
#    it will try to detect if coming from AF2 or RTT
tmpname = ""
fname = "kkdevak"

if Logfile == '':
   sys.exit()

with open(Logfile, "r") as f :
    for line in f:
        if "Relaxed: " in line:  # coming from RTT output
            kind = "rtt"
            fname = line.split()[-1]
            tmpname = fname
            # -- debug
            if debug >= 5:
                print(" *debug* _RESULT_ found", kind, "fname:", fname)
        if ".pdb" in line and kind != "rtt":  # coming from AF2 output
            kind = "af2"
            fname = line.split("/")[-1].strip()
            print(fname)
            fname = fname.rstrip(" exists, delete if you want to return\.")
            tmpname = fname
            # -- debug
            if debug >= 5:
                print(" *debug* PDB found", kind, "fname:", fname)
        if "Iteration completed" in line:  # coming from AF2/AF_sample
            tmp = line
            # -- debug
            if debug >= 6:
                print(" *debug* Energy line:", tmp)
            Ei = line.split()[3]
            Ef = line.split()[5]
            viol = line.split()[12]
            excl = line.split()[16]
        if fname == tmpname:
            tmpname = ""
            Names.append(fname)
            Energy.append((Ei, Ef))
            Filter.append((fname, viol, excl, Ei, Ef))
            # -- debug
            if debug >= 3 and (int(viol) > 0 or int(excl) > 0):
                print(" *debug* Eini:", Ei, "Efin:", Ef, viol, excl, "for", fname)

# -- Summary info about used method
if relax == 0:
    # --  both, relax and unrelax, we make two runs, two calls to GetEnergies
    print(" Running for both urelaxed and relaxed models,", kind, "style")
    relax = 1
    print(" Running for relaxed models,", kind, "style")
    print(" Energy cutoff: Ei", Ei_cut, "Ef:", Ef_cut)
    GetEnergies(relax, kind)
    relax = -1
    print(" Running for unrelaxed models,", kind, "style")
    print(" Energy cutoff: Ei", Ei_cut, "Ef:", Ef_cut)
    GetEnergies(relax, kind)
else:  # -- only one, either relax or unrelaxe
    if relax > 0:
        print(" Running for relaxed models,", kind, "style")
    elif relax < 0:
        print(" Running for unrelaxed models,", kind, "style")
    print(" Energy cutoff: Ei", Ei_cut, "Ef:", Ef_cut)
    GetEnergies(relax, kind)

sys.exit()
