#!/bin/bash
#SBATCH --job-name=param_ev_2_cycles_256_batch   # nom du job
##SBATCH --partition=gpu_p2          # de-commente pour la partition gpu_p2
#SBATCH --ntasks=1                   # nombre total de tache MPI (= nombre total de GPU)
#SBATCH --ntasks-per-node=1          # nombre de tache MPI par noeud (= nombre de GPU par noeud)
#SBATCH --gres=gpu:1                 # nombre de GPU par n?~Sud (max 8 avec gpu_p2)
#SBATCH --cpus-per-task=10           # nombre de coeurs CPU par tache (un quart du noeud ici)
#SBATCH -C v100-32g 
# /!\ Attention, "multithread" fait reference a l'hyperthreading dans la terminologie Slurm
#SBATCH --hint=nomultithread         # hyperthreading desactive
#SBATCH --time=05:00:00              # temps d'execution maximum demande (HH:MM:SS)
#SBATCH --output=param_ev_2_cycles_256_batch%j.out  # nom du fichier de sortie
#SBATCH --error=param_ev_2_cycles_256_batch%j.err   # nom du fichier d'erreur (ici commun avec la sortie)
#SBATCH -A ynx@gpu                   # specify the project
##SBATCH --qos=qos_gpu-dev            # using the dev queue, as this is only for profiling
#SBATCH --array=0-9

# nettoyage des modules charges en interactif et herites par defaut
module purge

# chargement des modules
module load tensorflow-gpu/py3/2.7.0

# echo des commandes lancees
set -x

# load the no_proj trained models and evaluate only the parametric part, projecting the non-param part befor evaluating the model.
opt[0]="--id_name _2_cycles_256_eval_param_no_proj_proj_end_d2_45z_0 --n_zernikes 45 --chkp_save_path /gpfswork/rech/ynx/uds36vp/repos/wf-SEDs/HD_projected_optimisation/wf-outputs/chkp/8_bins/chkp_callback_poly_2_cycles_256_no_proj_d2_45z_0_cycle2"
opt[1]="--id_name _2_cycles_256_eval_param_no_proj_proj_end_d2_45z_1 --n_zernikes 45 --chkp_save_path /gpfswork/rech/ynx/uds36vp/repos/wf-SEDs/HD_projected_optimisation/wf-outputs/chkp/8_bins/chkp_callback_poly_2_cycles_256_no_proj_d2_45z_1_cycle2"
opt[2]="--id_name _2_cycles_256_eval_param_no_proj_proj_end_d2_45z_2 --n_zernikes 45 --chkp_save_path /gpfswork/rech/ynx/uds36vp/repos/wf-SEDs/HD_projected_optimisation/wf-outputs/chkp/8_bins/chkp_callback_poly_2_cycles_256_no_proj_d2_45z_2_cycle2"
opt[3]="--id_name _2_cycles_256_eval_param_no_proj_proj_end_d2_45z_3 --n_zernikes 45 --chkp_save_path /gpfswork/rech/ynx/uds36vp/repos/wf-SEDs/HD_projected_optimisation/wf-outputs/chkp/8_bins/chkp_callback_poly_2_cycles_256_no_proj_d2_45z_3_cycle2"
opt[4]="--id_name _2_cycles_256_eval_param_no_proj_proj_end_d2_45z_4 --n_zernikes 45 --chkp_save_path /gpfswork/rech/ynx/uds36vp/repos/wf-SEDs/HD_projected_optimisation/wf-outputs/chkp/8_bins/chkp_callback_poly_2_cycles_256_no_proj_d2_45z_4_cycle2"
opt[5]="--id_name _2_cycles_256_eval_param_no_proj_proj_end_d2_60z_0 --n_zernikes 60 --chkp_save_path /gpfswork/rech/ynx/uds36vp/repos/wf-SEDs/HD_projected_optimisation/wf-outputs/chkp/8_bins/chkp_callback_poly_2_cycles_256_no_proj_d2_60z_0_cycle2"
opt[6]="--id_name _2_cycles_256_eval_param_no_proj_proj_end_d2_60z_1 --n_zernikes 60 --chkp_save_path /gpfswork/rech/ynx/uds36vp/repos/wf-SEDs/HD_projected_optimisation/wf-outputs/chkp/8_bins/chkp_callback_poly_2_cycles_256_no_proj_d2_60z_1_cycle2"
opt[7]="--id_name _2_cycles_256_eval_param_no_proj_proj_end_d2_60z_2 --n_zernikes 60 --chkp_save_path /gpfswork/rech/ynx/uds36vp/repos/wf-SEDs/HD_projected_optimisation/wf-outputs/chkp/8_bins/chkp_callback_poly_2_cycles_256_no_proj_d2_60z_2_cycle2"
opt[8]="--id_name _2_cycles_256_eval_param_no_proj_proj_end_d2_60z_3 --n_zernikes 60 --chkp_save_path /gpfswork/rech/ynx/uds36vp/repos/wf-SEDs/HD_projected_optimisation/wf-outputs/chkp/8_bins/chkp_callback_poly_2_cycles_256_no_proj_d2_60z_3_cycle2"
opt[9]="--id_name _2_cycles_256_eval_param_no_proj_proj_end_d2_60z_4 --n_zernikes 60 --chkp_save_path /gpfswork/rech/ynx/uds36vp/repos/wf-SEDs/HD_projected_optimisation/wf-outputs/chkp/8_bins/chkp_callback_poly_2_cycles_256_no_proj_d2_60z_4_cycle2"


cd $WORK/repos/wf-SEDs/HD_projected_optimisation/scripts/

srun python -u ./train_project_click_multi_cycle.py \
    --eval_only_param True \
    --train_opt False \
    --saved_model_type external \
    --project_dd_features True \
    --d_max 2 \
    --save_all_cycles True \
    --n_bins_lda 8 \
    --plot_opt True \
    --opt_stars_rel_pix_rmse True \
    --pupil_diameter 256 \
    --n_epochs_param_multi_cycle "15 15" \
    --n_epochs_non_param_multi_cycle "100 50" \
    --l_rate_non_param_multi_cycle "0.1 0.06" \
    --l_rate_param_multi_cycle "0.01 0.004" \
    --total_cycles 2 \
    --saved_cycle cycle2 \
    --model poly \
    --model_eval poly \
    --cycle_def complete \
    --gt_n_zernikes 45 \
    --d_max_nonparam 5 \
    --use_sample_weights True \
    --l2_param 0. \
    --interpolation_type none \
    --eval_batch_size 16 \
    --eval_opt True \
    --dataset_folder /gpfswork/rech/ynx/uds36vp/datasets/interp_SEDs/ \
    --test_dataset_file test_Euclid_res_id_009_8_bins.npy \
    --train_dataset_file train_Euclid_res_2000_TrainStars_id_009_8_bins_sigma_0.npy \
    --plots_folder plots/ \
    --base_path /gpfswork/rech/ynx/uds36vp/repos/wf-SEDs/HD_projected_optimisation/wf-outputs/ \
    --metric_base_path /gpfswork/rech/ynx/uds36vp/repos/wf-SEDs/HD_projected_optimisation/wf-outputs/metrics/ \
    --model_folder chkp/8_bins/ \
    --log_folder log-files/ \
    --optim_hist_folder optim-hist/ \
    --base_id_name _2_cycles_256_eval_param_no_proj_proj_end_d2_ \
    --suffix_id_name 45z_0 --suffix_id_name 45z_1 --suffix_id_name 45z_2 --suffix_id_name 45z_3 --suffix_id_name 45z_4 --suffix_id_name 60z_0 --suffix_id_name 60z_1 --suffix_id_name 60z_2 --suffix_id_name 60z_3 --suffix_id_name 60z_4  \
    --star_numbers 45 --star_numbers 47 --star_numbers 48 --star_numbers 49 --star_numbers 50 --star_numbers 60 --star_numbers 61 --star_numbers 62 --star_numbers 63 --star_numbers 64 \
    ${opt[$SLURM_ARRAY_TASK_ID]} \

## --star_numbers is for the final plot's x-axis. 