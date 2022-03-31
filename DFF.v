//-----------------------------------------------------
// Design Name : dff_sync_reset
// File Name   : dff_sync_reset.v
// Function    : D flip-flop sync reset
// Coder       : Deepak Kumar Tala
//-----------------------------------------------------
module dff_sync_reset (
	input data, // Data Input
	input clk, // Clock Input
	input reset, // Reset input
	output reg q        // Q output
);

always @ ( posedge clk)
begin
	if (reset) //debug:
	begin
	  q <= 1'b0;
	end  
	else 
	begin
	  q <= data;
	end
end

endmodule