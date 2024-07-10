#!/bin/bash
#SBATCH --time=09:59:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=8gb
#SBATCH --job-name=Arginine
#SBATCH --partition=regular
module load    Gaussian/16.B.01
srun g16  ARG.com > ARG.log

