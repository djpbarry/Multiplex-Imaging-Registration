#!/bin/bash

#SBATCH --job-name=drift_correction
#SBATCH --ntasks=1
#SBATCH --time=1:00:00
#SBATCH --array=0-3457
#SBATCH --partition=cpu
#SBATCH --mem=4G

files=(/nemo/stp/lm/working/barryd/Working_Data/Santos/Elias/Compiled_Stacks/*.tif)

#IFS=".tif"

#cd /nemo/stp/lm/working/barryd/Working_Data/Santos/Elias/Compiled_Stacks

#files=($(ls --ignore="*DAPI*"))

IFS="--"

read -a strarr <<< "${files[$SLURM_ARRAY_TASK_ID]}"

dapiPath="${strarr[0]}--${strarr[2]}--${strarr[4]}--${strarr[6]}--${strarr[8]}--DAPI_2023-May-25-001"
dapiFolder=$(basename "${dapiPath}")

echo "$dapiPath"

echo "$dapiFolder"

IFS="_"

read -a strarr2 <<< "$dapiFolder"

IFS=" "

settingsFile="$dapiPath/${strarr2[0]}_${strarr2[1]}_settings.csv"

echo $settingsFile

ml Java/1.8
/nemo/stp/lm/working/barryd/hpc/java/fiji/ImageJ-linux64 -Xmx4G -- --ij2 --headless --console --run /nemo/stp/lm/working/barryd/hpc/java/fiji/plugins/Fast4DReg/channel_apply.ijm 'files='\""${files[$SLURM_ARRAY_TASK_ID]}"\"',settings_file_path='\""$settingsFile"\"',results_path="/nemo/stp/lm/working/barryd/Working_Data/Santos/Elias/Aligned_Stacks"'
