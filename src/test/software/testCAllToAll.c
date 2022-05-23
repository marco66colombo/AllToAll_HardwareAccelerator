#include <stdio.h>
#include <inttypes.h>
#include "rocc.h"

#define CUSTOM_0 0b0001011

#define N 3
#define MEM_OPCODE 0
#define ACTION_OPCODE 1
#define LOAD_FUNC 1
#define STORE_FUNC 2


int main(){

    printf("Start simulation\n");

    //compute x coord from number of PE
    int x_coord(int i){
        return i%N;
    }

    //compute y coord from number of PE
    int y_coord(int i){
        return (N-1)-(i/N);
    }


    //number of PEs
    int p = N*N;
    //number of memory lines to be written
    int d = p*p;

    unsigned long int rs1[p];
    unsigned long int rs2[p];
    int rd[p];

    //manage rs1 values
    uint32_t leastSignificantWord;
    uint32_t mostSignificantWord;
    uint64_t load_value_rs1;

    //manage rs2 values
    uint16_t x_PE;
    uint16_t y_PE;
    uint32_t indexMem;
    uint64_t load_value_rs2;

    //populate load rs1,rs2 values
    for(int i=0; i<p; i++){
        mostSignificantWord = i;
        for(int j=0; j<p; j++){
            leastSignificantWord = j;
            load_value_rs1 = (uint64_t) mostSignificantWord << 32 | leastSignificantWord;
            x_PE = x_coord(i);
            y_PE = y_coord(i);
            indexMem = j;
            load_value_rs2 = (uint64_t) indexMem << 32 | y_PE << 16 | x_PE;
            rs1[(i*p)+j] = (unsigned long int) load_value_rs1;
            rs2[(i*p)+j] = (unsigned long int) load_value_rs2;
            rd[(i*p)+j] = 0;
        }
    }

    //do the loads
    for(int i=0; i<p; i++){
        for(int j=0; j<p; j++){
            ROCC_INSTRUCTION_DSS(MEM_OPCODE, rd[(i*p)+j], rs1[(i*p)+j], rs2[(i*p)+j], LOAD_FUNC);
        }
    }


    //check rd results
    for(int i=0; i<p; i++){
        for(int j=0; j<p; j++){
            printf("result_%u is: load response %d, expected 32\n", (i*p)+j, rd[(i*p)+j]);
        }
    }

    //rd_action contains the response of the action
    int a,b,rd_action = 0;

    //do the AllToAll
    ROCC_INSTRUCTION_DSS(ACTION_OPCODE, rd_action, a, b, 0);

    printf("result of AllToAll is: response %u, expected AAAA\n", rd_action);


    //do the stores, in store rs1 is useless
    for(int i=0; i<p; i++){
        for(int j=0; j<p; j++){
           ROCC_INSTRUCTION_DSS(MEM_OPCODE, rd[(i*p)+j], a, rs2[(i*p)+j], STORE_FUNC);
        }
    }


    for(int i=0; i<p; i++){
        for(int j=0; j<p; j++){
            //populate rs1 with expected values after the AllToAll
            mostSignificantWord = i;
            leastSignificantWord = j;
            load_value_rs1 = (uint64_t) mostSignificantWord << 32 | leastSignificantWord;
            rs1[(i*p)+j] = (unsigned long int) load_value_rs1;

            //populate rs2 with expected values after the AllToAll
            x_PE = x_coord(i);
            y_PE = y_coord(i);
            //result of AllToAll are stored p positions (N*N) -> different memory space between data before and after AllToAll
            indexMem = j + p;
            load_value_rs2 = (uint64_t) indexMem << 32 | y_PE << 16 | x_PE;
            rs2[(i*p)+j] = (unsigned long int) load_value_rs2;
        }
    }


    for(int i=0; i<p; i++){
        for(int j=0; j<p; j++){
            mostSignificantWord = i;
            leastSignificantWord = j;
            load_value_rs1 = (uint64_t) mostSignificantWord << 32 | leastSignificantWord;
            printf("result_%u is: load response %u, expected %u\n", (i*p)+j, rd[(i*p)+j], rs1[(i*p)+j]);
        }
    }


    printf("End simulation\n");


    return 0;
}
