#!/bin/bash

#SBATCH --time=01:25:00
#SBATCH --mem=64G
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
echo before $PYTHONPATH
export PYTHONPATH=$PYTHONPATH:/users/aarslan/tools/hmax/models/HNORM
export PYTHONPATH=$PYTHONPATH:/usr/lib64/python26.zip
export PYTHONPATH=$PYTHONPATH:/usr/lib64/python2.6
export PYTHONPATH=$PYTHONPATH:/usr/lib64/python2.6/plat-linux2
export PYTHONPATH=$PYTHONPATH:/usr/lib64/python2.6/lib-tk
export PYTHONPATH=$PYTHONPATH:/usr/lib64/python2.6/lib-old
export PYTHONPATH=$PYTHONPATH:/usr/lib64/python2.6/lib-dynload
export PYTHONPATH=$PYTHONPATH:/usr/lib64/python2.6/site-packages
export PYTHONPATH=$PYTHONPATH:/usr/lib64/python2.6/site-packages/gst-0.10
export PYTHONPATH=$PYTHONPATH:/usr/lib64/python2.6/site-packages/gtk-2.0
export PYTHONPATH=$PYTHONPATH:/usr/lib64/python2.6/site-packages/webkit-1.0
export PYTHONPATH=$PYTHONPATH:/usr/lib/python2.6/site-packages 
echo after $PYTHONPATH


rm $joblist -f

for fr in {1..45}
do
	FILE=$6/$2-$3/$7/$4/$5/${fr}'_mt.mat'
	echo checking $FILE
	if [ ! -f "$FILE" ]
	then
	echo python $src_code_dir/process_directory_motion.py --src_dir $1 --deg_r $2 --deg_l $3 --act $4 --seq $5 --target_dir $6 --this_fr $fr --body_type $7 >> $joblist	
	fi
done

parallel -a $joblist
