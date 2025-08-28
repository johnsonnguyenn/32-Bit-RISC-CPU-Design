module red (	
	input wire [31:0] red_in,
	output wire [7:0] red_out 
); 

	assign red_out = red_in[7:0]; // reduces 32 bit value into 8 bits. 
	
endmodule 