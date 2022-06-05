#include <stdio.h>
#include <inttypes.h>
#include "rocc.h"

#define N 3
#define dim_N 2 //how many mem lines to be exchanged for each packet
#define MEM_OPCODE 0
#define ACTION_OPCODE 1
#define LOAD_FUNC 1
#define STORE_FUNC 2


int main(){

    printf("\nStart simulation");

    //compute x coord from number of PE
    int x_coord(int i){
        return i%N;
    }

    //compute y coord from number of PE
    int y_coord(int i){
        return (i/N);
    }


    //number of PEs
    int p = N*N;
    //number of memory lines to be written
    int d = p*p;

    uint64_t rs1[d*dim_N];
    uint64_t rs2[d*dim_N];
    int rd[d*dim_N];

    //manage rs1 values
    uint64_t NPE;
    uint64_t pos;
    uint64_t index;
    uint64_t load_value_rs1;

    //manage rs2 values
    uint64_t x_PE;
    uint64_t y_PE;
    uint64_t indexMem;
    uint64_t load_value_rs2;

    //populate load rs1,rs2 values
    for(unsigned int i=0; i<p; i++){
        NPE = i;
        for(unsigned int j=0; j<p; j++){
            for(unsigned int k=0; k<dim_N; k++){

                pos = k;
                index = j*dim_N + k;
                load_value_rs1 = (uint64_t) NPE << 48 | pos << 32 | index;
                x_PE = x_coord(i);
                y_PE = y_coord(i);
                indexMem = j*dim_N + k;
                load_value_rs2 = (uint64_t) indexMem << 32 | y_PE << 16 | x_PE;
                rs1[(i*p*dim_N)+(j*dim_N)+k] = load_value_rs1;
                rs2[(i*p*dim_N)+(j*dim_N)+k] = load_value_rs2;
                rd[(i*p*dim_N)+(j*dim_N)+k] = 0;
            }
        }
    }

    //do the loads
    for(int i=0; i<p; i++){
        for(int j=0; j<p; j++){
            for(int k=0; k<dim_N; k++){
                ROCC_INSTRUCTION_DSS(MEM_OPCODE, rd[(i*p*dim_N)+(j*dim_N)+k], rs1[(i*p*dim_N)+(j*dim_N)+k], rs2[(i*p*dim_N)+(j*dim_N)+k], LOAD_FUNC);
            }
        }
    }

    printf("\nstart showing load results");

    //check rd results
    for(int i=0; i<p; i++){
        for(int j=0; j<p; j++){
            for(int k=0; k<dim_N; k++){
                printf("\nresult_%u is: load response %d, expected 32", (i*p*dim_N)+(j*dim_N)+k, rd[(i*p*dim_N)+(j*dim_N)+k]);
            }
        }
    }

    printf("\nLoad completed");

    
    //rd_action contains the response of the action
    int b,rd_action = 0;
    int a = dim_N;

    //do the AllToAll
    ROCC_INSTRUCTION_DSS(MEM_OPCODE, rd_action, a, b, 3);

    printf("\nresult of AllToAll is: response %u, expected 35", rd_action);

    //compute new values for rs2 (add offset)
    for(unsigned int i=0; i<p; i++){

        for(unsigned int j=0; j<p; j++){
            for(unsigned int k=0; k<dim_N; k++){
                //populate rs2 with expected values after the AllToAll
                x_PE = x_coord(i);
                y_PE = y_coord(i);
                //result of AllToAll are stored p positions (N*N) -> different memory space between data before and after AllToAll
                indexMem = j*dim_N + k + p*dim_N;
                load_value_rs2 = (uint64_t) indexMem << 32 | y_PE << 16 | x_PE;
                rs2[(i*p*dim_N)+(j*dim_N)+k] =  load_value_rs2;
            }
        }
    }

    uint64_t rd1[d];

    //do the stores, in store rs1 is useless
    for(int i=0; i<p; i++){
        for(int j=0; j<p; j++){
            for(int k=0; k<dim_N; k++){
                ROCC_INSTRUCTION_DSS(MEM_OPCODE, rd1[(i*p*dim_N)+(j*dim_N)+k], a, rs2[(i*p*dim_N)+(j*dim_N)+k], STORE_FUNC);
            }
        }
    }

    uint64_t indexAfter;


    // I VALORI CHE LEGGO, PER OGNI PE, SARANNO N-PE (QUINDI AUMENTA SEQUENZIALMENTE) - INDIRIZZO DOVE ERANO SALVATI I DATI (== NUMERO DELLA PE)
    // put in rs1[] the expected return values of the stores
    for(unsigned int i=0; i<p; i++){
        //thisPE = i;
        for(unsigned int j=0; j<p; j++){
            for(unsigned int k=0; k<dim_N; k++){
                //populate rs1 with expected values after the AllToAll
                pos = k;
                index = j;
                indexAfter = i*dim_N + k;
                //load_value_rs1 = (uint64_t) mostSignificantWord << 32 | leastSignificantWord;
                load_value_rs1 = (uint64_t) index << 48 | pos << 32 | indexAfter;
                rs1[(i*p*dim_N)+(j*dim_N)+k] = load_value_rs1;
            }
        }
    }

    for(int i=0; i<p; i++){
        for(int j=0; j<p; j++){
            for(int k=0; k<dim_N; k++){
                printf("\nresult_%u is: store response %" PRIu64 ", expected %" PRIu64 "", (i*p*dim_N)+(j*dim_N)+k, rd1[(i*p*dim_N)+(j*dim_N)+k], rs1[(i*p*dim_N)+(j*dim_N)+k]);
            }
        }
    }



    printf("\nEnd simulation");


    return 0;
}
