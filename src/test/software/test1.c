#include <stdio.h>
#include "rocc.h"

int main(){

    

    printf("Start simulation\n");

    //which register to use as rd? (here 8)
    ROCC_INSTRUCTION_DSS(0, 8, 1, 5, 0);
    //how to see the content of reg 8?

    printf("End simulation, result is %d \n", a);
    printf("\nResult should be 2");
    return a;
}