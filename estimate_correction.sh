#!/bin/bash

#SBATCH --job-name=drift_estimation
#SBATCH --ntasks=1
#SBATCH --time=1:00:00
#SBATCH --array=0-9
#SBATCH --partition=ncpu
#SBATCH --mem=4G

# The input directory should contain a series of compiled TIF stacks (the output from Step 1)
inputDir=(/nemo/project/proj-lm-share/santoss/Test_Output)
# The FIJI directory should, as the name suggests, point to the location of your FIJI installation
fijiDir=(/nemo/project/proj-lm-share/santoss/fiji)

files=("$inputDir"/*DAPI*.tif)

ml Java/1.8
"$fijiDir"/ImageJ-linux64 -Xmx4G -- --ij2 --headless --console --run "./channel_estimate+apply.ijm 'exp_nro=001,files='\""${files[$SLURM_ARRAY_TASK_ID]}"\"''
