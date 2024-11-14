#include <iostream>
#include <math.h>
#include <sys/time.h>

#define TILE_WIDTH 50
#define size 8
#define buckets 8




__global__ void histo_kernel(unsigned char* array, 
unsigned int* histo)
{
    int i = (blockIdx.x * blockDim.x + threadIdx.x);

    if (i>=size){
		return;
		}
    unsigned char value = array[i];

    int bin = (value % buckets);
    printf("%d", bin);

    atomicAdd(&histo[bin],1);
    
}

int main(){
	

	unsigned char* array = (unsigned char*)malloc(sizeof(char)*size);
	unsigned int* histo = 
	(unsigned int*)malloc(sizeof(int)*size);

	for (int i=0;i<size;i++){
		array[i]= i;
		//printf("%d ", array[i]);
	}
	printf("\n");

	unsigned char* dArray;
    cudaMalloc(&dArray,size);
    cudaMemcpy(dArray,array,size,
    cudaMemcpyHostToDevice);

    unsigned int* dHist;
    cudaMalloc(&dHist,size * sizeof(int));
    cudaMemset(dHist,0,size * sizeof(int));

    dim3 block(32);
    dim3 grid((size + block.x - 1)/block.x);

	cudaDeviceSynchronize();
    histo_kernel<<<grid,block>>>(dArray,dHist);
    cudaDeviceSynchronize();

    printf("%s\n", cudaGetErrorString(cudaGetLastError()));

    cudaMemcpy(histo,dHist,size * sizeof(int),
    cudaMemcpyDeviceToHost);

    for (int i=0;i<size;i++){
    	printf("%d ", histo[i]);
    }
    printf("\n");

    cudaFree(dArray);
    cudaFree(dHist);



	return 0;
}
