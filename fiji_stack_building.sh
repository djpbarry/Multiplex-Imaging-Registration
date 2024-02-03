#!/bin/bash

#SBATCH --job-name=fiji-conversion
#SBATCH --ntasks=1
#SBATCH --time=1:00:00
#SBATCH --array=0-9
#SBATCH --partition=cpu
#SBATCH --mem=4G

# The parent directory should point to the top level directory where all your images are contained
parentDir=(/nemo/stp/lm/inputs/santoss/Elias\ Copin/Multiplexed_imaging_data)
# The output directory is where the compiled stacks will appear
outputDir=(/nemo/stp/lm/working/barryd/Working_Data/Santos/Elias/Compiled Stacks)
# The FIJI directory should, as the name suggests, point to the location of your FIJI installation
fijiDir=(/nemo/stp/lm/working/barryd/hpc/java/fiji)

files=("$parentDir"/*/*/*.tif)

ml Java/1.8
"$fijiDir"/ImageJ-linux64 -Xmx4G -- --headless --console -macro "./build_stacks.ijm" "$parentDir,$outputDir,${files[$SLURM_ARRAY_TASK_ID]}"
