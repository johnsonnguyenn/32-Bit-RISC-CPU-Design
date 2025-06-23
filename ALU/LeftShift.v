module LeftShift (a, result);
	input [31:0] a;
	output [31:0] result; 
	

	assign result[31:1] = a[30:0]; // takes bits 30 down to 0 and shifts to bits 31 down to 1
	assign result[0] = 0; // the LSB becomes 0 
	
endmodule