#!/bin/bash
#SBATCH --job-name=hd_proj   # nom du job
##SBATCH --partition=gpu_p2          # de-commente pour la partition gpu_p2
#SBATCH --ntasks=1                   # nombre total de tache MPI (= nombre total de GPU)
#SBATCH --ntasks-per-node=1          # nombre de tache MPI par noeud (= nombre de GPU par noeud)
#SBATCH --gres=gpu:1                 # nombre de GPU par n?~Sud (max 8 avec gpu_p2)
#SBATCH --cpus-per-task=10           # nombre de coeurs CPU par tache (un quart du noeud ici)
#SBATCH -C v100-32g 
# /!\ Attention, "multithread" fait reference a l'hyperthreading dans la terminologie Slurm
#SBATCH --hint=nomultithread         # hyperthreading desactive
#SBATCH --time=20:00:00              # temps d'execution maximum demande (HH:MM:SS)
#SBATCH --output=hd_proj%j.out  # nom du fichier de sortie
#SBATCH --error=hd_proj%j.err   # nom du fichier d'erreur (ici commun avec la sortie)
#SBATCH -A ynx@gpu                   # specify the project
##SBATCH --qos=qos_gpu-dev            # using the dev queue, as this is only for profiling
#SBATCH --array=0-19

# nettoyage des modules charges en interactif et herites par defaut
module purge

# chargement des modules
module load tensorflow-gpu/py3/2.7.0

# echo des commandes lancees
set -x

opt[0]="--id_name _2_cycles_256_hd_proj_eval_param_0 --reset_dd_features False --total_cycles 2 --saved_cycle cycle2"
opt[1]="--id_name _2_cycles_256_hd_proj_eval_param_1 --reset_dd_features False --total_cycles 2 --saved_cycle cycle2"
opt[2]="--id_name _2_cycles_256_hd_proj_eval_param_2 --reset_dd_features False --total_cycles 2 --saved_cycle cycle2"
opt[3]="--id_name _2_cycles_256_hd_proj_eval_param_3 --reset_dd_features False --total_cycles 2 --saved_cycle cycle2"
opt[4]="--id_name _2_cycles_256_hd_proj_eval_param_4 --reset_dd_features False --total_cycles 2 --saved_cycle cycle2"

opt[5]="--id_name _2_cycles_256_hd_proj_reset_eval_param_0 --reset_dd_features True --total_cycles 2 --saved_cycle cycle2"
opt[6]="--id_name _2_cycles_256_hd_proj_reset_eval_param_1 --reset_dd_features True --total_cycles 2 --saved_cycle cycle2"
opt[7]="--id_name _2_cycles_256_hd_proj_reset_eval_param_2 --reset_dd_features True --total_cycles 2 --saved_cycle cycle2"
opt[8]="--id_name _2_cycles_256_hd_proj_reset_eval_param_3 --reset_dd_features True --total_cycles 2 --saved_cycle cycle2"
opt[9]="--id_name _2_cycles_256_hd_proj_reset_eval_param_4 --reset_dd_features True --total_cycles 2 --saved_cycle cycle2"

opt[10]="--id_name _5_cycles_256_hd_proj_eval_param_0 --reset_dd_features False --total_cycles 5 --saved_cycle cycle5"
opt[11]="--id_name _5_cycles_256_hd_proj_eval_param_1 --reset_dd_features False --total_cycles 5 --saved_cycle cycle5"
opt[12]="--id_name _5_cycles_256_hd_proj_eval_param_2 --reset_dd_features False --total_cycles 5 --saved_cycle cycle5"
opt[13]="--id_name _5_cycles_256_hd_proj_eval_param_3 --reset_dd_features False --total_cycles 5 --saved_cycle cycle5"
opt[14]="--id_name _5_cycles_256_hd_proj_eval_param_4 --reset_dd_features False --total_cycles 5 --saved_cycle cycle5"

opt[15]="--id_name _5_cycles_256_hd_proj_reset_eval_param_0 --reset_dd_features True --total_cycles 5 --saved_cycle cycle5"
opt[16]="--id_name _5_cycles_256_hd_proj_reset_eval_param_1 --reset_dd_features True --total_cycles 5 --saved_cycle cycle5"
opt[17]="--id_name _5_cycles_256_hd_proj_reset_eval_param_2 --reset_dd_features True --total_cycles 5 --saved_cycle cycle5"
opt[18]="--id_name _5_cycles_256_hd_proj_reset_eval_param_3 --reset_dd_features True --total_cycles 5 --saved_cycle cycle5"
opt[19]="--id_name _5_cycles_256_hd_proj_reset_eval_param_4 --reset_dd_features True --total_cycles 5 --saved_cycle cycle5"

# --cycle_def non-parametric to only train non-param model.

cd $WORK/repos/wf-SEDs/HD_projected_optimisation/scripts/

srun python -u ./train_project_click_multi_cycle.py \
    --eval_only_param True \
    --project_dd_features True \
    --d_max 2 \
    --n_zernikes 45 \
    --save_all_cycles True \
    --n_bins_lda 8 \
    --opt_stars_rel_pix_rmse True \
    --pupil_diameter 256 \
    --n_epochs_param_multi_cycle "0" \
    --n_epochs_non_param_multi_cycle "75" \
    --l_rate_non_param_multi_cycle "0.1" \
    --l_rate_param_multi_cycle "0" \
    --model poly \
    --model_eval poly \
    --cycle_def complete \
    --gt_n_zernikes 45 \
    --d_max_nonparam 5 \
    --saved_model_type checkpoint \
    --use_sample_weights True \
    --l2_param 0. \
    --interpolation_type none \
    --eval_batch_size 16 \
    --train_opt True \
    --eval_opt True \
    --plot_opt True \
    --dataset_folder /gpfswork/rech/ynx/uds36vp/datasets/interp_SEDs/ \
    --test_dataset_file test_Euclid_res_id_009_8_bins.npy \
    --train_dataset_file train_Euclid_res_2000_TrainStars_id_009_8_bins_sigma_0.npy \
    --plots_folder plots/ \
    --base_path /gpfswork/rech/ynx/uds36vp/repos/wf-SEDs/HD_projected_optimisation/wf-outputs/ \
    --metric_base_path /gpfswork/rech/ynx/uds36vp/repos/wf-SEDs/HD_projected_optimisation/wf-outputs/metrics/ \
    --chkp_save_path /gpfswork/rech/ynx/uds36vp/repos/wf-SEDs/HD_projected_optimisation/wf-outputs/chkp/8_bins/ \
    --model_folder chkp/8_bins/ \
    --log_folder log-files/ \
    --optim_hist_folder optim-hist/ \
    --base_id_name _ \
    --suffix_id_name 2_cycles_256_hd_proj_eval_param_0 --suffix_id_name 2_cycles_256_hd_proj_eval_param_1 --suffix_id_name 2_cycles_256_hd_proj_eval_param_2 --suffix_id_name 2_cycles_256_hd_proj_eval_param_3 --suffix_id_name 2_cycles_256_hd_proj_eval_param_4 --suffix_id_name 2_cycles_256_hd_proj_reset_eval_param_0 --suffix_id_name 2_cycles_256_hd_proj_reset_eval_param_1 --suffix_id_name 2_cycles_256_hd_proj_reset_eval_param_2 --suffix_id_name 2_cycles_256_hd_proj_reset_eval_param_3 --suffix_id_name 2_cycles_256_hd_proj_reset_eval_param_4 --suffix_id_name 5_cycles_256_hd_proj_eval_param_0 --suffix_id_name 5_cycles_256_hd_proj_eval_param_1 --suffix_id_name 5_cycles_256_hd_proj_eval_param_2 --suffix_id_name 5_cycles_256_hd_proj_eval_param_3 --suffix_id_name 5_cycles_256_hd_proj_eval_param_4 --suffix_id_name 5_cycles_256_hd_proj_reset_eval_param_0 --suffix_id_name 5_cycles_256_hd_proj_reset_eval_param_1 --suffix_id_name 5_cycles_256_hd_proj_reset_eval_param_2 --suffix_id_name 5_cycles_256_hd_proj_reset_eval_param_3 --suffix_id_name 5_cycles_256_hd_proj_reset_eval_param_4 \
    --star_numbers 0 --star_numbers 1 --star_numbers 2 --star_numbers 3 --star_numbers 4 --star_numbers 5 --star_numbers 6 --star_numbers 7 --star_numbers 8 --star_numbers 9 --star_numbers 10 --star_numbers 11 --star_numbers 12 --star_numbers 13 --star_numbers 14 --star_numbers 15 --star_numbers 16 --star_numbers 17 --star_numbers 18 --star_numbers 19 \
    ${opt[$SLURM_ARRAY_TASK_ID]} \

## --star_numbers is for the final plot's x-axis. 