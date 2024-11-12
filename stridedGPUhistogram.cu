#include <iostream>
#include <math.h>
#include <sys/time.h>

#define TILE_WIDTH 50

double get_clock() {
        struct timeval tv; int ok;
        ok = gettimeofday(&tv, (void *) 0);
        if (ok<0){
                printf("gettimeofday error");
        }
        return (tv.tv_sec * 1.0 + tv.tv_usec * 1.0E-6);
}


__global__ void histo_kernel(unsigned char* array, long size, unsigned int* histo, int buckets)
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
int size = 8;
	double *times = (double *)malloc(sizeof(double)*size);
         //calibrate clock
        double t0 = get_clock();
        for (int i=0; i<size; i++){
            times[i] = get_clock();
        }
        double t1 = get_clock();
        printf("time per call: %f nx\n", 
        (1000000000.0 * (t1-t0)/size));
	

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
    histo_kernel<<<grid,block>>>(dArray,size,dHist, size);
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






	//print clock times
	//printf("start: %f, end: %f\n", start_time, end_time);

	free(times);
	return 0;
}
