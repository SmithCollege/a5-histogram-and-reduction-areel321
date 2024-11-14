#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>

#define size 10
#define buckets 5



int main(){
	int *hist = malloc(sizeof(int)*size);
	int results[buckets] = {0};


	for (int i=0;i<size;i++){
		hist[i] = i;
		printf("%d ", i);
	}

	for (int i=0; i<size; i++){
		if(hist[i]<size){
			int bin=hist[i]%buckets;
			results[bin]++;
		}
	}

	printf("\n");
	for (int i=0; i<buckets;i++){
		printf("%d ", results[i]);
	}
	printf("\n");

	
  return 0;
}
