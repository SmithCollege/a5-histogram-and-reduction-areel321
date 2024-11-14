#include <iostream>
#include <math.h>
#include <sys/time.h>
#include <stdlib.h>
#include <stdio.h>

#define BLOCK_SIZE 128
#define size 10
#define buckets 2

__global__ void hist(unsigned char*array, unsigned int*histo){
	int i = blockIdx.x*blockDim.x+threadIdx.x;
	int stride = blockDim.x * gridDim.x;

	if (i>=stride){
		return;
	}
	while (i<size){
		int value = array[i];
		int bin = value % buckets;
		atomicAdd(&(histo[bin]), 1);
		i+=stride;
	}
}

int main(){
	unsigned char* array = (unsigned char*)malloc(sizeof(char)*size);
	unsigned int* histo = (unsigned int*)malloc(sizeof(int)*size);


	for (int i=0;i<size;i++){
		array[i]=i;
	}
	printf("\n");
	unsigned char*d_array;
	cudaMalloc(&d_array, size);
	cudaMemcpy(d_array, array, size, cudaMemcpyHostToDevice);

	unsigned int*d_histo;
	cudaMalloc(&d_histo, buckets*sizeof(int));
	cudaMemset(d_histo,0,buckets*sizeof(int));

	dim3 block(32);
	dim3 grid((size+block.x-1)/block.x);

	cudaDeviceSynchronize();
	hist<<<grid, block>>>(d_array, d_histo);
	cudaDeviceSynchronize();
	printf("%s\n", cudaGetErrorString(cudaGetLastError()));
	cudaMemcpy(histo, d_histo, buckets*sizeof(int), cudaMemcpyDeviceToHost);

	for (int i=0;i<buckets;i++) {
		printf("%d ", histo[i]);
	}
	printf("\n");

	free(array);
	free(histo);
	cudaFree(d_array);
	cudaFree(d_histo);
	
	
	
return 0;
}
