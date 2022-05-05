#!/bin/bash
#SBATCH --job-name=guisdaptest
#SBATCH --account=project_2002451
#SBATCH --time=30:00:00
#SBATCH --mem-per-cpu=2G
#SBATCH --partition=small
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --ntasks=1

module load matlab
srun /projappl/project_2002451/guisdap9/bin/guisdap -p /scratch/project_2002451/ipytest/gfd_setup_slurm.m
