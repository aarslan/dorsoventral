#!/bin/bash

#SBATCH --time=00:05:00
##SBATCH -n 1
##SBATCH -N 8-16 
#SBATCH --qos=bibs-tserre-condo
##SBATCH --exclusive
#SBATCH --exclude=smp012,smp013,smp014,smp015

#SBATCH -J motion_xtract_trial
#SBATCH -o ~/out/motion_xtract_trial%j.out
#SBATCH -e ~/out/motion_xtract_trial%j_e.out


module unload python
module load enthought
module unload cuda

echo 'HERE WE GO'
src_code_dir='/users/aarslan/code/dorsoventral'


python $src_code_dir/process_directory_motion.py --src_dir $1 --deg_l $2 --deg_r $3 --act $4 --seq $5 --target_dir $6 --this_fr 5

