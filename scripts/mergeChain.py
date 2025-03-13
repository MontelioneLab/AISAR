#!python

import sys

for line in sys.stdin:
    if 'TER' in line:
        continue
    if 'ATOM' in line:
        if line[21] == 'B':
            seqnum = line[23:26]
            #print(seqnum)
            new = int(seqnum)+200
            line = line[:21] + "A" + " " + str(new) + line[26:]
    print(line.strip())
        
                
            
