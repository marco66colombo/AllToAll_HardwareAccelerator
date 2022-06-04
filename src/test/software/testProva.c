#include <stdio.h>
#include <inttypes.h>
#include "rocc.h"

#define CUSTOM_0 0b0001011
#define CUSTOM_1 0b0101011

#define N 3
#define MEM_OPCODE 0
#define ACTION_OPCODE 1
#define LOAD_FUNC 1
#define STORE_FUNC 2


int main(){

    printf("\nStart test1");
    printf("\nStart test1");
    printf("\nStart test1");
    printf("\nStart test1");
    printf("\nStart test1");


    int rd_action = 0;
    //int rs2 = 4295032834;
    uint64_t rs1 = 1;

    printf("\nStart test1");
    printf("\nStart test1");
    printf("\nStart test1");
    printf("\nStart test1");

    ROCC_INSTRUCTION_DSS(0, rd_action, rs1, 0, 3);
    //ROCC_INSTRUCTION_DSS(0, rd_action, rs1, rs2, 1);

    printf("\nEnd test");
    printf("\nEnd test");
    printf("\nEnd test");
    printf("\nEnd test");
    printf("\nEnd test");
    printf("\nEnd test");
    printf("\nEnd test");
    printf("\nRD : %d", rd_action);

    return 0;

}