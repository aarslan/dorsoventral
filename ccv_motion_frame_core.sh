#!/bin/bash

#SBATCH --time=01:15:00
##SBATCH -n 8
##SBATCH -N 8-16 
#SBATCH --qos=pri-aarslan ##bibs-tserre-condo
#SBATCH --exclusive
#SBATCH --exclude=smp012,smp013,smp014,smp015

#SBATCH -J motion_xtract_trial
#SBATCH -o /users/aarslan/out/motion_xtract_%j.out


module unload python
module load enthought
module unload cuda

echo 'processing' $8 $2 $3 $4 $5 
src_code_dir='/users/aarslan/code/dorsoventral'
joblist='/users/aarslan/joblists/'$8_$2_$3_$4_$5'filter21.jlist'


#python $src_code_dir/process_directory_motion.py --src_dir $1 --deg_r $2 --deg_l $3 --act $4 --seq $5 --target_dir $6 --this_fr $7 --body_type $8


rm $joblist -f

for fr in {1..45}
do
echo python $src_code_dir/process_directory_motion.py --src_dir $1 --deg_r $2 --deg_l $3 --act $4 --seq $5 --target_dir $6 --this_fr $fr --body_type $7 >> $joblist
done

parallel  -a $joblist
