module DataMem (clk, addr, data_in, wen, en, data_out);
	input clk; 
	input [7:0] addr; 
	input [31:0] data_in;
	input wen;
	input en;
	output reg [31:0] data_out;
	
	reg [31:0] M [0:255]; // 256 x 32-bit memory array
	
always @(negedge clk) begin
	if (en) begin  // if en is high and wen is high, at falling edge of clk, store data_in to memory at addr
		if (wen) begin
			M[addr] <= data_in;
			data_out <= 32'b0; // data output is 0
		end else begin // otherwise, if en is high and wen is low, output data from memory at addr
				data_out <= M[addr];
			end 
		end else begin
			data_out <= 32'b0; // otherwise, if en is low and wen is low, set data output to 0 (memory is disabled, output is cleared)
		end
	end
		
endmodule		
			