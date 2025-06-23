module adder32 (a, b, cin, sum, cout);
	input [31:0] a, b; // inputs for any value assigned for a,b
	input cin; // carryin input, usually 0 for unsigned addition 
	output cout; // shows the carryout, if theres overflow
	output [31:0] sum; // displays the sum of the two values
	wire [32:0] C; // 32-bit carry wires to connect each full adder


	genvar i; 
	assign C[0] = cin; // assigns the carry chain from carryin
	assign cout = C[32]; // final carryout from the MSB adder 
	generate // starts generate block for instantiating 32 bit full adders 
		for (i = 0; i <= 31; i = i + 1)
		begin: fulladd_stage 
			fulladder FullAdder32 ( 
				.sum(sum[i]), // ports sum output for bit i
				.cout(C[i+1]), // ports carryout to next stage's carryin
				.cin(C[i]), // ports carryin from previous stage
				.a(a[i]), // ports input a from ith bit
				.b(b[i]) // ports input b from ith bit
			);
		end
	endgenerate // ends generate block

endmodule
	