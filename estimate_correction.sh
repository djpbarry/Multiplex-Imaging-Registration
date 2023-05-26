#!/bin/bash

#SBATCH --job-name=drift_estimation
#SBATCH --ntasks=1
#SBATCH --time=1:00:00
#SBATCH --array=0-1151
#SBATCH --partition=cpu
#SBATCH --mem=4G

files=(/nemo/stp/lm/working/barryd/Working_Data/Santos/Elias/Compiled_Stacks/*DAPI*.tif)

ml Java/1.8
/nemo/stp/lm/working/barryd/hpc/java/fiji/ImageJ-linux64 -Xmx4G -- --ij2 --headless --console --run /nemo/stp/lm/working/barryd/hpc/java/fiji/plugins/Fast4DReg/channel_estimate+apply.ijm 'exp_nro=001,files='\""${files[$SLURM_ARRAY_TASK_ID]}"\"''

#-#0-4608
