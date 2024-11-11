#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <sys/time.h>

#define SIZE 8

double get_clock() {
        struct timeval tv; int ok;
        ok = gettimeofday(&tv, (void *) 0);
        if (ok<0){
                printf("gettimeofday error\n");
        }
        return (tv.tv_sec*1.0+tv.tv_usec*1.0E-6);
}

int sum(int* arr) {
	int total = 0;
	for (int i = 0; i<SIZE; i++){
		total += arr[i];
		//printf("%d \n", total);
	}
	return total;
}

int product(int* arr) {
	int product = arr[0];
	for (int i=1;i<SIZE;i++){
		//printf("arr: %d\n", arr[i]);
		product *= arr[i];
		//printf("%d\n", product);
	}
	return product;
	
}

int minimum(int* arr) {
	int min = arr[0];

	for (int i=1;i<SIZE;i++){
		if (arr[i]<min){
			min = arr[i];
		}
	}

	return min;
	
}

int maximum(int* arr) {
	int max = arr[0];

	for (int i=1;i<SIZE;i++) {
		if (arr[i]>max) {
			max=arr[i];
		}
	}

	return max;
}

int main() {
	int* arr = malloc(sizeof(int) * SIZE);
	double *times = malloc(sizeof(double) * SIZE);

	for (int i=0;i<SIZE;i++) {
		arr[i] = rand() % 101;
		printf("%d ", arr[i]);
	}

	printf("\n");

    //calibrate the clock
    double t0 = get_clock();
    for (int i=0; i<SIZE; i++){
        times[i] = get_clock();
    }
    double t1 = get_clock();
    printf("time per call: %f nx\n", (1000000000.0 * 
    (t1-t0)/SIZE));

	printf("sum: %d\n", sum(arr));
	printf("product: %d\n", product(arr));
	printf("min: %d\n", minimum(arr));
	printf("max: %d\n", maximum(arr));

    
	return 0;
}

