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


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/19/2020 10:31:21 AM
// Design Name: 
// Module Name: PSC_Array
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PSC_Tile_Array
    #(parameter MAX_WORD_LENGTH = 16, parameter[7:0] ARRAY_DIM = 8'h02, parameter[7:0] TILE_DIM = 8'h02, parameter Slice_Size = 4, parameter PE = 2)(
        input clk, 
        input reset, 
        input [1:0] mode,
        input start,
        output finish,
        input [(Slice_Size*PE*2)*ARRAY_DIM*TILE_DIM-1:0] serial_data_in,
        input [PE*MAX_WORD_LENGTH*ARRAY_DIM*TILE_DIM-1:0] parallel_data_in,
  
        output[(Slice_Size*PE*2)*ARRAY_DIM*TILE_DIM-1:0] serial_data_out,
        output[PE*MAX_WORD_LENGTH*ARRAY_DIM*TILE_DIM-1:0] parallel_data_out
    );
    

genvar gi;
// generate and endgenerate is optional
generate
    for (gi=0; gi<ARRAY_DIM; gi=gi+1) begin : psc_tile
        PSC_Block_Array # (MAX_WORD_LENGTH, TILE_DIM, Slice_Size, PE) ps_convert_tile
        (
            clk,  
            reset, 
            mode,
            start,
            finish,
            serial_data_in[(Slice_Size*PE*2)*TILE_DIM*gi+:(Slice_Size*PE*2)*TILE_DIM],
            parallel_data_in[PE*MAX_WORD_LENGTH*TILE_DIM*gi+:PE*MAX_WORD_LENGTH*TILE_DIM],
            serial_data_out[(Slice_Size*PE*2)*TILE_DIM*gi+:(Slice_Size*PE*2)*TILE_DIM],
            parallel_data_out[PE*MAX_WORD_LENGTH*TILE_DIM*gi+:PE*MAX_WORD_LENGTH*TILE_DIM]
        );
    end
endgenerate
endmodule