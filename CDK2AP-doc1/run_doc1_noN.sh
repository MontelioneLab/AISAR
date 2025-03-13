#!/bin/bash
#SBATCH --gres=gpu:4
#SBATCH --nodes=1
source /gpfs/u/barn/PMAR/shared/etc/231_alphaFOLD

sh ../scripts/enhancedSampling/run_afsample6000.sh doc1_noN.fasta

