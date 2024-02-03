#!/bin/bash

#SBATCH --job-name=drift_correction
#SBATCH --ntasks=1
#SBATCH --time=1:00:00
#SBATCH --array=0-9
#SBATCH --partition=cpu
#SBATCH --mem=4G

# The input directory should contain a series of compiled TIF stacks (the output from Step 1)
inputDir=(/nemo/stp/lm/working/barryd/hpc/test/stacks)
# The FIJI directory should, as the name suggests, point to the location of your FIJI installation
fijiDir=(/nemo/stp/lm/working/barryd/hpc/java/fiji)
# The directory in which you want your fully aligned stacks to be saved
outputDir=(/nemo/stp/lm/working/barryd/hpc/test/aligned_stacks)

files=("$inputDir"/*.tif)

IFS="--"

read -a strarr <<< "${files[$SLURM_ARRAY_TASK_ID]}"

dapiPath=$(find "$inputDir" -path "*${strarr[2]}--${strarr[4]}--${strarr[6]}--${strarr[8]}*" -type d)
dapiFolder=$(basename "${dapiPath}")

IFS="_"

read -a strarr2 <<< "$dapiFolder"

IFS=" "

settingsFile="$dapiPath/${strarr2[0]}_${strarr2[1]}_settings.csv"

ml Java/1.8
"$fijiDir"/ImageJ-linux64 -Xmx4G -- --ij2 --headless --console --run ./channel_apply.ijm 'files='\""${files[$SLURM_ARRAY_TASK_ID]}"\"',settings_file_path='\""$settingsFile"\"',results_path='\""$outputDir"\"
