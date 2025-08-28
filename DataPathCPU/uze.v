module uze (
	input wire [31:0] uze_in,
	output wire [31:0] uze_out
	); 
	
	assign uze_out = ({16'b0, uze_in[15:0]}); // unsigned zero extender, takes lower 16 bits of a value, and extends it to 32-bits by making the upper bits 0. 
	
endmodule 
		
	