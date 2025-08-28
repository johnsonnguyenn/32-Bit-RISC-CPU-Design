module harvard ( 
	input wire clk,
	input wire mclk, 
	input wire rst, 
	input wire [31:0] datain,
	output wire [31:0] dataout, 
	output wire [31:0] addrout,
	output wire [31:0] outA,
	output wire [31:0] outB,
	output wire outC,
	output wire outZ,
	output wire [31:0] doutIR,
	output wire [31:0] outPC,
	output wire [2:0] outT,
	output wire wen,
	output wire en
	);
	
	wire a_mux, b_mux, im_mux1, reg_mux; 
	wire ld_A, ld_B, ld_C, ld_Z;
	wire clr_A, clr_B, clr_C, clr_Z; 
	wire ld_PC, clr_PC, inc_PC;
	wire clr_IR, ld_IR;
	wire statusC, statusZ;
	wire [1:0] im_mux2, data_mux;
	wire [2:0] alu_op;
	wire [31:0] outIR;
	wire enpd;
	
	wire memWEN, memEN;
	
	// Data Path
	
	data_path datapath (
		.clk(clk),
		.mclk(mclk),
		.wen(memWEN),
		.en(memEN),
		.clr_A(clr_A),
		.ld_A(ld_A),
		.clr_B(clr_B),
		.ld_B(ld_B),
		.clr_C(clr_C),
		.ld_C(ld_C),
		.clr_Z(clr_Z),
		.ld_Z(ld_Z),
		.clr_PC(clr_PC),
		.ld_PC(ld_PC),
		.clr_IR(clr_IR),
		.ld_IR(ld_IR),
		.inc_PC(inc_PC),
		.data_mux(data_mux),
		.im_mux2(im_mux2),
		.im_mux1(im_mux1),
		.a_mux(a_mux),
		.b_mux(b_mux),
		.reg_mux(reg_mux),
		.alu_op(alu_op),
		.out_A(outA),
		.out_B(outB),
		.out_C(statusC),
		.out_Z(statusZ),
		.out_PC(outPC),
		.out_IR(outIR),
		.addr_out(addrout),
		.mem_out(dataout),
		.mem_in(),
		.mem_addr(),
		.data_in(datain)
	
	);
	
	// Control Unit
	
	controlunit control_unit (
		.clk(clk),
		.mclk(mclk),
		.enable(enpd),
		.StatusC(statusC),
		.StatusZ(statusZ),
		.INST(outIR),
		.A_Mux(a_mux),
		.B_Mux(b_mux),
		.IM_MUX1(im_mux1),
		.REG_MUX(reg_mux),
		.IM_MUX2(im_mux2),
		.DATA_MUX(data_mux),
		.ALU_OP(alu_op),
		.inc_PC(inc_PC),
		.ld_PC(ld_PC),
		.clr_A(clr_A),
		.clr_B(clr_B),
		.clr_C(clr_C),
		.clr_Z(clr_Z),
		.ld_A(ld_A),
		.ld_B(ld_B),
		.ld_C(ld_C),
		.ld_Z(ld_Z),
		.ld_IR(ld_IR),
		.T(outT),
		.wen(memWEN),
		.en(memEN)
	);
	
	// Reset
	
	reset_circuit resetcpu (
		.clk(clk),
		.reset(rst),
		.enable_pd(enpd),
		.clr_pc(clr_PC)
	);
	
	assign outC = statusC;
	assign outZ = statusZ;
	assign doutIR = outIR;
	assign wen = memWEN;
	assign en = memEN;
	
endmodule 
	
		