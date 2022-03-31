`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/09/2020 08:14:48 AM
// Design Name: 
// Module Name: BitSliced_ALU
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


module BitSliced_ALU #(parameter LENGTH = 32, parameter Slice_Size = 4)
    (
        input clk,  
        input reset, 
        output reg [Slice_Size-1:0] rd_d,	//alu result will be written to rd (rd_d == rd data)  
        input[Slice_Size-1:0] rs1_d,  //data in from rs1
        input[Slice_Size-1:0] rs2_d, 	//data in from rs2
        input[3:0] alu_op,               //op code
        input[9:0] count,		       //signals sent to or from controller
        input reg_write,	         //signals sent to or from controller
        input[1:0] Q,
		input [31:0] rs1_cnt,
		input [31:0] rs2_cnt
        // LENGTH
    );
reg carry_borrow = 0;
reg [LENGTH * 2 - 1:0] acc_tmp = 0;
reg [2 * Slice_Size - 1 :0] mult_tmp = 0;


always @(posedge clk) //reg_write
begin
    if(alu_op == 0 && count % 3 == 2)
    begin
        {carry_borrow, rd_d} = rs1_d + rs2_d + carry_borrow;
        if(count == 3*(LENGTH/Slice_Size)+1)
        begin
            carry_borrow = 0;
        end
    end
    else if(alu_op == 1 && count % 3 == 2)
    begin
        {carry_borrow, rd_d} = rs1_d - rs2_d + carry_borrow;
        if(count == 3*(LENGTH/Slice_Size)+1)
        begin
            carry_borrow = 0;
        end
    end
    else if(alu_op == 2)
    begin
		if(count >= 2*(LENGTH/Slice_Size)*(LENGTH/Slice_Size)+2)
		begin
			rd_d = acc_tmp[LENGTH/2 + Slice_Size - 1 -: Slice_Size];
			acc_tmp = acc_tmp >> Slice_Size;
		end
		else
		begin
			if(count % 2 == 1)
			begin
				mult_tmp = (rs1_d * rs2_d);
				if(rs1_cnt == 0 || rs1_cnt == 1)
				begin
					acc_tmp = acc_tmp + (mult_tmp << (Slice_Size * ((rs1_cnt + rs2_cnt + (LENGTH/Slice_Size-3))))); //debug: removed +5
				end
				else
				begin
					acc_tmp = acc_tmp + (mult_tmp << (Slice_Size * ((rs1_cnt + rs2_cnt - 2)))); //debug: removed -2
				end
				
			end
		end
		if(rs1_cnt == 0 && rs2_cnt == 0)
		begin
			acc_tmp = 0;
		end
	end
end


endmodule
