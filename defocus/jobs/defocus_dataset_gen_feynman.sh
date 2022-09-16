#!/bin/bash
#SBATCH --job-name="Dataset Defocused observations"
#SBATCH --mail-user=ezequiel.centofanti@cea.fr
#SBATCH --mail-type=ALL
#SBATCH --partition=htc
#SBATCH --nodes=1
#SBATCH --array=1
#SBATCH --cpus-per-task=24
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --output=Defocus_gen-%j-%a.log

# Activate conda environment
module load anaconda
source activate $ANACONDA_DIR
conda activate tf-gpu

# Change location
cd /feynman/work/dap/lcs/ec270266/wf-SEDs/defocus/scripts/

# Run code
srun python gen-defocus_dataset_350.py $SLURM_ARRAY_TASK_ID

# Return exit code
exit 0
