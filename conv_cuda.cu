#raw
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#end raw

static const int   HF        = $HF;    // height filter (when constant)
static const int   WF        = $WF;    // width filter (when constant)
static const int   H         = $H;     // image height 
static const int   W         = $W;     // image  width

///////////////////////////////////////////////////////////////////////////////
#raw
#define CUDA_CHECK_RETURN(value)                                              \
{cudaError_t _m_cudaStat = value;if (_m_cudaStat != cudaSuccess)              \
{fprintf(stderr,"Error %s at line %d in file %s\n",                           \
cudaGetErrorString(_m_cudaStat), __LINE__, __FILE__);                         \
exit(1);}}
#end raw
///////////////////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------------------
__global__ void conv(const float im[H][W], const float filt[HF][WF], float out[H][W]){
   
    int tx = threadIdx.x+ blockIdx.x*blockDim.x;
    int ty = threadIdx.y+ blockIdx.y*blockDim.y;

    float res = 0.0f;
    float im_temp;
    float norm = 0.0f;

    if (tx > WF/2 && tx < W - WF/2 && ty> HF/2 && ty < H - HF/2){
        for (int y=0; y<HF; y++){
            for (int x=0; x<WF; x++){
                im_temp = im[ty+y-HF/2][tx+x-WF/2]; 
                res    += im_temp * filt[y][x];
                //norm   += im_temp*im_temp;
            }
        }
        out[ty][tx] = res;
        //norm = sqrtf(norm);
        //if (norm ==0.0f){ out[ty][tx] = 0.0f;}
        //else{  out[ty][tx] = abs(res/norm);}
    }
}
