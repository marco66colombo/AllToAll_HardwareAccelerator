#include <stdio.h>
#include <inttypes.h>
//#include "rocc.h"

#define N 4


int main(){

    printf("Start simulation\n");


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

    printf("\np= %d",p);
    //number of memory lines to be written
    int d = p*p;
    printf("\nd= %d",d);

    uint64_t rs1[d];
    uint64_t rs2[d];
    int rd[d];

    //manage rs1 values
    uint32_t leastSignificantWord =0;
    uint32_t mostSignificantWord=0;
    uint64_t load_value_rs1=0;

    //manage rs2 values
    uint16_t x_PE;
    uint16_t y_PE;
    uint32_t indexMem;
    uint64_t load_value_rs2;

    printf("vediamo\n");

    //populate load rs1,rs2 values
    for(unsigned int i=0; i<p; i++){
        mostSignificantWord = i;

        for(unsigned int j=0; j<p; j++){
            leastSignificantWord = (uint32_t)j;
            load_value_rs1 = (uint64_t) mostSignificantWord << 32 | leastSignificantWord;
            //load_value_rs1 = j;
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
    f = fopen("testPrintLoad4.txt", "w");


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



    printf("End simulation\n");

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
            //load_value_rs1 = i;
            rs1[(i*p)+j] = load_value_rs1;
        }
    }

    FILE *f1;
    f1 = fopen("testPrintStore4.txt", "w");


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
                            //"\nexpect(c.io.resp.valid, true.B)"
                            "\nexpect(c.io.resp.bits.data, %" PRIu64 "L.U)"
                            //"\nexpect(c.io.busy, false.B) "
                            //"\npoke(c.io.cmd.valid, false.B)"

                            //"\nstep(1)",

                    ,rs2[(i*p)+j],rs1[(i*p)+j]);
        }

    }

    fclose(f1);



    printf("End simulation\n");


    return 0;
}

