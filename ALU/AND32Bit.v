module AND32Bit (a, b, result);
	input [31:0] a, b;
	output [31:0] result;
	
	and (result, a, b);
	
endmodule