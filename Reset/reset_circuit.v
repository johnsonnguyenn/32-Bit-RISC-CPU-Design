module reset_circuit (
	input wire clk,
	input wire reset,
	output reg enable_pd, 
	output reg clr_pc
);

integer count; // keep track of three clock cycles

always @(posedge clk) begin 
	if (reset) begin // when reset is high, pc is cleared and disable program/data execution
		enable_pd <= 0;
		clr_pc <= 1; 
		count <= 1; // count is 1
	end else begin 
		if (count == 0) begin // when reset is low, if count is 0 then enable program/data execution and stop clearing pc
			enable_pd <= 1; 
			clr_pc <= 0;
		end else if (count < 4) begin // if counter is less than 4, increment count for each cycle
			count <= count + 1;
		end else if (count == 4) begin // on the 4th cycle, enasble program execution and stop clearing pc
			enable_pd <= 1;
			clr_pc <= 0;
			count <= 0; // reset count back to 0 
		end
	end
end
	 
endmodule 

		
		 