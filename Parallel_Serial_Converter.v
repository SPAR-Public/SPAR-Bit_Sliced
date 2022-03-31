module Parallel_Serial_Converter
 # (parameter SIZE = 1,  parameter MAX_WORD_LENGTH = 32, parameter LENGTH = 32, parameter Slice_Size = 4, parameter PE = 2)
(
	clk,  
	reset, 
    mode,
    start,
    finish,
    serial_data_in,
    parallel_data_in,
    serial_data_out,
    parallel_data_out
);

input clk, reset, start;
input[1:0] mode;
input [(Slice_Size*PE*2)*SIZE-1:0] serial_data_in;
input [PE*MAX_WORD_LENGTH*SIZE-1:0] parallel_data_in;
output reg finish;
output[(Slice_Size*PE*2)*SIZE-1:0] serial_data_out;
output[PE*MAX_WORD_LENGTH*SIZE-1:0] parallel_data_out;
// input[5:0] LENGTH;

integer i;
// 11011110101011011011111011101111
//   01111010101101101111101110111100
reg [PE*SIZE*MAX_WORD_LENGTH-1:0] parallel_regs;
// reg [2*4*SIZE-1:0] serial_regs;
reg [7:0] counter;
reg state;
reg counting;

// always@(posedge clk)
// begin
//     if(reset==0) clk2 <= 0;
//     else clk2 <= !clk2;

//     if(start) clk2 <= 1;
// end

always@(posedge clk) begin
    if(reset==0) begin
        counter <= LENGTH/Slice_Size; //debug: was LENGTH
        finish <= 0;
        counting    <= 0;
    end
    else begin
        if(start) begin
            counter     <= 0; //debug: was 0
            finish      <= 0;
            counting    <= 0;
        end
        else if(counter<LENGTH/Slice_Size+1) begin //debug: was counter<LENGTH+1
            counter <= counter + 1;
            counting <= 1;
            if(counter == LENGTH/Slice_Size) begin //debug: was counter == LENGTH
                finish <= 1;
                counting <= 0;
            end
        end
        else finish <= 0;
    end
end


//filling up the parallel regs (writing to parallel regs)
always@(posedge clk)
begin
    if(reset==0) begin
        parallel_regs <= 0;
        i <= 0;
        state <= 0;
    end
    else
    begin
        if(mode==0)
        begin
            parallel_regs <= parallel_regs;
        end
        if(mode==1) begin
            if(counting) begin
                case(state)
				0: begin
				state <= 1;
				end
				1: begin
				for(i=0; i<SIZE*PE; i=i+1) begin
                    parallel_regs[i*LENGTH-1 + Slice_Size*counter -:(Slice_Size*2)] <= serial_data_in[i*(Slice_Size*2)+(Slice_Size*2-1) -:(Slice_Size*2)];
                end
                state <= 0;
				end
                endcase
            end
        end
        else if(mode==2)
        begin
            parallel_regs <= parallel_data_in;
        end
        
    end
end

assign parallel_data_out = parallel_regs;

genvar gi;
generate
for (gi=0; gi<SIZE*PE; gi=gi+1) begin : s
    assign serial_data_out[gi*(Slice_Size*2)+(Slice_Size*2-1) -:(Slice_Size*2)] = counting && mode==0? parallel_regs[gi*LENGTH-1 + (Slice_Size*2)*(counter/2+counter%2) -:(Slice_Size*2)] : 4'hz; 
	//debug: was gi*(Slice_Size*2)+(Slice_Size*2-1) -:(Slice_Size*2)] = counting && mode==0? parallel_regs[gi*LENGTH-1 + (LENGTH/Slice_Size)*(counter/2+counter%2) -:(Slice_Size*2)
end
endgenerate


endmodule