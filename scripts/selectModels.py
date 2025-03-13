#!python

import pandas as pd
import numpy as np
import string
import os
import shutil
import glob
import sys
import argparse

def print_usage():
    """Prints usage instructions for the script."""
    print("\nUsage: python selectModels.py <score_file> <dir_source> <selectedModels_dir>")
    print("\nArguments:")
    print("  <score_file>         Path to the scores file (e.g., scores.all)")
    print("  <dir_source>         Directory containing .pdb ESmodels")
    print("  <selectedModels_dir> Directory to save selected models")
    print("\nExample:")
    print("  python selectModels.py scores.all ESmodels/ selectedModels/")
    sys.exit(1)

# Check for --help or incorrect usage
if "--help" in sys.argv or "-h" in sys.argv:
    print_usage()

# Ensure correct number of arguments
if len(sys.argv) != 4:
    print("Error: Incorrect number of arguments.")
    print_usage()


score_file = sys.argv[1]
dir_source = sys.argv[2]
selectedModels_dir = sys.argv[3]

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
    print("\ncluster:", c, len(cluster[c]))
    print(cluster_sorted[c].to_string())

df = pd.DataFrame({
    'cluster': list(cluster_score.keys()),
    'score': list(cluster_score.values())
})

df.sort_values(by='score', inplace=True, ascending=False)
letters = list(string.ascii_lowercase[:len(df)])
df['state'] = letters

print()
print(df)

for row in df.itertuples():
    state = row.state
    cluster = row.cluster

    # Create directory based on state and cluster
    dir_path = f"{selectedModels_dir}/{state}{cluster}"
    os.makedirs(dir_path, exist_ok=True)  # Make directory if it doesn't exist
    
    # Copy files (assuming cluster_sorted is a dictionary with the data)
    print()
    for c in range(0, 5):
      try: 
        source_pattern1 = os.path.join(dir_source, f"*{cluster_sorted[row.cluster].iloc[c]['MODEL']}.pdb")  # Pattern with wildcards
        source_pattern2 = os.path.join(dir_source, f"*{cluster_sorted[row.cluster].iloc[c]['MODEL']}_new.pdb")
        
        destination = os.path.join(dir_path, f"{state}{cluster}_{str(c+1)}.pdb")  # Destination path

        # Use glob to find files matching the pattern
        matching_files = glob.glob(source_pattern1) + glob.glob(source_pattern2)

        if (len(matching_files) > 1):
            print(f"too many files matched: {matching_files}")
            sys.exit(1)
        # Copy each matching file to the destination
        shutil.copy(matching_files[0], destination)
        print(f"Copying {matching_files[0]} to {destination}")
  
      except IndexError:
        print(f"Error: Not enough models in cluster {cluster} (index {c} out of range)")
        continue
