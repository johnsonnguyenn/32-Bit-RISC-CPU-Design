module mux3to1 (
	input wire [31:0] in0, in1, in2,
	input wire [1:0] sel,
	output reg [31:0] out
);

always @(*) begin
	case (sel)
		2'b00: out = in0;
		2'b01: out = in1;
		2'b11: out = in2; 
	endcase
end

endmodule