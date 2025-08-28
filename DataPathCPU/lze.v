module lze (	
	input wire [31:0] lze_in,
	output wire [31:0] lze_out
		);
		
	assign lze_out = ({lze_in[15:0], 16'b0}); /* load zero extender, takes lower 16 bits of an input and 
	shifts them left by 16 bits, placing them into the upper half of 32-bit output.
	The lower 16 bits become 0. */
	
	
endmodule