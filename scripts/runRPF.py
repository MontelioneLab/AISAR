import os
import re
import subprocess


os.makedirs("rpfESmodels", exist_ok=True)

for root, dirs, files in os.walk("../../../CDK2AP-doc1/ESmodels"):  
    for filename in files:
        if re.search(r"relaxed", filename):
            print(filename)
            if not os.path.exists("rpfESmodels/" + filename): #only do the calculaition for new structures
                fn = os.path.abspath(os.path.join(root, filename))
                cmd = "/Users/janet/Box/Montelione-Lab-Box/DoubleRecall/ASDP_develop-CA/bin/rpf -c Input/control_RPF -o rpfESmodels/" + filename + " -q " + fn
                print(cmd)
                subprocess.call([cmd], shell = True)
            else:
                print("{filename} found. skip the calculation") 
