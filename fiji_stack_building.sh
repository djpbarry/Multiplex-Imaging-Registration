#!/bin/bash

#SBATCH --job-name=fiji-conversion
#SBATCH --ntasks=1
#SBATCH --time=1:00:00
#SBATCH --array=0-4608
#SBATCH --partition=cpu
#SBATCH --mem=4G

files=(/nemo/stp/lm/inputs/santoss/Elias\ Copin/Multiplexed_imaging_data/OM_96w_8seq_20210706_4i_16th_stain_Bry_488_pS10H3_563_MASTL_647_001/data/*.tif)

ml Java/1.8
/nemo/stp/lm/working/barryd/hpc/java/fiji/ImageJ-linux64 -Xmx4G -- --headless --console -macro "/nemo/stp/lm/working/barryd/Working_Data/Santos/Elias/scripts/build_stacks.ijm" "/nemo/stp/lm/inputs/santoss/Elias Copin/Multiplexed_imaging_data,/nemo/stp/lm/working/barryd/Working_Data/Santos/Elias/Compiled Stacks,${files[$SLURM_ARRAY_TASK_ID]}"