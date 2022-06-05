#include <stdio.h>
#include <inttypes.h>
//#include "rocc.h"

#define N 4
#define dim_N 2


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

    FILE *f;
    f = fopen("testPrintLoadN2.txt", "w");


    for(int i=0; i<p; i++){
        for(int j=0; j<p; j++){
            for(unsigned int k=0; k<dim_N; k++){
                fprintf(f,   //"\npoke(c.io.cmd.valid, true.B)"
                //"\npoke(c.io.cmd.bits.inst.funct, \"b0000001\".U)"
                //"\npoke(c.io.cmd.bits.inst.opcode, \"b0001011\".U)"
                //"\npoke(c.io.cmd.bits.inst.rd, 3.U)"
                "\npoke(c.io.cmd.bits.rs1, %" PRIu64 "L.U)"
                "\npoke(c.io.cmd.bits.rs2,  %" PRIu64 "L.U)"
                "\nstep(1)",
                rs1[(i*p*dim_N)+(j*dim_N)+k],rs2[(i*p*dim_N)+(j*dim_N)+k]);
            }
        }

    }

    fclose(f);

    uint64_t indexAfter;


    printf("End simulation\n");

    //creo valori di rs2 da cui fare store
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

    FILE *f1;
    f1 = fopen("testPrintStoreN2.txt", "w");


    for(int i=0; i<p; i++){
        for(int j=0; j<p; j++){
            for(unsigned int k=0; k<dim_N; k++){
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

                        ,rs2[(i*p*dim_N)+(j*dim_N)+k],rs1[(i*p*dim_N)+(j*dim_N)+k]);
            }
        }

    }

    fclose(f1);



    printf("End simulation\n");


    return 0;
}

