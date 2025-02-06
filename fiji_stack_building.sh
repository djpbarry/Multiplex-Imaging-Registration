#!/bin/bash

#SBATCH --job-name=fiji-conversion
#SBATCH --ntasks=1
#SBATCH --time=1:00:00
#SBATCH --array=0-9
#SBATCH --partition=ncpu
#SBATCH --mem=4G

# The parent directory should point to the top level directory where all your images are contained
parentDir=(/nemo/project/proj-lm-share/santoss/Multiplexed_imaging_data)
# The output directory is where the compiled stacks will appear
outputDir=(/nemo/project/proj-lm-share/santoss/2025.02.06_Test/Compiled)
# The FIJI directory should, as the name suggests, point to the location of your FIJI installation
fijiDir=(/nemo/project/proj-lm-share/santoss/fiji)

childDirs=("$parentDir"/*)

files=("${childDirs[15]}"/data/*.tif)

ml Java/1.8
"$fijiDir"/ImageJ-linux64 -Xmx4G -- --headless --console -macro "./build_stacks.ijm" "$parentDir,$outputDir,${files[$SLURM_ARRAY_TASK_ID]}"
