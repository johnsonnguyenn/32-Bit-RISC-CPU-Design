module pc (clk, reset, pc, new_pc, inc, ld);
    input clk, reset, inc;
    input [31:0] new_pc; 
    output reg [31:0] pc;
	 input ld; 

always @ (posedge clk or posedge reset)
    if (reset) begin // if reset is high, set pc to binary value of 0
        pc <= 32'b0; 
    end else if (ld) begin
			if (inc) begin// otherwise, if inc is high, set pc to an increment of 4
				pc <= pc + 4; 
			end else pc <= new_pc; // if inc is low, set pc to new_pc (data)
		end
	
endmodule