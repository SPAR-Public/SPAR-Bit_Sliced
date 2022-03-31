module TopTop #(parameter[7:0] ARRAY_DIM = 8'b01,parameter[7:0] TILE_DIM =  8'b01, parameter MAX_WORD_LENGTH = 32, parameter Slice_Size = 4, parameter PE_W = 2, parameter PE_H = 2)
(
    input clk,
    input reset,
    input start,
    // input[5:0] LENGTH,
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
    input[1:0] Activation_Function,
    input Tanh_In
    );

//parameter[7:0] ARRAY_DIM = DIM[15:8];
//parameter[7:0] TILE_DIM = DIM[7:0];

wire[0:PE_H*ARRAY_DIM*TILE_DIM*MAX_WORD_LENGTH-1] EAST_O;
wire[0:PE_H*ARRAY_DIM*TILE_DIM*MAX_WORD_LENGTH-1] WEST_O;
wire[0:PE_W*ARRAY_DIM*TILE_DIM*MAX_WORD_LENGTH-1] SOUTH_O;
wire[0:PE_W*ARRAY_DIM*TILE_DIM*MAX_WORD_LENGTH-1] NORTH_O;
wire[0:PE_H*ARRAY_DIM*TILE_DIM*MAX_WORD_LENGTH-1] EAST_I;
wire[0:PE_H*ARRAY_DIM*TILE_DIM*MAX_WORD_LENGTH-1] WEST_I;
wire[0:PE_W*ARRAY_DIM*TILE_DIM*MAX_WORD_LENGTH-1] SOUTH_I;
wire[0:PE_W*ARRAY_DIM*TILE_DIM*MAX_WORD_LENGTH-1] NORTH_I;

wire[0:PE_H*ARRAY_DIM*TILE_DIM*MAX_WORD_LENGTH-1] SIG_O;
wire[0:PE_H*ARRAY_DIM*TILE_DIM*MAX_WORD_LENGTH-1] TANH_O;

wire[0:PE_H*ARRAY_DIM*TILE_DIM*MAX_WORD_LENGTH-1] SIG_I;
wire[0:PE_H*ARRAY_DIM*TILE_DIM*MAX_WORD_LENGTH-1] TANH_I;

wire [0:PE_H*ARRAY_DIM*TILE_DIM-1] Ready_Sig;
wire [0:PE_H*ARRAY_DIM*TILE_DIM-1] Ready_Tanh;

Top #(ARRAY_DIM,TILE_DIM, MAX_WORD_LENGTH, Slice_Size, PE_W, PE_H) top
    (
        clk,
        reset,
        start,
        instruction,
        external,
        Tile_i,
        Tile_j,
        Block_i,
        Block_j,
        WEA,
        WEB,
        ADDRA,
        ADDRB,
        DIA,
        DIB,
        DOA,
        DOB,
        EAST_I,
        WEST_I,
        SOUTH_I,
        NORTH_I,
        EAST_O,
        WEST_O,
        SOUTH_O,
        NORTH_O
    );


assign SIG_I = EAST_O;
Sigmoid_Array #(MAX_WORD_LENGTH, PE_H*ARRAY_DIM*TILE_DIM) sig
    (
        clk,
        SIG_I,
        SIG_O,
		Ready_Sig
    );
assign TANH_I = Tanh_In == 0? EAST_O : NORTH_O;
Tanh_Array #(MAX_WORD_LENGTH, PE_H*ARRAY_DIM*TILE_DIM) tanh
    (
        clk,
        TANH_I,
        TANH_O,
		Ready_Tanh
    );


assign WEST_I = 0;
assign EAST_I = 0; //Activation_Function == 0? EAST_O : (Activation_Function == 1 && Ready_Sig[0] == 1'b1)? SIG_O : (Activation_Function == 2 && Ready_Tanh[0] == 1'b1)? TANH_O : 'hz;
assign SOUTH_I = 0;

//for 2*2 and 1*1
assign NORTH_I = Activation_Function == 0? EAST_O : (Activation_Function == 1 && Ready_Sig[0] == 1'b1)? SIG_O : (Activation_Function == 2 && Ready_Tanh[0] == 1'b1)? TANH_O : 'hz;

//for 4*2 and 2*1
//wire[0:(PE_W-PE_H)*ARRAY_DIM*TILE_DIM*MAX_WORD_LENGTH-1] zeros = 0;
//assign NORTH_I = Activation_Function == 0? {EAST_O,zeros} : (Activation_Function == 1 && Ready_Sig[0] == 1'b1)? SIG_O : (Activation_Function == 2 && Ready_Tanh[0] == 1'b1)? TANH_O : 'hz;

//assign NORTH_I[0:PE_H*ARRAY_DIM*TILE_DIM*MAX_WORD_LENGTH-1] = Activation_Function == 0? EAST_O : (Activation_Function == 1 && Ready_Sig[0] == 1'b1)? SIG_O : (Activation_Function == 2 && Ready_Tanh[0] == 1'b1)? TANH_O : 'hz;
//assign NORTH_I[PE_H*ARRAY_DIM*TILE_DIM*MAX_WORD_LENGTH:PE_W*ARRAY_DIM*TILE_DIM*MAX_WORD_LENGTH-1] = Activation_Function == 0? zeros : (Activation_Function == 1 && Ready_Sig[0] == 1'b1)? SIG_O : (Activation_Function == 2 && Ready_Tanh[0] == 1'b1)? TANH_O : 'hz;


//debug: tryting to remove AF from the middle
//assign NORTH_I = EAST_O; //debug: tryting to remove AF from the middle


endmodule