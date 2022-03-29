#include <stdio.h>
#include "rocc.h"

int main(){

    

    printf("Start simulation\n");

    int a = 0;
    ROCC_INSTRUCTION_DSS(0, a, 1, 5, 0);
   

    printf("End simulation, result is %d \n", a);
    printf("\nResult should be 2");
    return a;
}