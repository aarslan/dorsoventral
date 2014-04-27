import computation as comp, models as mod, params
import matplotlib as mlp
import matplotlib.pyplot as plt
import numpy as np
import scipy as sp
import os
import argparse
from hmax.models.dorsal import get_c1, prepare_cuda_kernels, pyramid_vid
from hmax.models.params import multicue_motion_replacement

import pycuda
from pycuda import driver
from pycuda import gpuarray
from pycuda.compiler import SourceModule

def process_dir(target_stem_dir, target_string, targetAct, targetSeq):
	frame_cnt = 64
	filter_len = int(10)
	target_stereo_dir = os.path.join(target_stem_dir,'disparity', target_string)
	target_motion_dir = os.path.join(target_stem_dir,'motion', target_string)
	imH = 409
	imW = 311

	srcDir = '/home/aarslan/prj/data/CMU_mocap_stereo/frames/plw'

	par = params.ventral_absolute_disparity_simple()
	#import ipdb; ipdb.set_trace()
##	for fr in range(1, frame_cnt+1):
##		print fr
##		imleft = os.path.join(srcDir, 'disp0', targetAct, targetSeq, str(fr)+'.png');
##		imright = os.path.join(srcDir, 'disp5', targetAct, targetSeq, str(fr)+'.png');
##		im = []; im.append(imleft); im.append(imright);
##		features, dummy = mod.absolute_disparity_2(par, im)
##		av_features = np.mean(np.mean(features, axis = 0),axis=1)
##		D = np.argmax(av_features, axis=0);
##		mD = np.squeeze(np.max(av_features, axis=0, keepdims=True));
##		res = D*(mD>0.9)/1
##		dir_name = os.path.join(targetDir, targetAct, targetSeq)
##		mat_name = os.path.join(dir_name, str(fr))

		#if not os.path.exists(dir_name):
		#	os.makedirs(dir_name)
		#sp.io.savemat(mat_name, {'fr': res})
##	im = np.ones([frame_cnt, imH, imW])
##	for ii,fr in enumerate(range(1,frame_cnt)):
##		dir_name = os.path.join(target_stereo_dir, targetAct, targetSeq)
##		mat_name = os.path.join(dir_name, str(fr))
##		frame_dict = sp.io.loadmat(mat_name, {'fr': res})
##		temp = frame_dict['fr']
##		temp = (temp != 0)*255
##		
##		im[ii,:,:] = temp
##	c1 = dorsal_wrapper(im)

	par = params.dorsal_motion_simple()
	n_size = par['filters']['gabors_sizes'].shape[0]
	n_freq = par['filters']['gabors_temporal_frequencies'].shape[0]
	n_ori = par['filters']['gabors_number_of_orientations']
	half_filter = int(filter_len/2)
	for ii,fr in enumerate(range(half_filter,frame_cnt-half_filter+1)):
		im = np.ones([filter_len, imH, imW])
		print 'base',fr
		for filt_fr in range(-half_filter+1, half_filter+1):
			stereo_dir_name = os.path.join(target_stereo_dir, targetAct, targetSeq)
			stereo_mat_name = os.path.join(stereo_dir_name, str(fr+filt_fr))
			target_dir_name = os.path.join(target_motion_dir, targetAct, targetSeq)
			target_mat_name = os.path.join(target_dir_name, str(fr))
			frame_dict = sp.io.loadmat(stereo_mat_name)
			temp = frame_dict['fr']
			temp = (temp != 0)*255
			#import ipdb; ipdb.set_trace()
			im[filt_fr,:,:] = np.array(temp)
			#print str(fr+filt_fr)
		features, dummy = mod.dorsal_primary(par, im)
		if not os.path.exists(target_dir_name):
			os.makedirs(target_dir_name)
		sp.io.savemat(target_mat_name, {'fr': features})
	#import ipdb; ipdb.set_trace()

#plt.imshow(res)
#plt.show()


def main():
	parser = argparse.ArgumentParser(description=""" """)
	parser.add_argument('--target_dir', type=str, default='/home/aarslan/prj/data/CMU_mocap_stereo/')
	parser.add_argument('--target_string', type=str, default='d5s0')
	parser.add_argument('--target_act', type=str, default='boxing')
	parser.add_argument('--target_seq', type=str, default='13_17')

	args = parser.parse_args()
	target_dir = args.target_dir
	target_string = args.target_string
	target_act = args.target_act
	target_seq =  args.target_seq
	process_dir(target_dir, target_string, target_act, target_seq)

if __name__=="__main__":
	main()
    
