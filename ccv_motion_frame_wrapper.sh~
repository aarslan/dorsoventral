#!/bin/bash

CODE_DIR=/home/aarslan/prj/code/dorsoventral/disparity
ANGLES_DIR=/home/aarslan/prj/data/motion_morphing_dataset_angles
TARGET_DIR=/home/aarslan/prj/data/motion_morphing_dataset_angles

data_in='/gpfs/data/tserre/Users/aarslan/motion_morphing_dataset_stereo/features_stereo'
#data_in='/home/aarslan/prj/data/motion_morphing_dataset_stereo/features_stereo'
data_out='/gpfs/data/tserre/Users/aarslan/motion_morphing_dataset_stereo/features_motion'

declare -a bodies=("human")

for deg in {2..60..30} #{2..360..30}

do 
	for bod in "${bodies[@]}"
	do
		for action in $data_in/$(($deg+6))-$deg/$bod/*
		do

			for seq in $action/*
			do
			./ccv_motion_frame_core $data_in $(($deg+6)) $deg `basename $action` `basename $seq` $data_out
			done
		done
	done

done

