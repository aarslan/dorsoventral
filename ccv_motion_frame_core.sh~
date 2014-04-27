#!/bin/bash

#SBATCH --time=04:00:00
##SBATCH -n 1
##SBATCH -N 8-16 
#SBATCH --qos=bibs-tserre-condo
##SBATCH --exclusive
#SBATCH --exclude=smp012,smp013,smp014,smp015

#SBATCH -J 10day_pos
#SBATCH -o zcommon_scripts/10day_pos%j.out
#SBATCH -e zcommon_scripts/10day_pos%j_e.out

module add matlab
module add cuda

src_code_dir='/gpfs/home/xl1/src/cns_mouse'


python $src_code_dir/process_directory_motion.py --src_dir $1 --deg_l $2 --deg_r $3 --act $4 --seq $5 --target_dir $6 --this_frame 5

