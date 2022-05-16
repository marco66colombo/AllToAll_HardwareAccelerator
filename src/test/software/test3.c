#include <stdio.h>
#include "rocc.h"

#define CUSTOM_0 0b0001011

int main(){


    printf("Start simulation\n");

    long int rs2[18];
    int rs1[18] = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18};
    int rd_load[18] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    int rd_store[18] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};

    rs2[0] = 4295032834;
    rs2[1] = 8590000130;
    rs2[2] = 12884967426;
    rs2[3] = 150323920898;
    rs2[4] = 171798757378;
    rs2[5] = 274877972482;
    rs2[6] = 4294967296;
    rs2[7] = 8589934592;
    rs2[8] = 12884901888;
    rs2[9] = 150323855360;
    rs2[10] = 171798691840;
    rs2[11] = 274877906944;
    rs2[12] = 4294967297;
    rs2[13] = 8589934593;
    rs2[14] = 12884901889;
    rs2[15] = 150323855361;
    rs2[16] = 171798691841;
    rs2[17] = 274877906945;
    
    for(int i=0; i<=17; i++){
        //load
        ROCC_INSTRUCTION_DSS(0, rd_load[i], rs1[i], rs2[i], 1);
    }

    for(int i=0; i<=17; i++){
        //load
        ROCC_INSTRUCTION_DSS(0, rd_store[i], rs1[i], rs2[i], 2);
    }

    printf("print result simulation\n");

    for(int i=0; i<=17; i++){
        printf("result_%d is: load response %d, expected 32\n", i, rd_load[i]);

    }

    for(int i=0; i<=17; i++){
        printf("result_%d is: store response %d, expected %d\n", i, rd_store[i], rs1[i]);

    }

    printf("End simulation\n");


    return 0;
}