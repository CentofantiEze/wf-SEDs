#!/bin/bash

##########################
# SMP Script for CANDIDE #
##########################

# Receive email when job finishes or aborts (commented)
# PBS -M ezequiel.centofanti@cea.fr
# PBS -m ea
# Set a name for the job
#PBS -N wf-psf_train_4096
# Join output and errors in one file
#PBS -j oe
# Set maximum computing time (e.g. 5min)
#PBS -l walltime=72:00:00
# Request number of cores (n_machines:ppn=n_cores)
#PBS -l nodes=n03:ppn=4

# Activate conda environment
module load tensorflow/2.7

python /home/ecentofanti/wf-SEDs/WFE_sampling_test/scripts/train_eval_plot_script_click.py \
    --n_epochs_param 15 15 \
    --n_epochs_non_param 100 50 \
    --model poly \
    --model_eval poly \
    --base_id_name _full_poly_ \
    --suffix_id_name wfeRes_4096 \
    --id_name _full_poly_wfeRes_4096 \
    --test_dataset_file test_Euclid_res_id_004_wfeRes_4096.npy \
    --train_dataset_file train_Euclid_res_2000_TrainStars_id_004_wfeRes_4096.npy \
    --plots_folder plots/4096_wfeRes/ \
    --model_folder chkp/4096_wfeRes/ \
    --chkp_save_path /home/ecentofanti/wf-SEDs/WFE_sampling_test/wf-outputs/chkp/4096_wfeRes/ \
    --star_numbers 2000  \
    --cycle_def complete \
    --n_zernikes 45 \
    --gt_n_zernikes 45 \
    --d_max_nonparam 2 \
    --l_rate_non_param 0.1 0.06 \
    --l_rate_param 0.01 0.004 \
    --saved_model_type checkpoint \
    --saved_cycle cycle2 \
    --total_cycles 2 \
    --use_sample_weights True \
    --l2_param 0. \
    --interpolation_type none \
    --eval_batch_size 16 \
    --train_opt True \
    --eval_opt True \
    --plot_opt True \
    --base_path /home/ecentofanti/wf-SEDs/WFE_sampling_test/wf-outputs/ \
    --dataset_folder /n05data/ecentofanti/WFE_sampling_test/multires_dataset/ \
    --metric_base_path /home/ecentofanti/wf-SEDs/WFE_sampling_test/wf-outputs/metrics/ \
    --log_folder log-files/ \
    --optim_hist_folder optim-hist/ \

# Return exit code
exit 0