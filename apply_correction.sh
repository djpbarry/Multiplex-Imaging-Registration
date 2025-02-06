#!/bin/bash

#SBATCH --job-name=drift_correction
#SBATCH --ntasks=1
#SBATCH --time=1:00:00
#SBATCH --array=0-9
#SBATCH --partition=ncpu
#SBATCH --mem=4G

# The input directory should contain a series of compiled TIF stacks (the output from Step 1)
inputDir=(/nemo/project/proj-lm-share/santoss/Test_Output)
# The FIJI directory should, as the name suggests, point to the location of your FIJI installation
fijiDir=(/nemo/project/proj-lm-share/santoss/fiji)
# The directory in which you want your fully aligned stacks to be saved
outputDir=(/nemo/project/proj-lm-share/santoss/Test_Aligned)

files=("$inputDir"/*.tif)

IFS="--"

read -a strarr <<< "${files[$SLURM_ARRAY_TASK_ID]}"

dapiPath=$(find "$inputDir" -path "*${strarr[2]}--${strarr[4]}--${strarr[6]}--${strarr[8]}*" -type d)
dapiFolder=$(basename "${dapiPath}")

IFS="_"

read -a strarr2 <<< "$dapiFolder"

settingsFile="$dapiPath/${strarr2[*]:0:${#strarr2[@]}-1}_settings.csv"

IFS=" "

ml Java/1.8
"$fijiDir"/ImageJ-linux64 -Xmx4G -- --ij2 --headless --console --run ./channel_apply.ijm 'files='\""${files[$SLURM_ARRAY_TASK_ID]}"\"',settings_file_path='\""$settingsFile"\"',results_path='\""$outputDir"\"
