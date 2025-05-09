#!/bin/bash
#SBATCH --job-name=relaxBatch
#SBATCH --cpus-per-task=64
#SBATCH --mem=128G
#SBATCH --nodes=1
#SBATCH --output=logs/relax_batch_master.out

export OPENMM_DEFAULT_PLATFORM=CPU
export OPENMM_CPU_THREADS=16
export XLA_PYTHON_CLIENT_PREALLOCATE=false
export XLA_FLAGS=--xla_force_host_platform_device_count=64

source /gpfs/u/barn/PMAR/shared/etc/231_alphaFOLD

# === Input arguments ===
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <scores.sc file>"
    exit 1
fi

txt_file="$1"
AF_path=/gpfs/u/barn/PMAR/shared/local/alphafoldv2.2.0

N=6000
JOBS_AT_ONCE=4
COUNT=0

mkdir -p logs
logfile="logs/relax_combined.log"

for pkl in $(head -n $N "$txt_file" | awk '{print $2}'); do
    {
        echo "[START] Task $COUNT for $pkl at $(date)"
        python3 "$AF_path/run_relax_from_results_pkl.py" "$pkl"
        echo "[DONE] Task $COUNT for $pkl at $(date)"
    } 2>&1 | tee -a "$logfile" &

    ((COUNT++))
    if (( COUNT % JOBS_AT_ONCE == 0 )); then
        wait
    fi
done

wait
echo "All relaxation jobs completed at $(date)" >> "$logfile"
