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


module Top #(parameter[7:0] ARRAY_DIM = 8'b10,parameter[7:0] TILE_DIM =  8'b10, parameter MAX_WORD_LENGTH = 32, parameter Slice_Size = 4, parameter PE_W = 2, parameter PE_H = 2)
		(
			input clk,
			input reset,
			input start,
			input[31:0] instruction,
			input external,
			input[7:0] Tile_i,
			input[7:0] Tile_j,
			input[7:0] Block_i,
			input[7:0] Block_j,
			input WEA,
            input WEB,
			input[9:0] ADDRA,
            input[9:0] ADDRB,
            input[15:0] DIA,
			input[15:0] DIB,
			output[15:0] DOA,
            output[15:0] DOB,
            input[0:PE_H*ARRAY_DIM*TILE_DIM*MAX_WORD_LENGTH-1] EAST_I,
			input[0:PE_H*ARRAY_DIM*TILE_DIM*MAX_WORD_LENGTH-1] WEST_I,
			input[0:PE_W*ARRAY_DIM*TILE_DIM*MAX_WORD_LENGTH-1] SOUTH_I,
			input[0:PE_W*ARRAY_DIM*TILE_DIM*MAX_WORD_LENGTH-1] NORTH_I,
			output[0:PE_H*ARRAY_DIM*TILE_DIM*MAX_WORD_LENGTH-1] EAST_O,
			output[0:PE_H*ARRAY_DIM*TILE_DIM*MAX_WORD_LENGTH-1] WEST_O,
			output[0:PE_W*ARRAY_DIM*TILE_DIM*MAX_WORD_LENGTH-1] SOUTH_O,
			output[0:PE_W*ARRAY_DIM*TILE_DIM*MAX_WORD_LENGTH-1] NORTH_O
		);
	
//parameter[7:0] ARRAY_DIM = DIM[15:8];
//parameter[7:0] TILE_DIM = DIM[7:0];

wire[(TILE_DIM*(Slice_Size*PE_H*2))-1:0] EtoW[ARRAY_DIM-1:0][ARRAY_DIM-1:0];
wire[(TILE_DIM*(Slice_Size*PE_H*2))-1:0] WtoE[ARRAY_DIM-1:0][ARRAY_DIM-1:0];
wire[(TILE_DIM*(Slice_Size*PE_W*2))-1:0] StoN[ARRAY_DIM-1:0][ARRAY_DIM-1:0];
wire[(TILE_DIM*(Slice_Size*PE_W*2))-1:0] NtoS[ARRAY_DIM-1:0][ARRAY_DIM-1:0];

wire[15:0] wDOA[ARRAY_DIM-1:0][ARRAY_DIM-1:0];
wire[15:0] wDOB[ARRAY_DIM-1:0][ARRAY_DIM-1:0];

wire[0:ARRAY_DIM*TILE_DIM*(Slice_Size*PE_H*2)-1] WOUT;
wire[0:ARRAY_DIM*TILE_DIM*(Slice_Size*PE_H*2)-1] EOUT;
wire[0:ARRAY_DIM*TILE_DIM*(Slice_Size*PE_W*2)-1] SOUT;
wire[0:ARRAY_DIM*TILE_DIM*(Slice_Size*PE_W*2)-1] NOUT;
wire[0:ARRAY_DIM*TILE_DIM*(Slice_Size*PE_H*2)-1] WIN;
wire[0:ARRAY_DIM*TILE_DIM*(Slice_Size*PE_H*2)-1] EIN;
wire[0:ARRAY_DIM*TILE_DIM*(Slice_Size*PE_W*2)-1] SIN;
wire[0:ARRAY_DIM*TILE_DIM*(Slice_Size*PE_W*2)-1] NIN;

wire[9:0] addra;
wire[9:0] addrb;
wire[1:0] east_mode;
wire[1:0] west_mode;
wire[1:0] south_mode;
wire[1:0] north_mode;

wire[3:0] alu_op;
//other helper signals
wire[9:0] count; //debug: was [6:0]
wire[2:0] state; //debug:
wire [31:0] rs1_cnt;
wire [31:0] rs2_cnt;

generate

genvar gi;
genvar gj;

//Controller #(MAX_WORD_LENGTH) FSM
BS_Controller #(MAX_WORD_LENGTH, Slice_Size) FSM
		(
        clk, 
        reset,
        start,
		// input[5:0] LENGTH,
		instruction,
		
		//alu control
        alu_op,

		//bram control
        wea,
		web,
		addra, 
		addrb,

		//move control
		east, 
		west, 
		south, 
		north,
		east_mode,
		west_mode,
		south_mode,
		north_mode,

		//other helper signals
		count,
		// output reg bram_init_flag,
		// output reg[15:0] bram_init_d,
		// output reg finish_flag,
		state,
		rs1_cnt,
		rs2_cnt
			
		);

PSC_Tile_Array #(MAX_WORD_LENGTH, ARRAY_DIM, TILE_DIM, Slice_Size, PE_H) WEST_IO
//Parallel_Serial_Converter # (ARRAY_DIM*TILE_DIM, MAX_WORD_LENGTH, MAX_WORD_LENGTH) WEST_IO //debug
(
	clk,  
	reset, 
    west_mode,
    start,
    ,
    WOUT,
    WEST_I,
    WIN,
    WEST_O
);

PSC_Tile_Array #(MAX_WORD_LENGTH, ARRAY_DIM, TILE_DIM, Slice_Size, PE_H) EAST_IO
//Parallel_Serial_Converter # (ARRAY_DIM*TILE_DIM, MAX_WORD_LENGTH, MAX_WORD_LENGTH) EAST_IO //debug
(
	clk,  
	reset, 
    east_mode,
    start,
    ,
    EOUT,
    EAST_I,
    EIN,
    EAST_O
);

PSC_Tile_Array #(MAX_WORD_LENGTH, ARRAY_DIM, TILE_DIM, Slice_Size, PE_W) NORTH_IO
//Parallel_Serial_Converter # (ARRAY_DIM*TILE_DIM, MAX_WORD_LENGTH, MAX_WORD_LENGTH) NORTH_IO //debug
(
	clk,  
	reset, 
    north_mode,
    start,
    ,
    NOUT,
    NORTH_I,
    NIN,
    NORTH_O
);

PSC_Tile_Array #(MAX_WORD_LENGTH, ARRAY_DIM, TILE_DIM, Slice_Size, PE_W) SOUTH_IO
//Parallel_Serial_Converter # (ARRAY_DIM*TILE_DIM, MAX_WORD_LENGTH, MAX_WORD_LENGTH) SOUTH_IO //debug
(
	clk,  
	reset, 
    south_mode,
    start,
    ,
    SOUT,
    SOUTH_I,
    SIN,
    SOUTH_O
);

for (gi=0; gi<ARRAY_DIM; gi=gi+1) begin : ROW
	for (gj=0; gj<ARRAY_DIM; gj=gj+1) begin : COL

		Tile #(TILE_DIM, MAX_WORD_LENGTH, Slice_Size, PE_W, PE_H) tile(
				clk, 
				reset,
				start,
				instruction,
				external,
				Block_i,
				Block_j,
				(gi==Tile_i && gj==Tile_j? (external? WEA : wea) : wea),            //debug: was WEA,
				(gi==Tile_i && gj==Tile_j? (external? WEB : web) : web),            //debug: was WEB,
				(gi==Tile_i && gj==Tile_j? (external? ADDRA : addra) : addra),      //debug: was ADDRA,
				(gi==Tile_i && gj==Tile_j? (external? ADDRB : addrb) : addrb),      //debug: was ADDRB,
				gi==Tile_i && gj==Tile_j? DIA : 16'hzzzz,                           //debug: was DIA,
				gi==Tile_i && gj==Tile_j? DIB : 16'hzzzz,                           //debug: was DIB,
				wDOA[gi][gj],
            	wDOB[gi][gj],
				gj==ARRAY_DIM-1              ? EIN[(Slice_Size*PE_H*2)*TILE_DIM*gi+:(Slice_Size*PE_H*2)*TILE_DIM] : WtoE[gi][gj+1],//Ein
				gj==0                    	 ? WIN[(Slice_Size*PE_H*2)*TILE_DIM*gi+:(Slice_Size*PE_H*2)*TILE_DIM] : EtoW[gi][gj-1],//Win
				gi==0   			      	 ? NIN[(Slice_Size*PE_W*2)*TILE_DIM*gj+:(Slice_Size*PE_W*2)*TILE_DIM] : StoN[gi-1][gj],//Nin was gi+1
				gi==ARRAY_DIM-1              ? SIN[(Slice_Size*PE_W*2)*TILE_DIM*gj+:(Slice_Size*PE_W*2)*TILE_DIM] : NtoS[gi+1][gj],//Sin was gi-1
				EtoW[gi][gj], //Eout
				WtoE[gi][gj], //Wout
				NtoS[gi][gj], //Nout
				StoN[gi][gj]  //Sout
		
		);
		assign EOUT[(Slice_Size*PE_H*2)*TILE_DIM*gi+:(Slice_Size*PE_H*2)*TILE_DIM] = EtoW[gi][ARRAY_DIM-1]; //debug: was [ARRAY_DIM*TILE_DIM-1];
		assign WOUT[(Slice_Size*PE_H*2)*TILE_DIM*gi+:(Slice_Size*PE_H*2)*TILE_DIM] = WtoE[gi][0];
		assign SOUT[(Slice_Size*PE_W*2)*TILE_DIM*gj+:(Slice_Size*PE_W*2)*TILE_DIM] = StoN[ARRAY_DIM-1][gj]; //debug: was [16*TILE_DIM*gi+:16*TILE_DIM] and was [ARRAY_DIM*TILE_DIM-1];
		assign NOUT[(Slice_Size*PE_W*2)*TILE_DIM*gj+:(Slice_Size*PE_W*2)*TILE_DIM] = NtoS[0][gj]; //debug: was NOUT[16*TILE_DIM*gi+:16*TILE_DIM]
	end
  end
  

  
endgenerate

assign DOA = wDOA[Tile_i][Tile_j];
assign DOB = wDOB[Tile_i][Tile_j];


endmodule