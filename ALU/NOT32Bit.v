module NOT32Bit (x, y);
	input [31:0] x;
	output [31:0] y;
	
	assign y = ~x;

endmodule