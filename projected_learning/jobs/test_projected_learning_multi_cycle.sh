#!/bin/bash
#SBATCH --job-name=test_project   # nom du job
##SBATCH --partition=gpu_p2          # de-commente pour la partition gpu_p2
#SBATCH --ntasks=1                   # nombre total de tache MPI (= nombre total de GPU)
#SBATCH --ntasks-per-node=1          # nombre de tache MPI par noeud (= nombre de GPU par noeud)
#SBATCH --gres=gpu:1                 # nombre de GPU par n?~Sud (max 8 avec gpu_p2)
#SBATCH --cpus-per-task=10           # nombre de coeurs CPU par tache (un quart du noeud ici)
#SBATCH -C v100-32g 
# /!\ Attention, "multithread" fait reference a l'hyperthreading dans la terminologie Slurm
#SBATCH --hint=nomultithread         # hyperthreading desactive
#SBATCH --time=20:00:00              # temps d'execution maximum demande (HH:MM:SS)
#SBATCH --output=test_project%j.out  # nom du fichier de sortie
#SBATCH --error=test_project%j.err   # nom du fichier d'erreur (ici commun avec la sortie)
#SBATCH -A ynx@gpu                   # specify the project
##SBATCH --qos=qos_gpu-dev            # using the dev queue, as this is only for profiling
#SBATCH --array=0-1

# nettoyage des modules charges en interactif et herites par defaut
module purge

# chargement des modules
module load tensorflow-gpu/py3/2.7.0

# echo des commandes lancees
set -x

# n_bins ---> number of points per SED (n_bins + 1)
opt[0]="--n_bins_lda 8 --test_dataset_file test_Euclid_res_id_009_8_bins.npy --train_dataset_file train_Euclid_res_2000_TrainStars_id_009_8_bins_sigma_0.npy --id_name _project_mc_8_bins --chkp_save_path /gpfswork/rech/ynx/uds36vp/repos/wf-SEDs/projected_learning/wf-outputs/chkp/8_bins/ --model_folder chkp/8_bins"
opt[1]="--n_bins_lda 17 --test_dataset_file test_Euclid_res_id_009_16_bins.npy --train_dataset_file train_Euclid_res_2000_TrainStars_id_009_16_bins_sigma_0.npy --id_name _project_mc_16_bins --chkp_save_path /gpfswork/rech/ynx/uds36vp/repos/wf-SEDs/projected_learning/wf-outputs/chkp/16_bins/ --model_folder chkp/16_bins"
# opt[2]="--n_bins_lda 33 --test_dataset_file test_Euclid_res_id_009_32_bins.npy --train_dataset_file train_Euclid_res_2000_TrainStars_id_009_32_bins_sigma_0.npy --id_name _project_32_bins --chkp_save_path /gpfswork/rech/ynx/uds36vp/repos/wf-SEDs/projected_learning/wf-outputs/chkp/32_bins/"

cd $WORK/repos/wf-SEDs/projected_learning/scripts/

srun python -u ./train_project_click_multi_cycle.py \
    --project_dd_features True \
    --project_last_cycle True \
    --plot_opt False \
    --opt_stars_rel_pix_rmse False \
    --pupil_diameter 256 \
    --n_epochs_param_multi_cycle "15 10 10 10" \
    --n_epochs_non_param_multi_cycle "50 50 30 20" \
    --l_rate_non_param_multi_cycle "0.1 0.1 0.06 0.06" \
    --l_rate_param_multi_cycle "0.01 0.01 0.004 0.004" \
    --total_cycles 4 \
    --saved_cycle cycle4 \
    --model poly \
    --model_eval poly \
    --cycle_def complete \
    --n_zernikes 15 \
    --gt_n_zernikes 45 \
    --d_max_nonparam 5 \
    --saved_model_type checkpoint \
    --use_sample_weights True \
    --l2_param 0. \
    --interpolation_type none \
    --eval_batch_size 16 \
    --train_opt True \
    --eval_opt True \
    --dataset_folder /gpfswork/rech/ynx/uds36vp/datasets/interp_SEDs/ \
    --plots_folder plots/ \
    --base_path /gpfswork/rech/ynx/uds36vp/repos/wf-SEDs/projected_learning/wf-outputs/ \
    --metric_base_path /gpfswork/rech/ynx/uds36vp/repos/wf-SEDs/projected_learning/wf-outputs/metrics/ \
    --log_folder log-files/ \
    --optim_hist_folder optim-hist/ \
    --base_id_name _project_mc_ \
    --suffix_id_name 8_bins --suffix_id_name 16_bins \
    --star_numbers 8 --star_numbers 16 \
    ${opt[$SLURM_ARRAY_TASK_ID]} \

## --star_numbers is for the final plot's x-axis. 