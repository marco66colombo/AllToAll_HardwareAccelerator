#include <stdio.h>
#include "rocc.h"

int main(){

    int a = 0;

    printf("Start simulation\n");

    ROCC_INSTRUCTION_DSS(0, a, 1, 5, 0);

    printf("End simulation, result is %d \n", a);
    printf("\nResult should be 2");
    return a;
}