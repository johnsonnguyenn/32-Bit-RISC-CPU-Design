module mux2to1 (s, in0, in1, out);
	input [31:0] in0, in1; 
	input s;
	output reg [31:0] out;
	
always @(*)
	out = s ? in1 : in0; // selects output 
	
endmodule