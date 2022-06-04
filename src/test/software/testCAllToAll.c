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

    //PROVO CON UNSIGNED E POI VEDO SE CAMBIARE
    /*
    unsigned long long int rs1[p];
    unsigned long long int rs2[p];
    */
    uint64_t rs1[d];
    uint64_t rs2[d];
    int rd[d];

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
    for(unsigned int i=0; i<p; i++){
        mostSignificantWord = i;
        for(unsigned int j=0; j<p; j++){
            leastSignificantWord = j;
            load_value_rs1 = (uint64_t) mostSignificantWord << 32 | leastSignificantWord;
            x_PE = x_coord(i);
            y_PE = y_coord(i);
            indexMem = j;
            load_value_rs2 = (uint64_t) indexMem << 32 | y_PE << 16 | x_PE;
            rs1[(i*p)+j] = load_value_rs1;
            rs2[(i*p)+j] = load_value_rs2;
            rd[(i*p)+j] = 0;
        }
    }

    //do the loads
    for(int i=0; i<p; i++){
        for(int j=0; j<p; j++){
            ROCC_INSTRUCTION_DSS(MEM_OPCODE, rd[(i*p)+j], rs1[(i*p)+j], rs2[(i*p)+j], LOAD_FUNC);
        }
    }

    printf("\nstart showing load results");

    //check rd results
    for(int i=0; i<p; i++){
        for(int j=0; j<p; j++){
            printf("\nresult_%u is: load response %d, expected 32", (i*p)+j, rd[(i*p)+j]);
        }
    }

    printf("\nLoad completed");

    
    //rd_action contains the response of the action
    int b,rd_action = 0;
    int a = 1;

    //do the AllToAll
    ROCC_INSTRUCTION_DSS(MEM_OPCODE, rd_action, a, b, 3);

    printf("\nresult of AllToAll is: response %u, expected 35", rd_action);

    //compute new values for rs2 (add offset)
    for(unsigned int i=0; i<p; i++){

        for(unsigned int j=0; j<p; j++){
            //populate rs2 with expected values after the AllToAll
            x_PE = x_coord(i);
            y_PE = y_coord(i);
            //result of AllToAll are stored p positions (N*N) -> different memory space between data before and after AllToAll
            indexMem = j + p;
            load_value_rs2 = (uint64_t) indexMem << 32 | y_PE << 16 | x_PE;
            rs2[(i*p)+j] =  load_value_rs2;
        }
    }

    uint64_t rd1[d];

    //do the stores, in store rs1 is useless
    for(int i=0; i<p; i++){
        for(int j=0; j<p; j++){
           ROCC_INSTRUCTION_DSS(MEM_OPCODE, rd1[(i*p)+j], a, rs2[(i*p)+j], STORE_FUNC);
        }
    }

    // I VALORI CHE LEGGO, PER OGNI PE, SARANNO N-PE (QUINDI AUMENTA SEQUENZIALMENTE) - INDIRIZZO DOVE ERANO SALVATI I DATI (== NUMERO DELLA PE)
    // put in rs1[] the expected return values of the stores
    for(unsigned int i=0; i<p; i++){
        leastSignificantWord = i;
        for(unsigned int j=0; j<p; j++){
            //populate rs1 with expected values after the AllToAll
            mostSignificantWord = j;
            load_value_rs1 = (uint64_t) mostSignificantWord << 32 | leastSignificantWord;
            rs1[(i*p)+j] = load_value_rs1;
        }
    }

    for(int i=0; i<p; i++){
        for(int j=0; j<p; j++){

            printf("\nresult_%u is: store response %" PRIu64 ", expected %" PRIu64 "", (i*p)+j, rd1[(i*p)+j], rs1[(i*p)+j]);
        }
    }


/*
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
*/

/*
    for(int i=0; i<p; i++){
        for(int j=0; j<p; j++){
            mostSignificantWord = i;
            leastSignificantWord = j;
            load_value_rs1 = (uint64_t) mostSignificantWord << 32 | leastSignificantWord;
            printf("\nresult_%u is: load response %u, expected %u", (i*p)+j, rd[(i*p)+j], rs1[(i*p)+j]);
        }
    }
*/

    

    printf("\nEnd simulation");


    return 0;
}
///////////////////////////////////////////
/*
    //populate load rs1,rs2 values
    for(unsigned int i=0; i<p; i++){
        mostSignificantWord = i;

        for(unsigned int j=0; j<p; j++){
            leastSignificantWord = (uint32_t)j;
            load_value_rs1 = (uint64_t) mostSignificantWord << 32 | leastSignificantWord;
            x_PE = x_coord(i);
            y_PE = y_coord(i);
            indexMem = j;
            load_value_rs2 = (uint64_t) indexMem << 32 | y_PE << 16 | x_PE;
            rs1[(i*p)+j] =  load_value_rs1;
            rs2[(i*p)+j] = load_value_rs2;
            rd[(i*p)+j] = 0;
        }
    }

    FILE *f;
    f = fopen("testPrintLoad.txt", "w");


    for(int i=0; i<p; i++){
        for(int j=0; j<p; j++){
            fprintf(f,   //"\npoke(c.io.cmd.valid, true.B)"
              //"\npoke(c.io.cmd.bits.inst.funct, \"b0000001\".U)"
              //"\npoke(c.io.cmd.bits.inst.opcode, \"b0001011\".U)"
              //"\npoke(c.io.cmd.bits.inst.rd, 3.U)"
              "\npoke(c.io.cmd.bits.rs1, %" PRIu64 "L.U)"
              "\npoke(c.io.cmd.bits.rs2,  %" PRIu64 "L.U)"
              "\nstep(1)",
              rs1[(i*p)+j],rs2[(i*p)+j]);
        }

    }

    fclose(f);




/////////////////////////////////////////////////////














    //creo valori di rs2 da cui fare store
    for(unsigned int i=0; i<p; i++){

        for(unsigned int j=0; j<p; j++){
            //populate rs2 with expected values after the AllToAll
            x_PE = x_coord(i);
            y_PE = y_coord(i);
            //result of AllToAll are stored p positions (N*N) -> different memory space between data before and after AllToAll
            indexMem = j + p;
            load_value_rs2 = (uint64_t) indexMem << 32 | y_PE << 16 | x_PE;
            rs2[(i*p)+j] =  load_value_rs2;
        }
    }

    // I VALORI CHE LEGGO, PER OGNI PE, SARANNO N-PE (QUINDI AUMENTA SEQUENZIALMENTE) - INDIRIZZO DOVE ERANO SALVATI I DATI (== NUMERO DELLA PE)
    for(unsigned int i=0; i<p; i++){
        leastSignificantWord = i;
        for(unsigned int j=0; j<p; j++){
            //populate rs1 with expected values after the AllToAll
            mostSignificantWord = j;
            load_value_rs1 = (uint64_t) mostSignificantWord << 32 | leastSignificantWord;
            rs1[(i*p)+j] = load_value_rs1;
        }
    }

    FILE *f1;
    f1 = fopen("testPrintStore.txt", "w");


    for(int i=0; i<p; i++){
        for(int j=0; j<p; j++){
            fprintf(f1,     //"\nexpect(c.io.cmd.ready, true.B)"
                            //"\nexpect(c.io.resp.valid, false.B)"
                            //"\nexpect(c.io.resp.bits.data, 0.U)"
                            //"\nexpect(c.io.busy, false.B)"

                            "\npoke(c.io.cmd.valid, true.B)"
                            //"\npoke(c.io.cmd.bits.inst.funct, \"b0000010\".U)"
                            //"\npoke(c.io.cmd.bits.inst.opcode, \"b0001011\".U)"
                            "\npoke(c.io.cmd.bits.rs2,  %" PRIu64 "L.U)"

                            "\nstep(1)"

                            //"\nexpect(c.io.cmd.ready, false.B)"
                            //"\nexpect(c.io.resp.valid, false.B)"
                            //"\nexpect(c.io.resp.bits.data, 33.U)"
                            //"\nexpect(c.io.busy, true.B)"
                            "\npoke(c.io.cmd.valid, false.B)"

                            "\nstep(1)"

                            //"\nexpect(c.io.cmd.ready, true.B)"
                            "\nexpect(c.io.resp.valid, true.B)"
                            "\nexpect(c.io.resp.bits.data, %" PRIu64 "L.U)"
                            //"\nexpect(c.io.busy, false.B) "
                            "\npoke(c.io.cmd.valid, false.B)"

                            "\nstep(1)",

                    rs2[(i*p)+j],rs1[(i*p)+j]);
        }

    }

    fclose(f1);


    */