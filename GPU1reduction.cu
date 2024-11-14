#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <sys/time.h>

#define SIZE 2000

double get_clock() {
        struct timeval tv; int ok;
        ok = gettimeofday(&tv, (void *) 0);
        if (ok<0){
                printf("gettimeofday error\n");
        }
        return (tv.tv_sec*1.0+tv.tv_usec*1.0E-6);
}

__global__ void sum(int* input, int* out) {

	__shared__ float partialSum[2*SIZE];
	unsigned int t = threadIdx.x;
	unsigned int start = 2*blockIdx.x*blockDim.x;
	partialSum[t] = input[start + t];
	partialSum[blockDim.x+t] = input[start+blockDim.x+t];
	
	for (unsigned int stride = 1;
	stride <= blockDim.x; stride *= 2) {
		__syncthreads();
		if (t%stride == 0) {
			partialSum[2*t] += partialSum[2*t+stride];
			out[0] += partialSum[2*t];
		}
	}



}


int main(){


	double *times = (double*)malloc(sizeof(double) * SIZE);
	int *input = (int*)malloc(sizeof(int)*SIZE);
	int *out = (int *)malloc(sizeof(int) *SIZE);
	int *d_input, *d_out;
	
	cudaMallocManaged(&d_out, sizeof(int) * SIZE);
	cudaMallocManaged(&d_input, sizeof(int) * SIZE);
	

	for (int i=0;i<SIZE;i++) {
		//input[i] = rand() % 16;
		input[i] = 1;
		//printf("%d ", input[i]);
	}
	//printf("\n");


	//calibrate the clock
	double t0 = get_clock();
	for (int i=0; i<SIZE; i++){
		 times[i] = get_clock();
    }
	double t1 = get_clock();
	printf("time per call: %f nx\n", (1000000000.0 * 
	(t1-t0)/SIZE));

	cudaMemcpy(d_input, input, SIZE*sizeof(int), cudaMemcpyHostToDevice);

	dim3 block(32);
	dim3 grid((SIZE + block.x - 1)/block.x);
	double start = get_clock();
	sum<<<grid, block>>>(d_input, d_out);
	double end = get_clock();

	cudaDeviceSynchronize();

	printf("%s\n", cudaGetErrorString(cudaGetLastError()));

	cudaMemcpy(out, d_out, sizeof(int) * SIZE, 
	cudaMemcpyDeviceToHost);

	for (int i=0;i<SIZE;i++){
	//	printf("%d ", out[i]);
	}

	printf("%d\n", out[0]);

	printf("total time: %f\n", end-start);
	

	free(input);
	free(out);
	free(times);
	cudaFree(d_out);
	cudaFree(d_input);
	return 0;
}
