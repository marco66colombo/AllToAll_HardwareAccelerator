#include <stdio.h>
#include "rocc.h"

#define CUSTOM_0 0b0001011

int main(){


    printf("Start simulation\n");

    int rs1 = 12;
    //write at index 1 in pe(2,1)
    long int rs2 = 4295032834;
    int rd = 0;
    ROCC_INSTRUCTION_DSS(0, rd, rs1, rs2, 1);
   

    printf("End simulation, result is %d \n", rd);
    return 0;
}