# Parallel 4i Imaging Registration

A collection of scripts designed to perform registration on a large amount of image data in parallel on a HPC cluster.

## Overview

The underlying registration is performed using [Fast4DReg](https://github.com/guijacquemet/Fast4DReg), so consult this repo for information on the registration process. A utility script (`fiji_stack_building.sh`) is included to assemble image stacks for easy input into Fast4DReg.

## Instructions

### Step 1: Building image stacks

The `fiji_stack_building.sh` script is designed to assemble single plane images into a stacks for input into Fast4DReg. We wrote this script to process images output from [Iterative Indirect Immunofluorescence Imaging (4i)](https://doi.org/10.1126/science.aar7042), but it could be easily adapted to process images from other sources.

For processing 4i imaging data, it is assumed the raw images are saved in a folder structure as follows:
```
parent 4i directory
|
|-- Staining Round 1
|   |   metadata.xml
|   |-- data
|       |
|       |   Day#_BMP--W#####--P#####--Z#####--T#####--Channel_1.tif
|       |   Day#_BMP--W#####--P#####--Z#####--T#####--Channel_2.tif
|       ⋮
|       |   Day#_BMP--W#####--P#####--Z#####--T#####--Channel_n.tif
|-- Staining Round 2
|   |   metadata.xml
|   |-- data
|       |
|       |   Day#_BMP--W#####--P#####--Z#####--T#####--Channel_1.tif
|       |   Day#_BMP--W#####--P#####--Z#####--T#####--Channel_2.tif
|       ⋮
|       |   Day#_BMP--W#####--P#####--Z#####--T#####--Channel_n.tif
⋮
⋮
|-- Staining Round M
|   |   metadata.xml
|   |-- data
|       |
|       |   Day#_BMP--W#####--P#####--Z#####--T#####--Channel_1.tif
|       |   Day#_BMP--W#####--P#####--Z#####--T#####--Channel_2.tif
|       ⋮
|       |   Day#_BMP--W#####--P#####--Z#####--T#####--Channel_n.tif
```
To process such data, the `fiji_stack_building.sh` simply needs to updated as follows and then submitted to a SLURM job scheduler.

Line 10 needs to be edited to point to one of the data directories illustrated above:
```shell
files=(parent 4i directory/Staining Round #/data/*.tif)
```
Line 6 needs to be updated with the number of tif files in one of the data directories. It is assumed the the number of files in each data directory is the same - if this is not the case, empty images will be placed in the output stacks were missing files were encountered.
```shell
#SBATCH --array=0-<number of tif files in one of the data directories>
```
Finally, line 13 needs to updated with the path to your FIJI installation, the path to `build_stacks.ijm` and the path to your output directory for the compiled stacks:
```shell
<path to fiji installation>/ImageJ-linux64 -Xmx4G -- --headless --console -macro "<path to macro>/build_stacks.ijm" "<path to output directory>,${files[$SLURM_ARRAY_TASK_ID]}"
```
If everything runs successfully, then you should see TIF stacks appearing in your output directory.

### Step 2: Estimate XY-misalignment using reference channel

Run the `estimate_correction.sh` to register a reference channel (usually DAPI). This will require updating...
* line 10 to point to the output directory from Step 1
* line 6 to include the number of reference stacks
* line 13 to point to your FIJI installation and the location of the relevant Fast4DReg script (`channel_estimate+apply.ijm`).

If this step runs successfully, you should see folders of results appearing in your output directory from Step 1, including settings files and aligned stacks (for the reference channel).

### Step 3: Apply XY-alignment calculated in Step 2 to remaining channels

Run `apply_correction.sh` to register all remaining channels. This will require updating...
* line 10 to point to the output directory from Step 1
* line 6 to include the number of tif files in the output directory from Step 1
* line 29 to point to your FIJI installation, the location of the relevant Fast4DReg script (`channel_apply.ijm`) and the path to a results directory.

If this step runs successfully, you should see TIF stacks appearing in the specified results directory.
