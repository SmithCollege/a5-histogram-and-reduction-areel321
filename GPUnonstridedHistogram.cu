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


int main(){
double *times = (double *)malloc(sizeof(double)*width);
	 //calibrate clock
        double t0 = get_clock();
        for (int i=0; i<width; i++){
            times[i] = get_clock();
        }
        double t1 = get_clock();
        printf("time per call: %f nx\n", (1000000000.0 * (t1-t0\
)/width));

//print clock times
        printf("start: %f, end: %f\n", start_time, end_time);

free(times);
return 0;
}