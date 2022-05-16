#include <stdio.h>
#include "rocc.h"

#define CUSTOM_0 0b0001011

int main(){


    printf("Start simulation\n");

    int rs1_1 = 12;
    //write at index 1 in pe(2,1)
    long int rs2_1 = 4295032834;
    int rd_1 = 0;

    //rs1 nella store non è utile
    int rs1_2 = 0;
    //write at index 1 in pe(2,1)
    long int rs2_2 = 4295032834;
    int rd_2 = 0;

    ROCC_INSTRUCTION_DSS(0, rd_1, rs1_1, rs2_1, 1);
    ROCC_INSTRUCTION_DSS(0, rd_2, rs1_2, rs2_2, 2);
   

    printf("End simulation\n");
    printf("result_1 is: load response %d, expected 32\n", rd_1);
    printf("result_1 is: store response %d, expected 12\n", rd_2);
    return 0;
}