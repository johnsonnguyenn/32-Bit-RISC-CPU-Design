module fulladder (sum, cout, cin, a, b); 
	input a, b, cin; 
	output sum, cout;
	
	assign sum = a ^ b ^ cin; // boolean expression for sum
	assign cout = (a & b) | (a & cin) | (b & cin); // boolean expression for cout

endmodule