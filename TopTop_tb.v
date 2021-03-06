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

module TopTop_tb;

//parameter SIZE = 1;
parameter[15:0] SIZE = 16'h0101;
parameter MAX_WORD_LENGTH = 32;
parameter Slice_Size = 16;
parameter PE_W = 1;
parameter PE_H = 1;
//inputs
reg clk, reset, start;
reg[31:0] instruction;
//reg[5:0] LENGTH;



reg external;
reg[7:0] Tile_i = 8'b0;
reg[7:0] Tile_j = 8'b0;
reg[7:0] BRAM_i = 8'b0;
reg[7:0] BRAM_j = 8'b0;
reg WEA, WEB, mode;
reg[9:0] ADDRA = -1;
reg[9:0] ADDRB = 5;
reg[15:0] DINA, DINB;
wire[15:0] DOUTA, DOUTB;
reg[159:0] ram[15:0];
reg[9:0] ram_ptr = 0;
reg[1:0] Activation_Function;
reg Tanh_In;
integer i=0, j=0, k=0;
// reg[0:4*SIZE*MAX_WORD_LENGTH-1] EAST_I;
// reg[0:4*SIZE*MAX_WORD_LENGTH-1] WEST_I;
// wire[0:4*SIZE*MAX_WORD_LENGTH-1] Y;

TopTop #(SIZE[15:8], SIZE[7:0], MAX_WORD_LENGTH, Slice_Size, PE_W, PE_H) TopTopTB(clk, reset, start, instruction, external, Tile_i, Tile_j, BRAM_i, BRAM_j, WEA, 1'b0, ADDRA, ADDRB, DINA, DINB, DOUTA, DOUTB, Activation_Function, Tanh_In);

initial begin
  clk = 1;
  forever #5 clk = !clk;
end

always @ (posedge clk) begin

    // for(i=0; i<1; i=i+1) begin
    //     for(j=0; j<1; j=j+1) begin
           
    //     end
    // end
    if(Tile_i == 0 && Tile_j == 0 && BRAM_i == 0 && BRAM_j == 0) begin
        if(!reset) begin
            WEA = 1;
            for(k=15; k>=0; k=k-1) begin  
                DINA[k] = ram[k][ram_ptr];
            end
           
            ADDRA = ADDRA + 1;
            ram_ptr = ram_ptr + 1;
        end 
        else DINA = 0;
    end 
	/*if(Tile_i == 0 && Tile_j == 0 && BRAM_i == 0 && BRAM_j == 1) begin
        if(!reset) begin
            WEA = 1;
            for(k=15; k>=0; k=k-1) begin  
                DINA[k] = ram[k][ram_ptr];
            end
            
            ADDRA = ADDRA + 1;
            ram_ptr = ram_ptr + 1;
        end 
        else DINA = 0;
    end 
    if(Tile_i == 0 && Tile_j == 0 && BRAM_i == 1 && BRAM_j == 0) begin
        if(!reset) begin
            WEA = 1;
            for(k=15; k>=0; k=k-1) begin  
                DINA[k] = ram[k][ram_ptr];
            end
           
            ADDRA = ADDRA + 1;
            ram_ptr = ram_ptr + 1;
        end 
        else DINA = 0;
    end 
    if(Tile_i == 0 && Tile_j == 0 && BRAM_i == 1 && BRAM_j == 1) begin
        if(!reset) begin
            WEA = 1;
            for(k=15; k>=0; k=k-1) begin  
                DINA[k] = ram[k][ram_ptr];
            end
           
            ADDRA = ADDRA + 1;
            ram_ptr = ram_ptr + 1;
        end 
        else DINA = 0;
    end 
	
	
	if(Tile_i == 0 && Tile_j == 1 && BRAM_i == 0 && BRAM_j == 0) begin
        if(!reset) begin
            WEA = 1;
            for(k=15; k>=0; k=k-1) begin  
                DINA[k] = ram[k][ram_ptr];
            end
           
            ADDRA = ADDRA + 1;
            ram_ptr = ram_ptr + 1;
        end 
        else DINA = 0;
    end 
    if(Tile_i == 0 && Tile_j == 1 && BRAM_i == 0 && BRAM_j == 1) begin
        if(!reset) begin
            WEA = 1;
            for(k=15; k>=0; k=k-1) begin  
                DINA[k] = ram[k][ram_ptr];
            end
            
            ADDRA = ADDRA + 1;
            ram_ptr = ram_ptr + 1;
        end 
        else DINA = 0;
    end 
    if(Tile_i == 0 && Tile_j == 1 && BRAM_i == 1 && BRAM_j == 0) begin
        if(!reset) begin
            WEA = 1;
            for(k=15; k>=0; k=k-1) begin  
                DINA[k] = ram[k][ram_ptr];
            end
           
            ADDRA = ADDRA + 1;
            ram_ptr = ram_ptr + 1;
        end 
        else DINA = 0;
    end 
    if(Tile_i == 0 && Tile_j == 1 && BRAM_i == 1 && BRAM_j == 1) begin
        if(!reset) begin
            WEA = 1;
            for(k=15; k>=0; k=k-1) begin  
                DINA[k] = ram[k][ram_ptr];
            end
           
            ADDRA = ADDRA + 1;
            ram_ptr = ram_ptr + 1;
        end 
        else DINA = 0;
    end
	
	
	if(Tile_i == 1 && Tile_j == 0 && BRAM_i == 0 && BRAM_j == 0) begin
        if(!reset) begin
            WEA = 1;
            for(k=15; k>=0; k=k-1) begin  
                DINA[k] = ram[k][ram_ptr];
            end
           
            ADDRA = ADDRA + 1;
            ram_ptr = ram_ptr + 1;
        end 
        else DINA = 0;
    end 
    if(Tile_i == 1 && Tile_j == 0 && BRAM_i == 0 && BRAM_j == 1) begin
        if(!reset) begin
            WEA = 1;
            for(k=15; k>=0; k=k-1) begin  
                DINA[k] = ram[k][ram_ptr];
            end
            
            ADDRA = ADDRA + 1;
            ram_ptr = ram_ptr + 1;
        end 
        else DINA = 0;
    end 
    if(Tile_i == 1 && Tile_j == 0 && BRAM_i == 1 && BRAM_j == 0) begin
        if(!reset) begin
            WEA = 1;
            for(k=15; k>=0; k=k-1) begin  
                DINA[k] = ram[k][ram_ptr];
            end
           
            ADDRA = ADDRA + 1;
            ram_ptr = ram_ptr + 1;
        end 
        else DINA = 0;
    end 
    if(Tile_i == 1 && Tile_j == 0 && BRAM_i == 1 && BRAM_j == 1) begin
        if(!reset) begin
            WEA = 1;
            for(k=15; k>=0; k=k-1) begin  
                DINA[k] = ram[k][ram_ptr];
            end
           
            ADDRA = ADDRA + 1;
            ram_ptr = ram_ptr + 1;
        end 
        else DINA = 0;
    end
	
	
	if(Tile_i == 1 && Tile_j == 1 && BRAM_i == 0 && BRAM_j == 0) begin
        if(!reset) begin
            WEA = 1;
            for(k=15; k>=0; k=k-1) begin  
                DINA[k] = ram[k][ram_ptr];
            end
           
            ADDRA = ADDRA + 1;
            ram_ptr = ram_ptr + 1;
        end 
        else DINA = 0;
    end 
    if(Tile_i == 1 && Tile_j == 1 && BRAM_i == 0 && BRAM_j == 1) begin
        if(!reset) begin
            WEA = 1;
            for(k=15; k>=0; k=k-1) begin  
                DINA[k] = ram[k][ram_ptr];
            end
            
            ADDRA = ADDRA + 1;
            ram_ptr = ram_ptr + 1;
        end 
        else DINA = 0;
    end 
    if(Tile_i == 1 && Tile_j == 1 && BRAM_i == 1 && BRAM_j == 0) begin
        if(!reset) begin
            WEA = 1;
            for(k=15; k>=0; k=k-1) begin  
                DINA[k] = ram[k][ram_ptr];
            end
           
            ADDRA = ADDRA + 1;
            ram_ptr = ram_ptr + 1;
        end 
        else DINA = 0;
    end 
    if(Tile_i == 1 && Tile_j == 1 && BRAM_i == 1 && BRAM_j == 1) begin
        if(!reset) begin
            WEA = 1;
            for(k=15; k>=0; k=k-1) begin  
                DINA[k] = ram[k][ram_ptr];
            end
           
            ADDRA = ADDRA + 1;
            ram_ptr = ram_ptr + 1;
        end 
        else DINA = 0;
    end*/
	
	
end
initial
 
begin
//LENGTH = 16;
Tanh_In = 0;
Activation_Function = 0;
// 1001001010100100010010011011011
//    100101010010001001001101101111

// WEST_I = 'h33333333deadbeef00000000ffffffff00000003000000070000000b0000000f;
// WEST_I = 'h000000000000000000000000000000005555555555555555555555552548936f;
// instruction = 32'b000010_00001_00011_0000_0000_0000_0001;
reset = 0; 
start = 0;//0
mode = 0;
external = 1;

ram[0]  = 'h00000000_00000001_00000000_00000000_00000000;
ram[1]  = 'h00000000_00000000_00000000_00000000_00000000;
ram[2]  = 'h00000000_00000000_00000000_00000000_00000000;
ram[3]  = 'h00000000_00000000_00000000_00000000_00000000;
ram[4]  = 'h00000000_00000000_00000000_00000000_00000000;
ram[5]  = 'h00000000_00000000_00000000_00000000_00000000;
ram[6] 	= 'h00000000_00000000_00000000_00000000_00000000;
ram[7] 	= 'h00000000_00000000_00000000_00000000_00000000;
ram[8] 	= 'h00000000_00000000_00000000_00000000_00000000;
ram[9] 	= 'h00000000_00000000_00000000_00000000_00000000;
ram[10]	= 'h00000000_00000000_00000000_00000000_00000000;
ram[11]	= 'h00000000_00000000_00000000_00000000_00000000;
ram[12]	= 'h00000000_00000000_00000000_00000000_00000000;
ram[13]	= 'h00000000_00000000_00000000_00000000_00000000;
ram[14]	= 'h00000000_00000000_00000000_00000000_00000000;
ram[15]	= 'h00000000_00000000_00000000_00000000_00000000;
BRAM_i = 8'b0;
BRAM_j = 8'b0;
Tile_i = 8'b0;
Tile_j = 8'b0;
ADDRA = -1;
ram_ptr = 0;
#1610


/*ram[0]  = 'h035410b3_0653989A_00000000_00000000_00000000;
ram[1]  = 'h053F366f_052153F3_00000000_00000000_00000000;
ram[2]  = 'h00050cec_00ff18b5_00000000_00000000_00000000;
ram[3]  = 'hf35404D7_36377BE8_00000000_00010000_00000000;
ram[4]  = 'h000053F3_000044A7_00000000_00000000_00000000;
ram[5]  = 'hffffef4f_00000032_00000000_00000000_00000000;
ram[6] 	= 'h00123400_00ba251c_00000000_00000000_00000000;
ram[7] 	= 'h00965300_00003637_00000000_00020000_00000000;
ram[8] 	= 'hff753200_00123462_00000000_00000000_00000000;
ram[9] 	= 'h00325800_00965312_00000000_00000000_00000000;
ram[10]	= 'h00a25d00_007532b7_00000000_00000000_00000000;
ram[11]	= 'h00d2b300_0000989A_00000000_00000000_00000000;
ram[12]	= 'hff501d00_ff3542a3_00000000_00000000_00000000;
ram[13]	= 'h00521000_00325785_00000000_00000000_00000000;
ram[14]	= 'h00862500_ffa254d6_00000000_00000000_00000000;
ram[15]	= 'hffffff00_0000ABD5_00000000_00000000_00000000;
BRAM_i = 8'b0;
BRAM_j = 8'b0;
Tile_i = 8'b0;
Tile_j = 8'b0;
ADDRA = -1;
ram_ptr = 0;
#1610
ram[0]  = 'h00f41500_00fffff4_00000000_00000000_00000000;
ram[1]  = 'h00000000_00000041_00000000_00000000_00000000;
ram[2]  = 'h00456000_00000052_00000000_00000000_00000000;
ram[3]  = 'h00f41500_00ffff25_00000000_00000000_00000000;
ram[4]  = 'h00000000_00000000_00000000_00000000_00000000;
ram[5]  = 'h00000123_00201103_00000000_00000000_00000000;
ram[6] 	= 'h00325800_00000058_00000000_00000000_00000000;
ram[7] 	= 'h00000000_00000041_00000000_00000000_00000000;
ram[8] 	= 'h00000000_00521023_00000000_00000000_00000000;
ram[9] 	= 'h00000000_00000000_00000000_00000000_00000000;
ram[10]	= 'h00521000_0032576a_00000000_00000000_00000000;
ram[11]	= 'h00000000_00000000_00000000_00000000_00000000;
ram[12]	= 'h00000000_00110021_00000000_00000000_00000000;
ram[13]	= 'h00000000_00000025_00000000_00000000_00000000;
ram[14]	= 'h00000000_00f6a058_00000000_00000000_00000000;
ram[15]	= 'h00000000_00000000_00000000_00000000_00000000;
BRAM_i = 8'b0;
BRAM_j = 8'b1;
Tile_i = 8'b0;
Tile_j = 8'b0;
ADDRA = -1;
ram_ptr = 0;
#1610
ram[0]  = 'h00000000_00000056_00000000_00000000_00000000;
ram[1]  = 'h00965300_00f41500_00000000_00020000_00000000;
ram[2]  = 'h00000000_00000065_00000000_00000000_00000000;
ram[3]  = 'h00000000_006543f5_00000000_00000000_00000000;
ram[4]  = 'h00000000_00000053_00000000_00000000_00000000;
ram[5]  = 'hff501d00_ff354200_00000000_00000000_00000000;
ram[6] 	= 'h00000000_000000ff_00000000_00000000_00000000;
ram[7] 	= 'h00000000_00000096_00000000_00000000_00000000;
ram[8] 	= 'h00f41500_00000012_00000000_00000000_00000000;
ram[9] 	= 'h00000000_00000000_00000000_00000000_00000000;
ram[10]	= 'h00000000_00000123_00000000_00000000_00000000;
ram[11]	= 'h00000000_00000965_00000000_00000000_00000000;
ram[12]	= 'h00000000_0456f415_00000000_00000000_00000000;
ram[13]	= 'h00000000_00000456_00000000_00000000_00000000;
ram[14]	= 'h00000000_000abc00_00000000_00000000_00000000;
ram[15]	= 'h00000000_00000000_00000000_00000000_00000000;
BRAM_i = 8'b1;
BRAM_j = 8'b0;
Tile_i = 8'b0;
Tile_j = 8'b0;
ADDRA = -1;
ram_ptr = 0;
#1610
ram[0]  = 'h00a25d00_0075320a_00000000_00000000_00000000;
ram[1]  = 'h00000000_00000053_00000000_00000000_00000000;
ram[2]  = 'h00123400_00ba2500_00000000_00000000_00000000;
ram[3]  = 'h000a2540_0000005d_00000000_00000000_00000000;
ram[4]  = 'h00000000_00000030_00000000_00000000_00000000;
ram[5]  = 'h00000000_00200075_00000000_00000000_00000000;
ram[6] 	= 'h00000000_00000034_00000000_00000000_00000000;
ram[7] 	= 'h00000000_00000086_00000000_00000000_00000000;
ram[8] 	= 'h00000000_00000000_00000000_00000000_00000000;
ram[9] 	= 'h00ba2500_ff862500_00000000_00000000_00000000;
ram[10]	= 'h00000000_00000000_00000000_00000000_00000000;
ram[11]	= 'h00000000_000008a0_00000000_00000000_00000000;
ram[12]	= 'h00000000_000000ba_00000000_00000000_00000000;
ram[13]	= 'h00000000_00000440_00000000_00000000_00000000;
ram[14]	= 'h00000000_000000a2_00000000_00000000_00000000;
ram[15]	= 'h00000000_00000550_00000000_00000000_00000000;
BRAM_i = 8'b1;
BRAM_j = 8'b1;
Tile_i = 8'b0;
Tile_j = 8'b0;
ADDRA = -1;
ram_ptr = 0;
#1610

ram[0]  = 'h00005678_12345678_00000000_00000000_00000000;
ram[1]  = 'h00354200_00d2b300_00000000_00000000_00000000;
ram[2]  = 'hff325700_00501d65_00000000_00000000_00000000;
ram[3]  = 'h00a25400_0065432b_00000000_00010000_00000000;
ram[4]  = 'h00ba2500_ff862586_00000000_00000000_00000000;
ram[5]  = 'h00f41500_00ffff00_00000000_00000000_00000000;
ram[6] 	= 'h00123400_00ba252b_00000000_00000000_00000000;
ram[7] 	= 'h00965300_00f41532_00000000_00020000_00000000;
ram[8] 	= 'hff753200_001234ba_00000000_00000000_00000000;
ram[9] 	= 'h00325800_00965396_00000000_00000000_00000000;
ram[10]	= 'h00a25d00_00753200_00000000_00000000_00000000;
ram[11]	= 'h00d2b300_00325825_00000000_00000000_00000000;
ram[12]	= 'hff501d00_ff354234_00000000_00000000_00000000;
ram[13]	= 'h00521000_00325752_00000000_00000000_00000000;
ram[14]	= 'h00862500_ffa25400_00000000_00000000_00000000;
ram[15]	= 'hffffff00_00521035_00000000_00000000_00000000;
BRAM_i = 8'b0;
BRAM_j = 8'b0;
Tile_i = 8'b0;
Tile_j = 8'b1;
ADDRA = -1;
ram_ptr = 0;
#1610
ram[0]  = 'h00f41500_00fabf00_00000000_00000000_00000000;
ram[1]  = 'h00000000_000000ff_00000000_00000000_00000000;
ram[2]  = 'h00000000_000000ab_00000000_00000000_00000000;
ram[3]  = 'h00f41500_00ffff00_00000000_00000000_00000000;
ram[4]  = 'h00000000_000000f4_00000000_00000000_00000000;
ram[5]  = 'h00000000_00034015_00000000_00000000_00000000;
ram[6] 	= 'h00325800_00000024_00000000_00000000_00000000;
ram[7] 	= 'h00000000_00000325_00000000_00000000_00000000;
ram[8] 	= 'h00000000_00521032_00000000_00000000_00000000;
ram[9] 	= 'h00000000_00000025_00000000_00000000_00000000;
ram[10]	= 'h00521000_003257a0_00000000_00000000_00000000;
ram[11]	= 'h00000000_0000980b_00000000_00000000_00000000;
ram[12]	= 'h00000000_000005ab_00000000_00000000_00000000;
ram[13]	= 'h00000000_00000021_00000000_00000000_00000000;
ram[14]	= 'h00000000_000ab300_00000000_00000000_00000000;
ram[15]	= 'h00000000_00030020_00000000_00000000_00000000;
BRAM_i = 8'b0;
BRAM_j = 8'b1;
Tile_i = 8'b0;
Tile_j = 8'b1;
ADDRA = -1;
ram_ptr = 0;
#1610
ram[0]  = 'h00000000_00380032_00000000_00000000_00000000;
ram[1]  = 'h00965300_00f4150a_00000000_00020000_00000000;
ram[2]  = 'h00000000_000000f5_00000000_00000000_00000000;
ram[3]  = 'h00000000_00654300_00000000_00000000_00000000;
ram[4]  = 'h00000000_00009653_00000000_00000000_00000000;
ram[5]  = 'hff501d00_ff354235_00000000_00000000_00000000;
ram[6] 	= 'h00000000_000000f4_00000000_00000000_00000000;
ram[7] 	= 'h00000000_00000008_00000000_00000000_00000000;
ram[8] 	= 'h00f41500_00000054_00000000_00000000_00000000;
ram[9] 	= 'h00000000_00000043_00000000_00000000_00000000;
ram[10]	= 'h00000000_00000055_00000000_00000000_00000000;
ram[11]	= 'h00000000_00098042_00000000_00000000_00000000;
ram[12]	= 'h00000000_00005550_00000000_00000000_00000000;
ram[13]	= 'h00000000_000300ff_00000000_00000000_00000000;
ram[14]	= 'h00000000_00002010_00000000_00000000_00000000;
ram[15]	= 'h00000000_00504020_00000000_00000000_00000000;
BRAM_i = 8'b1;
BRAM_j = 8'b0;
Tile_i = 8'b0;
Tile_j = 8'b1;
ADDRA = -1;
ram_ptr = 0;
#1610
ram[0]  = 'h00a25d00_00753204_00000000_00000000_00000000;
ram[1]  = 'h00000000_00000006_00000000_00000000_00000000;
ram[2]  = 'h00123400_00ba2500_00000000_00000000_00000000;
ram[3]  = 'h000a2540_00000021_00000000_00000000_00000000;
ram[4]  = 'h00000000_0003005d_00000000_00000000_00000000;
ram[5]  = 'h00000000_00000034_00000000_00000000_00000000;
ram[6] 	= 'h00000000_00000000_00000000_00000000_00000000;
ram[7] 	= 'h00000000_000000a2_00000000_00000000_00000000;
ram[8] 	= 'h00000000_0000ba25_00000000_00000000_00000000;
ram[9] 	= 'h00ba2500_ff862500_00000000_00000000_00000000;
ram[10]	= 'h00000000_000000f8_00000000_00000000_00000000;
ram[11]	= 'h00000000_00004040_00000000_00000000_00000000;
ram[12]	= 'h00000000_00000d30_00000000_00000000_00000000;
ram[13]	= 'h00000000_00ab00ab_00000000_00000000_00000000;
ram[14]	= 'h00000000_00000209_00000000_00000000_00000000;
ram[15]	= 'h00000000_00098025_00000000_00000000_00000000;
BRAM_i = 8'b1;
BRAM_j = 8'b1;
Tile_i = 8'b0;
Tile_j = 8'b1;
ADDRA = -1;
ram_ptr = 0;
#1610


ram[0]  = 'h00005678_12345678_00000000_00000000_00000000;
ram[1]  = 'h00354200_00d2b31d_00000000_00000000_00000000;
ram[2]  = 'hff325700_00501df3_00000000_00000000_00000000;
ram[3]  = 'h00a25400_0065432b_00000000_00010000_00000000;
ram[4]  = 'h00ba2500_ff862565_00000000_00000000_00000000;
ram[5]  = 'h00f41500_00ffff32_00000000_00000000_00000000;
ram[6] 	= 'h00123400_00ba2541_00000000_00000000_00000000;
ram[7] 	= 'h00965300_00f41512_00000000_00020000_00000000;
ram[8] 	= 'hff753200_00123400_00000000_00000000_00000000;
ram[9] 	= 'h00325800_009653f2_00000000_00000000_00000000;
ram[10]	= 'h00a25d00_00753275_00000000_00000000_00000000;
ram[11]	= 'h00d2b300_003258f4_00000000_00000000_00000000;
ram[12]	= 'hff501d00_ff354225_00000000_00000000_00000000;
ram[13]	= 'h00521000_00325742_00000000_00000000_00000000;
ram[14]	= 'h00862500_ffa25400_00000000_00000000_00000000;
ram[15]	= 'hffffff00_00521086_00000000_00000000_00000000;
BRAM_i = 8'b0;
BRAM_j = 8'b0;
Tile_i = 8'b1;
Tile_j = 8'b0;
ADDRA = -1;
ram_ptr = 0;
#1610
ram[0]  = 'h00f41500_00ffff62_00000000_00000000_00000000;
ram[1]  = 'h00000000_00000987_00000000_00000000_00000000;
ram[2]  = 'h00000000_000000ff_00000000_00000000_00000000;
ram[3]  = 'h00f41500_00ffff00_00000000_00000000_00000000;
ram[4]  = 'h00000000_00000015_00000000_00000000_00000000;
ram[5]  = 'h00000000_000000f4_00000000_00000000_00000000;
ram[6] 	= 'h00325800_00520052_00000000_00000000_00000000;
ram[7] 	= 'h00000000_00000050_00000000_00000000_00000000;
ram[8] 	= 'h00000000_00521207_00000000_00000000_00000000;
ram[9] 	= 'h00000000_00000032_00000000_00000000_00000000;
ram[10]	= 'h00521000_00325701_00000000_00000000_00000000;
ram[11]	= 'h00000000_00000025_00000000_00000000_00000000;
ram[12]	= 'h00000000_00066057_00000000_00000000_00000000;
ram[13]	= 'h00000000_00000050_00000000_00000000_00000000;
ram[14]	= 'h00000000_00043021_00000000_00000000_00000000;
ram[15]	= 'h00000000_00000770_00000000_00000000_00000000;
BRAM_i = 8'b0;
BRAM_j = 8'b1;
Tile_i = 8'b1;
Tile_j = 8'b0;
ADDRA = -1;
ram_ptr = 0;
#1610
ram[0]  = 'h00000000_00000012_00000000_00000000_00000000;
ram[1]  = 'h00965300_00f41531_00000000_00020000_00000000;
ram[2]  = 'h00000000_00000042_00000000_00000000_00000000;
ram[3]  = 'h00000000_00654396_00000000_00000000_00000000;
ram[4]  = 'h00000000_00000054_00000000_00000000_00000000;
ram[5]  = 'hff501d00_ff354200_00000000_00000000_00000000;
ram[6] 	= 'h00000000_00000065_00000000_00000000_00000000;
ram[7] 	= 'h00000000_00000023_00000000_00000000_00000000;
ram[8] 	= 'h00f41500_000400f4_00000000_00000000_00000000;
ram[9] 	= 'h00000000_00000007_00000000_00000000_00000000;
ram[10]	= 'h00000000_00230065_00000000_00000000_00000000;
ram[11]	= 'h00000000_00000000_00000000_00000000_00000000;
ram[12]	= 'h00000000_00000608_00000000_00000000_00000000;
ram[13]	= 'h00000000_00200415_00000000_00000000_00000000;
ram[14]	= 'h00000000_0a0b00cd_00000000_00000000_00000000;
ram[15]	= 'h00000000_0000a051_00000000_00000000_00000000;
BRAM_i = 8'b1;
BRAM_j = 8'b0;
Tile_i = 8'b1;
Tile_j = 8'b0;
ADDRA = -1;
ram_ptr = 0;
#1610
ram[0]  = 'h00a25d00_007532ba_00000000_00000000_00000000;
ram[1]  = 'h00000000_00000a25_00000000_00000000_00000000;
ram[2]  = 'h00123400_00ba2562_00000000_00000000_00000000;
ram[3]  = 'h000a2540_00001234_00000000_00000000_00000000;
ram[4]  = 'h00000000_00b000a2_00000000_00000000_00000000;
ram[5]  = 'h00000000_000000f8_00000000_00000000_00000000;
ram[6] 	= 'h00000000_000000a0_00000000_00000000_00000000;
ram[7] 	= 'h00000000_00000086_00000000_00000000_00000000;
ram[8] 	= 'h00000000_000000ff_00000000_00000000_00000000;
ram[9] 	= 'h00ba2500_ff862500_00000000_00000000_00000000;
ram[10]	= 'h00000000_000000da_00000000_00000000_00000000;
ram[11]	= 'h00000000_0c000025_00000000_00000000_00000000;
ram[12]	= 'h00000000_00000c01_00000000_00000000_00000000;
ram[13]	= 'h00000000_0200b00b_00000000_00000000_00000000;
ram[14]	= 'h00000000_00d006da_00000000_00000000_00000000;
ram[15]	= 'h00000000_00da0402_00000000_00000000_00000000;
BRAM_i = 8'b1;
BRAM_j = 8'b1;
Tile_i = 8'b1;
Tile_j = 8'b0;
ADDRA = -1;
ram_ptr = 0;
#1610


ram[0]  = 'h00005678_12345678_00000000_00000000_00000000;
ram[1]  = 'h00354200_00d2b300_00000000_00000000_00000000;
ram[2]  = 'hff325700_00501d62_00000000_00000000_00000000;
ram[3]  = 'h00a25400_006543ff_00000000_00010000_00000000;
ram[4]  = 'h00ba2500_ff8625ba_00000000_00000000_00000000;
ram[5]  = 'h00f41500_00ffff50_00000000_00000000_00000000;
ram[6] 	= 'h00123400_00ba2500_00000000_00000000_00000000;
ram[7] 	= 'h00965300_00f41594_00000000_00020000_00000000;
ram[8] 	= 'hff753200_00123441_00000000_00000000_00000000;
ram[9] 	= 'h00325800_009454a2_00000000_00000000_00000000;
ram[10]	= 'h00a25d00_00743200_00000000_00000000_00000000;
ram[11]	= 'h00d2b300_00323454_00000000_00000000_00000000;
ram[12]	= 'hff501d00_ff354232_00000000_00000000_00000000;
ram[13]	= 'h00521000_00323732_00000000_00000000_00000000;
ram[14]	= 'h00862500_ffa25400_00000000_00000000_00000000;
ram[15]	= 'hffffff00_00523086_00000000_00000000_00000000;
BRAM_i = 8'b0;
BRAM_j = 8'b0;
Tile_i = 8'b1;
Tile_j = 8'b1;
ADDRA = -1;
ram_ptr = 0;
#1610
ram[0]  = 'h00f41500_00ffff12_00000000_00000000_00000000;
ram[1]  = 'h00000000_000e0043_00000000_00000000_00000000;
ram[2]  = 'h00000000_00000ff5_00000000_00000000_00000000;
ram[3]  = 'h00f41500_00fffd0b_00000000_00000000_00000000;
ram[4]  = 'h00000000_000000ad_00000000_00000000_00000000;
ram[5]  = 'h00000000_0000d006_00000000_00000000_00000000;
ram[6] 	= 'h00325800_00a00027_00000000_00000000_00000000;
ram[7] 	= 'h00000000_00000018_00000000_00000000_00000000;
ram[8] 	= 'h00000000_00521069_00000000_00000000_00000000;
ram[9] 	= 'h00000000_0000003b_00000000_00000000_00000000;
ram[10]	= 'h00521000_0032570a_00000000_00000000_00000000;
ram[11]	= 'h00000000_00000012_00000000_00000000_00000000;
ram[12]	= 'h00000000_00b000cc_00000000_00000000_00000000;
ram[13]	= 'h00000000_00000a03_00000000_00000000_00000000;
ram[14]	= 'h00000000_00b000ab_00000000_00000000_00000000;
ram[15]	= 'h00000000_000d0cc6_00000000_00000000_00000000;
BRAM_i = 8'b0;
BRAM_j = 8'b1;
Tile_i = 8'b1;
Tile_j = 8'b1;
ADDRA = -1;
ram_ptr = 0;
#1610
ram[0]  = 'h00000000_000000f4_00000000_00000000_00000000;
ram[1]  = 'h00965300_00f41565_00000000_00020000_00000000;
ram[2]  = 'h00000000_00000041_00000000_00000000_00000000;
ram[3]  = 'h00000000_00654300_00000000_00000000_00000000;
ram[4]  = 'h00000000_000000f5_00000000_00000000_00000000;
ram[5]  = 'hff501d00_ff354215_00000000_00000000_00000000;
ram[6] 	= 'h00000000_00000000_00000000_00000000_00000000;
ram[7] 	= 'h00000000_00000096_00000000_00000000_00000000;
ram[8] 	= 'h00f41500_0001004a_00000000_00000000_00000000;
ram[9] 	= 'h00000000_006000b5_00000000_00000000_00000000;
ram[10]	= 'h00000000_00000032_00000000_00000000_00000000;
ram[11]	= 'h00000000_00010245_00000000_00000000_00000000;
ram[12]	= 'h00000000_00000003_00000000_00000000_00000000;
ram[13]	= 'h00000000_00305054_00000000_00000000_00000000;
ram[14]	= 'h00000000_00200060_00000000_00000000_00000000;
ram[15]	= 'h00000000_00045401_00000000_00000000_00000000;
BRAM_i = 8'b1;
BRAM_j = 8'b0;
Tile_i = 8'b1;
Tile_j = 8'b1;
ADDRA = -1;
ram_ptr = 0;
#1610
ram[0]  = 'h00a25d00_00753200_00000000_00000000_00000000;
ram[1]  = 'h00000000_00000023_00000000_00000000_00000000;
ram[2]  = 'h00123400_00ba2502_00000000_00000000_00000000;
ram[3]  = 'h000a2540_00000a25_00000000_00000000_00000000;
ram[4]  = 'h00000000_000000f8_00000000_00000000_00000000;
ram[5]  = 'h00000000_0000001f_00000000_00000000_00000000;
ram[6] 	= 'h00000000_000070a2_00000000_00000000_00000000;
ram[7] 	= 'h00000000_00000027_00000000_00000000_00000000;
ram[8] 	= 'h00000000_000000c1_00000000_00000000_00000000;
ram[9] 	= 'h00ba2500_ff86275d_00000000_00000000_00000000;
ram[10]	= 'h00000000_00c000d0_00000000_00000000_00000000;
ram[11]	= 'h00000000_0000c039_00000000_00000000_00000000;
ram[12]	= 'h00000000_0d0900e5_00000000_00000000_00000000;
ram[13]	= 'h00000000_00b00a61_00000000_00000000_00000000;
ram[14]	= 'h00000000_00080081_00000000_00000000_00000000;
ram[15]	= 'h00000000_00a0b092_00000000_00000000_00000000;
BRAM_i = 8'b1;
BRAM_j = 8'b1;
Tile_i = 8'b1;
Tile_j = 8'b1;
ADDRA = -1;
ram_ptr = 0;
#1610
*/

DINA = 0;
#10
external = 0;
#10000
reset = 1;//1 
#2000

// // DIN = 16'hFFFF;
// instruction = (2<<26) + (1<<21) + (3<<16) + (4<<11);
// start = 1;
// #124
// start = 0;//1
#1000

Activation_Function = 2'b0;
Tanh_In = 0;
//////////////////////////////////////////////////////
//instruction = (5<<26) + (1<<21) + (3<<16) + (0<<11);
//instruction = (2<<26) + (1<<21) + (3<<16) + (4<<11);
//start = 1;
//#100 start = 0;
//#10000
//instruction = (2<<26) + (2<<21) + (3<<16) + (3<<11);
//start = 1;
//#100 start = 0;
//#1000
instruction = (5<<26) + (3<<21) + (3<<16) + (0<<11);
start = 1;
#100 start = 0;
#1000
instruction = (7<<26) + (3<<21) + (3<<16) + (0<<11);
start = 1;
#100 start = 0;
//////////////////////////////////////////////////
// #10000
// //////////////////////////////////////////////////////
// instruction = (2<<26) + (2<<21) + (3<<16) + (4<<11);
// start = 1;
// #100 start = 0;
// ////////////////////////////////////////////////////
// ////////////////////////////////////////////////////
//#10000
//Activation_Function = 2;
//Tanh_In = 1;
// //////////////////////////////////////////////////////
// //////////////////////////////////////////////////////
// instruction = (8<<26) + (1<<21) + (1<<16) + (0<<11);
// start = 1;
// #10 start = 0;//1
// //////////////////////////////////////////////////////
// #10000
// //////////////////////////////////////////////////////
// instruction = (7<<26) + (1<<21) + (1<<16) + (0<<11);
// start = 1;
// #10 start = 0;//1
// // //////////////////////////////////////////////////////






// #1000
// instruction = (7<<26) + (0<<21) + (0<<16) + (0<<11);
// #100
// start = 1;
// #124
// start = 0;//1
// #1000
// start = 1;
// #124
// start = 0;//1

// reset = 0;
// #1000
// reset = 1;
// #1000
// start = 1;
// #113
// start = 0;//1
// // mode = 1;
// // #100
// start = 1;
// #10
// start = 0;
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