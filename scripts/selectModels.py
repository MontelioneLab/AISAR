#!python

import pandas as pd
import numpy as np
import string
import os
import shutil
import glob
import sys
import argparse


score_file = sys.argv[1]
dir_source = sys.argv[2]
pdbname_postfix = sys.argv[3]

print("#Command-line arguments: " + " ".join(sys.argv))

scoresAll_df = pd.read_csv(score_file, sep="\s+")

scoresAll_df['Score'] = (np.sqrt(scoresAll_df['pTM']*(scoresAll_df['Recall']-scoresAll_df['Recall'].min())/(scoresAll_df['Recall'].max()-scoresAll_df['Recall'].min()))+np.sqrt(scoresAll_df['pLDDT']/100*scoresAll_df['SCC']*-1))/2

cluster = {}
cluster_sorted = {}
cluster_score = {}

for c in range(scoresAll_df['Cluster'].min(), scoresAll_df['Cluster'].max()+1):
    cluster[c] = scoresAll_df.loc[scoresAll_df['Cluster'] == c]
    cluster_sorted[c] = cluster[c].sort_values(by=['Score'], ascending=False).head(5)
    cluster_score[c] = cluster_sorted[c]['Score'].mean()
    print("cluster:", c, len(cluster[c]))
    print(cluster_sorted[c].to_string())

df = pd.DataFrame({
    'cluster': list(cluster_score.keys()),
    'score': list(cluster_score.values())
})

df.sort_values(by='score', inplace=True, ascending=False)
letters = list(string.ascii_lowercase[:len(df)])
df['state'] = letters

print(df)

for row in df.itertuples():
    state = row.state
    cluster = row.cluster

    # Create directory based on state and cluster
    dir_path = f"selectedModels/{state}{cluster}"
    os.makedirs(dir_path, exist_ok=True)  # Make directory if it doesn't exist
    
    # Copy files (assuming cluster_sorted is a dictionary with the data)
    for c in range(0, 5):
        source_pattern = os.path.join(dir_source, f"*{cluster_sorted[row.cluster].iloc[c, 0]}" + pdbname_postfix)  # Pattern with wildcards
        destination = os.path.join(dir_path, f"{state}{cluster}_{str(c+1)}.pdb")  # Destination path

        # Use glob to find files matching the pattern
        matching_files = glob.glob(source_pattern)

        # Copy each matching file to the destination
        for source_file in matching_files:
            shutil.copy(source_file, destination)
            print(f"Copied {source_file} to {destination}")
  

    
