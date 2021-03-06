/*
 * Copyright (c) 2022, SPAR-Internal
 * All rights reserved.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is furnished to do
 * so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 */


`timescale 1ns/1ps

module Top_tb;

parameter SIZE = 2;
parameter MAX_WORD_LENGTH = 32;

//inputs
reg clk, reset, start;
reg[31:0] instruction;
reg[5:0] LENGTH;



reg external;
reg[7:0] BRAM_i;
reg[7:0] BRAM_j;
reg WEA, WEB;
reg[9:0] ADDRA = -1;
reg[9:0] ADDRB = 5;
reg[15:0] DINA, DINB;
wire[15:0] DOUTA, DOUTB;
reg[159:0] ram[15:0];
reg[9:0] ram_ptr = 0;
integer i=0, j=0, k=0;
wire[0:SIZE*8-1] WOUT;
wire[0:SIZE*8-1] EOUT;
wire[0:4*SIZE*MAX_WORD_LENGTH-1] EAST_O;
wire[0:4*SIZE*MAX_WORD_LENGTH-1] WEST_O;
Top #(SIZE, MAX_WORD_LENGTH) TopTB(clk, reset, start, LENGTH, instruction, external, BRAM_i, BRAM_j, WEA, WEB, ADDRA, ADDRB, DINA, DINB, DOUTA, DOUTB, EAST_O, WEST_O);

initial begin
  clk = 1;
  forever #5 clk = !clk;
end

always @ (posedge clk) begin

    // for(i=0; i<1; i=i+1) begin
    //     for(j=0; j<1; j=j+1) begin
           
    //     end
    // end
    if(BRAM_i == 0 && BRAM_j == 0) begin
        if(!reset) begin
            WEA = 1;
            for(k=15; k>=0; k=k-1) begin  
                DINA[k] = ram[k][ram_ptr];
            end
            LENGTH = 32;
            ADDRA = ADDRA + 1;
            ram_ptr = ram_ptr + 1;
        end 
        else DINA = 0;
    end 
    if(BRAM_i == 0 && BRAM_j == 1) begin
        if(!reset) begin
            WEA = 1;
            for(k=15; k>=0; k=k-1) begin  
                DINA[k] = ram[k][ram_ptr];
            end
            LENGTH = 32;
            ADDRA = ADDRA + 1;
            ram_ptr = ram_ptr + 1;
        end 
        else DINA = 0;
    end 
    if(BRAM_i == 1 && BRAM_j == 0) begin
        if(!reset) begin
            WEA = 1;
            for(k=15; k>=0; k=k-1) begin  
                DINA[k] = ram[k][ram_ptr];
            end
            LENGTH = 32;
            ADDRA = ADDRA + 1;
            ram_ptr = ram_ptr + 1;
        end 
        else DINA = 0;
    end 
    if(BRAM_i == 1 && BRAM_j == 1) begin
        if(!reset) begin
            WEA = 1;
            for(k=15; k>=0; k=k-1) begin  
                DINA[k] = ram[k][ram_ptr];
            end
            LENGTH = 32;
            ADDRA = ADDRA + 1;
            ram_ptr = ram_ptr + 1;
        end 
        else DINA = 0;
    end 
end
initial
 
begin






// instruction = 32'b000010_00001_00011_0000_0000_0000_0001;
reset = 0; 
start = 0;//0
external = 1;
ram[0]  = 'h00000000_00000000_00000000_00000000_00000000;
ram[1]  = 'h00000001_00000001_00000000_00000000_00000000;
ram[2]  = 'h00000002_00000002_00000000_00000000_00000000;
ram[3]  = 'h00000003_00000003_00000000_00000000_00000000;
ram[4]  = 'h00000004_00000004_00000000_00000000_00000000;
ram[5]  = 'h00000005_00000005_00000000_00000000_00000000;
ram[6] 	= 'h00000006_00000006_00000000_00000000_00000000;
ram[7] 	= 'h00000007_00000007_00000000_00000000_00000000;
ram[8] 	= 'h00000008_00000008_00000000_00000000_00000000;
ram[9] 	= 'h00000009_00000009_00000000_00000000_00000000;
ram[10]	= 'h0000000a_0000000a_00000000_00000000_00000000;
ram[11]	= 'h0000000b_0000000b_00000000_00000000_00000000;
ram[12]	= 'h0000000c_0000000c_00000000_00000000_00000000;
ram[13]	= 'h0000000d_0000000d_00000000_00000000_00000000;
ram[14]	= 'h0000000e_0000000e_00000000_00000000_00000000;
ram[15]	= 'h0000000f_0000000f_00000000_00000000_00000000;
BRAM_i = 0;
BRAM_j = 0;
ADDRA = -1;
ram_ptr = 0;
#1610
ram[0]  = 'h00000000_00000000_00000000_00000000_00000000;
ram[1]  = 'h00000001_00000001_00000000_00000000_00000000;
ram[2]  = 'h00000002_00000002_00000000_00000000_00000000;
ram[3]  = 'h00000003_00000003_00000000_00000000_00000000;
ram[4]  = 'h00000004_00000004_00000000_00000000_00000000;
ram[5]  = 'h00000005_00000005_00000000_00000000_00000000;
ram[6] 	= 'h00000006_00000006_00000000_00000000_00000000;
ram[7] 	= 'h00000007_00000007_00000000_00000000_00000000;
ram[8] 	= 'h00000008_00000008_00000000_00000000_00000000;
ram[9] 	= 'h00000009_00000009_00000000_00000000_00000000;
ram[10]	= 'h0000000a_0000000a_00000000_00000000_00000000;
ram[11]	= 'h0000000b_0000000b_00000000_00000000_00000000;
ram[12]	= 'h0000000c_0000000c_00000000_00000000_00000000;
ram[13]	= 'h0000000d_0000000d_00000000_00000000_00000000;
ram[14]	= 'h0000000e_0000000e_00000000_00000000_00000000;
ram[15]	= 'h0000000f_0000000f_00000000_00000000_00000000;
BRAM_i = 0;
BRAM_j = 1;
ADDRA = -1;
ram_ptr = 0;
#1610
ram[0]  = 'h00000000_00000000_00000000_00000000_00000000;
ram[1]  = 'h00000001_00000001_00000000_00000000_00000000;
ram[2]  = 'h00000002_00000002_00000000_00000000_00000000;
ram[3]  = 'h00000003_00000003_00000000_00000000_00000000;
ram[4]  = 'h00000004_00000004_00000000_00000000_00000000;
ram[5]  = 'h00000005_00000005_00000000_00000000_00000000;
ram[6] 	= 'h00000006_00000006_00000000_00000000_00000000;
ram[7] 	= 'h00000007_00000007_00000000_00000000_00000000;
ram[8] 	= 'h00000008_00000008_00000000_00000000_00000000;
ram[9] 	= 'h00000009_00000009_00000000_00000000_00000000;
ram[10]	= 'h0000000a_0000000a_00000000_00000000_00000000;
ram[11]	= 'h0000000b_0000000b_00000000_00000000_00000000;
ram[12]	= 'h0000000c_0000000c_00000000_00000000_00000000;
ram[13]	= 'h0000000d_0000000d_00000000_00000000_00000000;
ram[14]	= 'h0000000e_0000000e_00000000_00000000_00000000;
ram[15]	= 'h0000000f_0000000f_00000000_00000000_00000000;
BRAM_i = 1;
BRAM_j = 0;
ADDRA = -1;
ram_ptr = 0;
#1610
ram[0]  = 'h00000000_00000000_00000000_00000000_00000000;
ram[1]  = 'h00000001_00000001_00000000_00000000_00000000;
ram[2]  = 'h00000002_00000002_00000000_00000000_00000000;
ram[3]  = 'h00000003_00000003_00000000_00000000_00000000;
ram[4]  = 'h00000004_00000004_00000000_00000000_00000000;
ram[5]  = 'h00000005_00000005_00000000_00000000_00000000;
ram[6] 	= 'h00000006_00000006_00000000_00000000_00000000;
ram[7] 	= 'h00000007_00000007_00000000_00000000_00000000;
ram[8] 	= 'h00000008_00000008_00000000_00000000_00000000;
ram[9] 	= 'h00000009_00000009_00000000_00000000_00000000;
ram[10]	= 'h0000000a_0000000a_00000000_00000000_00000000;
ram[11]	= 'h0000000b_0000000b_00000000_00000000_00000000;
ram[12]	= 'h0000000c_0000000c_00000000_00000000_00000000;
ram[13]	= 'h0000000d_0000000d_00000000_00000000_00000000;
ram[14]	= 'h0000000e_0000000e_00000000_00000000_00000000;
ram[15]	= 'h0000000f_0000000f_00000000_00000000_00000000;
BRAM_i = 1;
BRAM_j = 1;
ADDRA = -1;
ram_ptr = 0;
#1610
reset = 1;//1 
#2000
external = 0;
// DIN = 16'hFFFF;
instruction = (2<<26) + (1<<21) + (3<<16) + (4<<11);
start = 1;
#10 
start = 0;//1

// // DIN = 16'hFFFF;
// instruction = 32'h14221800;
// start = 1;
// #10 
// start = 0;//1
// #1000
// start = 1;
// #10 
// start = 0;//1
// #1000
// start = 1;
// #10 
// start = 0;//1

// instruction = 32'b000100_00001_00011_0000_0000_0000_0000;
// #30000
// start = 1;
// #10
// start = 0;
// #200000
// LENGTH = 16;
// reset = 0;
// start = 0;
// block_addr = 0;
// reg_addr = 0;
// #30000 
// reg_addr = 'h10;
// block_addr = 0;
// reset = 1;
// start = 1;
// #20000
// start = 0;


end

endmodule