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
// Create Date: 09/09/2020 09:19:55 AM
// Design Name: 
// Module Name: BS_Controller
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


module BS_Controller #(parameter LENGTH = 32, parameter Slice_Size = 4)
	(
		input clk, 
		input reset,
		input start,
		// input[5:0] LENGTH,
		input[31:0] instruction,
		
		//alu control
        output reg[3:0] alu_op,

		//bram control
        output reg wea,
		output reg web,
		output reg[9:0] addra, 
		output reg[9:0] addrb,

		//move control
		output reg east, 
		output reg west, 
		output reg south, 
		output reg north,
		output reg[1:0] east_mode,
		output reg[1:0] west_mode,
		output reg[1:0] south_mode,
		output reg[1:0] north_mode,

		//other helper signals
		output reg[9:0] count, //debug: was [6:0]
		// output reg bram_init_flag,
		// output reg[15:0] bram_init_d,
		// output reg finish_flag,
		output reg[2:0] state, //debug:
		output [31:0] rs1_cnt_out,
		output [31:0] rs2_cnt_out
    );

parameter  Q = 3'b000, OP = 3'b001, SHIFT = 3'b010, WB = 3'b011, DFF_BRAM = 3'b100, DFF_ALU = 3'b101; //debug:


wire[9:0] rs1_base, rs2_base, rd_base, rd_up_base;
wire[5:0] opcode;

reg[31:0] offset;
reg[9:0] rs1_ptr, rs2_ptr, rd_ptr, rd_up_ptr, q_ptr, shift_ptr;
reg[10:0] ram_ptr;
reg[6:0] iter;
reg start_flag;

reg finish_flag;

integer i;
integer rs1_cnt = 0;
integer rs2_cnt = 0;

assign rd_base    = (opcode == 9 || opcode == 10) ? instruction[25:21]*LENGTH+LENGTH-1 : instruction[25:21]*LENGTH;
assign rs1_base   = (opcode == 9 || opcode == 10) ? instruction[20:16]*LENGTH+LENGTH-1 : instruction[20:16]*LENGTH;
assign rs2_base   = (opcode == 9 || opcode == 10) ? instruction[15:11]*LENGTH+LENGTH-1 : instruction[15:11]*LENGTH;
assign rd_up_base = instruction[25:21]*LENGTH+LENGTH;

assign opcode = instruction[31:26];

assign rs1_cnt_out = rs1_cnt;
assign rs2_cnt_out = rs2_cnt;

always @ (posedge clk)
begin
	
	if (reset == 0) begin

		//bram control
		wea			<=	0;
		web			<=	0;
		addra		<=	0;
		addrb		<=	0;
		//bram intialization signals
		// bram_init_d	<=	0;
		// bram_init_flag	<=	1;
		//move control
		east		<=	0;
		west		<=	0;
		south		<=	0;
		north		<=	0;
		east_mode	<=	0;
		west_mode	<= 	0;
		south_mode	<=	0;
		north_mode	<=	0;
		//pointer initial values
		rs1_ptr 	<= rs1_base;
		rs2_ptr 	<= rs2_base;
		rd_ptr 		<= rd_base;
		rd_up_ptr 	<= rd_base;
		q_ptr		<= rs2_base;
		shift_ptr	<= rd_base;
		ram_ptr		<=	'h400;
		rs1_cnt 	<=  0; //debug:
		rs2_cnt 	<=  0;
		//other helper signals
		count		<=	0;
		iter		<=	0;
		offset		<= 	0;
		//start and finish flags
		start_flag	<= 	0;
		finish_flag	<=	0;

		case(opcode)
			0:	begin
				//alu control
				alu_op		<=	0;
				//initial state
				state		<=	OP;
				end
			1:	begin
				//alu control
				alu_op		<=	1;
				//initial state
				state		<=	OP;
				end
			2:	begin
				//alu control
				alu_op		<=	2;
				//initial state
				state		<=	OP;	//was Q	
				end
			5,6,7,8: 	begin
				//alu control
				alu_op		<=	'hf;
				//initial state
				state		<=	OP;
				end
			9:	begin
				//alu control
				alu_op		<=	9;
				//initial state
				state		<=	OP;
				end
			10:	begin
				//alu control
				alu_op		<=	10;
				//initial state
				state		<=	OP;
				end
		endcase	
		
	end

	else if(start) begin
		//bram control
		wea			<=	0;
		web			<=	0;
		addra		<=	0;
		addrb		<=	0;
		//bram initialization
		// bram_init_d	<=	0;
		// bram_init_flag	<=	0;
		//move control
		east		<=	0;
		west		<=	0;
		south		<=	0;
		north		<=	0;
		east_mode	<=	0;
		west_mode	<=	0;
		south_mode	<=	0;
		north_mode	<=	0;

		//pointer initial values
		rs1_ptr 	<= rs1_base;
		rs2_ptr 	<= rs2_base;
		rd_ptr 		<= rd_base;
		rd_up_ptr 	<= rd_base;
		q_ptr		<= rs2_base;
		shift_ptr	<= rd_base;
		ram_ptr		<=	0;
		rs1_cnt 	<=  0; //debug:
		rs2_cnt 	<=  0;
		//other helper signals
		count		<=	0;
		iter		<=	0;
		offset		<= 	0;
		//start finish flags
		start_flag	<= 	1;
		finish_flag	<=	0;

		case(opcode)
			0:	begin
				//alu control
				alu_op		<=	0;
				//initial state
				state		<=	OP;
				end
			1:	begin
				//alu control
				alu_op		<=	1;
				//initial state
				state		<=	OP;
				end
			2:	begin
				//alu control
				alu_op		<=	2;
				//initial state
				state		<=	OP;	//was Q
				end
			5,6,7,8: 	begin		//update
				//alu control
				alu_op		<=	'hf;
				//initial state
				state		<=	OP;
				end			
			9:	begin
				//alu control
				alu_op		<=	9;
				//initial state
				state		<=	OP;
				end
			10:	begin
				//alu control
				alu_op		<=	10;
				//initial state
				state		<=	OP;
				end
		endcase	
	end
	
	else if(start_flag&&!finish_flag) begin
		count <= count + 1;
		case(opcode)
		0,1:    begin
				case(state)
				OP: begin
					//update source pointers
					rs1_ptr		<= rs1_ptr + 1;
					rs2_ptr 	<= rs2_ptr + 1;
					//set bram addresses and write enable
					addra 		<= rs1_ptr;
					addrb 		<= rs2_ptr;
					wea 		<= 0;			
					//next state
					state 		<= DFF_ALU;
				end
				/*DFF_BRAM: begin //debug:
					//next state
					state 		<= DFF_ALU;
				end*/
				DFF_ALU: begin
					//next state
					state 		<= WB;
				end
				WB: begin
					//update destination pointer
					rd_ptr 		<= rd_ptr + 1;
					//set bram addresses and write enable
					addra 		<= rd_ptr;
					wea 		<= 1;
					//next state
					state 		<= OP;
				end
				endcase
				//break when done
				if(count==3*(LENGTH/Slice_Size)) begin //debug: was 2*(LENGTH/Slice_Size)
					start_flag	<= 0;
					finish_flag <= 1;
				end
			end
		2:		begin
				case(state)
				OP: begin
					//update source pointers
					if(rs1_cnt == (LENGTH/Slice_Size) - 1) //was: count % ((LENGTH/Slice_Size)-1) == 0
					begin
						rs1_ptr		<= rs1_base;
						rs2_ptr 	<= rs2_ptr + 1;
						rs1_cnt <= 0;
						rs2_cnt		<= rs2_cnt + 1;
					end
					else
					begin
						rs1_ptr		<= rs1_ptr + 1;
						rs2_ptr 	<= rs2_ptr;
						rs1_cnt		<= rs1_cnt + 1;
					end
					//set bram addresses and write enable
					addra 		<= rs1_ptr;
					addrb 		<= rs2_ptr;
					wea 		<= 0;
					//next state
					if(rs2_cnt < (LENGTH/Slice_Size)) //was: count % (LENGTH/Slice_Size) == 0
					begin
						state 		<= DFF_ALU;
					end
					else if (rs2_cnt == (LENGTH/Slice_Size))
					begin
						state 		<= DFF_BRAM;
					end
					else
					begin
						wea 		<= 1;
						state 		<= DFF_BRAM;
					end					
				end
				DFF_ALU: begin
					//next state
					state 		<= OP;
				end
				DFF_BRAM: begin
					//next state
					state 		<= WB;
				end
				WB: begin
					//update destination pointer
					rd_ptr 		<= rd_ptr + 1;
					//set bram addresses and write enable
					addra 		<= rd_ptr;
					wea 		<= 1;
					//next state
					if(count <((2*(LENGTH/Slice_Size)*(LENGTH/Slice_Size))+(LENGTH/Slice_Size)+2)) //debug: didnot have +1 for BS4
					begin
						state 		<= WB;
					end
				end
				endcase
				//break when done
				if(count ==((2*(LENGTH/Slice_Size)*(LENGTH/Slice_Size))+(LENGTH/Slice_Size)+2)) begin //debug: changed to +2
					wea 		<= 0; //debug: added
					start_flag	<= 0;
					finish_flag <= 1;
				end
				
			end
		/*2:	begin
				
				if(iter<=LENGTH) begin
				case(state)
				Q: begin
					//update pointers
					rs1_ptr 	<= rs1_base;
					rs2_ptr 	<= rs2_base;
					q_ptr 		<= q_ptr + 1;
					//set bram addresses and write enable
					addrb 		<= q_ptr;
					wea 		<= 0;
					//update other signals
					iter 		<= iter + 1;
					offset		<= offset + 1;
					//next state
					state 		<= OP;
					if(iter<LENGTH/2) begin				
					rd_ptr		<= rd_ptr + offset;
					rd_up_ptr	<= rd_up_ptr + offset;
					end
					else if(iter==LENGTH/2) begin
					rd_ptr		<= rd_ptr + offset-LENGTH/2;
					rd_up_ptr	<= rd_up_ptr + offset;
					end
					else if(iter>LENGTH/2) begin
					rd_ptr		<= rd_ptr + offset - LENGTH/2;
					rd_up_ptr	<= rd_up_ptr + offset - LENGTH/2;
					end
				end
				OP: begin
					
					//update pointers
					rd_up_ptr	<= rd_up_ptr + 1;
					rd_ptr 		<= rd_ptr + 1;
					rs1_ptr		<= rs1_ptr + 1;
					
					///////////////setting bram addresses//////////
					//let source point to 0 for the first iteration to overwrite old values in the register
					if(iter==1 && count<(2*LENGTH)+1) begin //debug: was (2*LENGTH)+1
						addra <= 0;
						addrb <= rs1_ptr;
					end
					//set addresses to extend the last bit using addition or subtraction with 0
					else if(count==(2*LENGTH)+1) begin //debug: was (2*LENGTH)+1
						addra 	<= rd_ptr - 1;
						addrb 	<= 0;
					end
					//if iteration is not 1
					else begin
						addra  	<= rd_up_ptr;
						addrb 	<= rs1_ptr;
					end
					wea 	<= 0;
					//next state
					state 		<= WB;			
				end*/
				/*DFF_BRAM: begin //debug:
					//next state
					state 		<= DFF_ALU;
				end
				DFF_ALU: begin //debug:
					//next state
					state 		<= WB;
				end*/
				/*WB: begin
				
					if(count<(2*LENGTH)+2) begin //debug: was (2*LENGTH)+2
						addra 		<= rd_ptr-1;
						wea 		<= 1;

						state 		<= OP;
					end 
					//shift only before last iteration
					else if(iter<LENGTH+1) begin
						rd_ptr		<= rd_base;
						rd_up_ptr	<= rd_base;

						addra		<= rd_ptr-1;
						addrb		<= 0;
						wea			<= 1;

						count 		<= 0;

						state 		<= SHIFT;
						
					end
					//no shift last iteration 
					else begin
						wea 		<= 0;

						state 		<= Q;
					end
					
				
				end
				SHIFT: begin

					
					rd_ptr		<= rd_base;
					rd_up_ptr	<= rd_base;
					
					addra		<= 0;
					addrb 		<= 0;
					wea			<= 0;
					
					count 		<= 0;
					
					state 		<= Q;
				end
				endcase
				end
				else finish_flag <= 1;
				
			end*/
		5: 	begin //east 
				east	<= 1;
				east_mode	<=	1; 
				west_mode	<=	0;
				south_mode	<=	0;
				north_mode	<=	0;

				case(state)
				OP: begin
					rs1_ptr		<= rs1_ptr + 2;

					addra 		<= rs1_ptr;
					addrb 		<= rs1_ptr+1;
					wea 		<= 0;
					web			<= 0;

					state 		<= WB;
				end
				/*DFF_BRAM: begin //debug:
					//next state
					state 		<= WB;
				end*/
				WB: begin
					rd_ptr		<= rd_ptr + 2;

					addra		<= rd_ptr;
					addrb		<= rd_ptr+1;
					if(count<=(LENGTH/Slice_Size)) begin //debug: was count<=LENGTH
						wea 		<= 1;
						web			<= 1;
					end

					state 		<= OP;
				end
				endcase
				if(count==(LENGTH/Slice_Size)) begin		//debug: was count==LENGTH
					east_mode	<=	0; 
					north_mode	<=	2;	//latch data from east buffer
				end
				if(count==(LENGTH/Slice_Size)+1) begin	//debug: was count==LENGTH+1
					finish_flag <=  1;
					east_mode	<=	0; 
					north_mode	<=	0;
					wea 		<= 0; //debug: added
					web			<= 0; //debug: added
				end
			end
	
		7: 	begin //south 				//update
				south	<= 1;
				east_mode	<=	0; 
				west_mode	<=	0;
				south_mode	<=	0;
				north_mode	<=	0;
				
				case(state)
				OP: begin
					rs1_ptr		<= rs1_ptr + 2;

					addra 		<= rs1_ptr;
					addrb 		<= rs1_ptr+1;
					wea 		<= 0;
					web			<= 0;

					state 		<= WB;
				end
				/*DFF_BRAM: begin //debug:
					//next state
					state 		<= WB;
				end*/
				WB: begin
					rd_ptr		<= rd_ptr + 2;

					addra		<= rd_ptr;
					addrb		<= rd_ptr+1;
					if(count<=(LENGTH/Slice_Size)) begin
						wea 		<= 1;
						web			<= 1;
					end

					state 		<= OP;
				end
				endcase
				if(count==(LENGTH/Slice_Size)) begin
					finish_flag <=  1;
				end
			end
		8: 	begin //north				//update
				north	<= 1;
				east_mode	<=	0; 
				west_mode	<=	0;
				south_mode	<=	0;
				north_mode	<=	1;

				case(state)
				OP: begin
					rs1_ptr		<= rs1_ptr + 2;

					addra 		<= rs1_ptr;
					addrb 		<= rs1_ptr+1;
					wea 		<= 0;
					web			<= 0;

					state 		<= WB;
				end
				/*DFF_BRAM: begin //debug:
					//next state
					state 		<= WB;
				end*/
				WB: begin
					rd_ptr		<= rd_ptr + 2;

					addra		<= rd_ptr;
					addrb		<= rd_ptr+1;
					if(count<=(LENGTH/Slice_Size)) begin
						wea 		<= 1;
						web			<= 1;
					end

					state 		<= OP;
				end
				endcase
				if(count==(LENGTH/Slice_Size)) begin
					north_mode	<=	2;	//latch data from east buffer
				end
				if(count==(LENGTH/Slice_Size)+1) begin
					north_mode	<=	0;
					finish_flag <=  1;
				end
			end
		9:
			begin
				case(state)
				OP: begin
					//update source pointers
					rs1_ptr		<= rs1_ptr - 1;
					rs2_ptr 	<= rs2_ptr - 1;
					//set bram addresses and write enable
					addra 		<= rs1_ptr;
					addrb 		<= rs2_ptr;
					wea 		<= 0;
					//next state
					state 		<= WB;
				end
				/*DFF_BRAM: begin //debug:
					//next state
					state 		<= DFF_ALU;
				end
				DFF_ALU: begin
					//next state
					state 		<= WB;
				end*/
				WB: begin
					//update destination pointer
					rd_ptr 		<= rd_ptr - 1;
					//set bram addresses and write enable
					addra 		<= rd_ptr;
					wea 		<= 1;
					//next state
					state 		<= OP;
				end
				endcase
				//break when done
				if(count==2*(LENGTH/Slice_Size)) begin //debug: was 2*LENGTH
					start_flag	<= 0;
					finish_flag <= 1;
				end
			end		
		10:
			begin
				case(state)
				OP: begin
					//update source pointers
					rs1_ptr		<= rs1_ptr - 1;
					rs2_ptr 	<= rs2_ptr - 1;
					//set bram addresses and write enable
					addra 		<= rs1_ptr;
					addrb 		<= rs2_ptr;
					wea 		<= 0;
					//next state
					state 		<= WB;
				end
				/*DFF_BRAM: begin //debug:
					//next state
					state 		<= DFF_ALU;
				end
				DFF_ALU: begin
					//next state
					state 		<= WB;
				end*/
				WB: begin
					//update destination pointer
					rd_ptr 		<= rd_ptr - 1;
					//set bram addresses and write enable
					addra 		<= rd_ptr;
					wea 		<= 1;
					//next state
					state 		<= OP;
				end
				endcase
				//break when done
				if(count==2*(LENGTH/Slice_Size)) begin //debug: was 2*LENGTH
					start_flag	<= 0;
					finish_flag <= 1;
				end
			end
		endcase
		end
end
endmodule
