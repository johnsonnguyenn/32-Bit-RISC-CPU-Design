module register32bit (D, clk, reset, Q, ld); 
input [31:0] D;
input clk;
input reset; 
output reg [31:0] Q;
input ld;

always @(posedge clk or posedge reset) begin
if (reset) begin
    Q <= 32'b0;
	end else if (ld) begin
		Q <= D;
	end
end

endmodule