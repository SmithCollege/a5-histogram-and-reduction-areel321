#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>

#define size 100

double get_clock() {
        struct timeval tv; int ok;
        ok = gettimeofday(&tv, (void *) 0);
        if (ok<0){
                printf("gettimeofday error\n");
        }
        return (tv.tv_sec*1.0+tv.tv_usec*1.0E-6);
}


void histo(){
}

int main(){
double *times = malloc(sizeof(double) * size);


                //calibrate the clock
        double t0 = get_clock();
        for (int i=0; i<size; i++){
                times[i] = get_clock();
        }
        double t1 = get_clock();
        printf("time per call: %f nx\n", (1000000000.0 * (t1-t0\
)/size));
  //print clock times
        printf("start: %f, end: %f\n", start, end);
	free(times);
  return 0;
}
