# Massively Parallel 4i Imaging Registration

A collection of scripts designed to perform registration on a large amount of image data in parallel on a HPC cluster.

## Overview

The underlying registration is performed using [Fast4DReg](https://github.com/guijacquemet/Fast4DReg), so consult this repo for information on the registration process. A utility script (`fiji_stack_building.sh`) is included to assemble image stacks for easy input into Fast4DReg.

## Instructions

### Building image stacks

The `fiji_stack_building.sh` script is designed to assemble single plane images into a stacks for input into Fast4DReg. We wrote this script to process images output from [Iterative Indirect Immunofluorescence Imaging (4i)](https://doi.org/10.1126/science.aar7042), but it could be easily adapted to process images from other sources.
