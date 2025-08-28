module data_path ( 
	
	// register inputs

	input wire clk, mclk, // clock signals
	input wire wen, en, // memory signals 
	input wire clr_A, ld_A,
	input wire clr_B, ld_B, 
	input wire clr_C, ld_C, // used for carry detection
	input wire clr_Z, ld_Z, // used for zero detection
	input wire clr_PC, ld_PC, // used during instruction execution to specify 
	input wire clr_IR, ld_IR, // used to hold instructions and for instruction decoding
	input wire inc_PC,
	
	// MUX controls
	
	input wire [1:0] data_mux, // selects ALU/memory/input for databus 
	input wire [1:0] im_mux2, 
	input wire im_mux1, a_mux, b_mux, reg_mux,
	
	// ALU operations
	
	input wire [2:0] alu_op, // selects ALU operation
	 
	// register outputs
	
	output wire [31:0] out_A, // output of register A
	output wire [31:0] out_B, // output of register B
	output wire out_C, // carry
	output wire out_Z, // zero
	output wire [31:0] out_PC, // output of program counter
	output wire [31:0] out_IR, // output of instruction register
	
	// address and data bus signals 
	
	output wire [31:0] addr_out, mem_out, mem_in, // addr_out refers to address to memory, data_out refers to data written to memory, data_in refers to data read from memory
	output wire [7:0] mem_addr, 
	input wire [31:0] data_in 
	);
	
	// internal wires
	
	wire [31:0] outA, outB, outIR;
	wire [31:0] inA, inB;
	wire [31:0] databus;
	wire [31:0] aluinput1, aluinput2;
	wire [31:0] alu_output;
	wire [31:0] AddrOut;
	wire [31:0] memIN, memOUT;
	wire [31:0] lze_outA, lze_outB, lze_outPC, lze_outALU;
	wire [31:0] uze_outALU;
	wire [31:0] red_mem_out; 

	
	// load zero extenders
	
	lze lze_A_mux (
		.lze_in(outIR),
		.lze_out(lze_outA)
	);
	
	lze lze_B_mux (
		.lze_in(outIR),
		.lze_out(lze_outB)
	);
	
	lze lze_PC (
		.lze_in(outIR),
		.lze_out(lze_outPC)
	);
	
	lze lze_ALU (
		.lze_in(outIR),
		.lze_out(lze_outALU)
	);
	
	
	// unsigned zero extenders
	
	uze uze_ALU (
		.uze_in(outIR),
		.uze_out(uze_outALU)
	);
	
	// reducers
	
	red red_datamemory (
		.red_in(outIR),
		.red_out(red_mem_out)
	);
	
	
	// mux2to1
	
	mux2to1 aMux ( // selects inputs for register A
		.s(a_mux), 
		.in0(databus),
		.in1(lze_outA), 
		.out(inA)
	);
	
	mux2to1 bMux ( // selects inputs for register B
		.s(b_mux),
		.in0(databus),
		.in1(lze_outB), 
		.out(inB)
	);	

	mux2to1 MemMux ( // selects which register to write to memory
		.s(reg_mux),
		.in0(outA),
		.in1(outB),
		.out(memIN)
	);


	mux2to1 ALUMux1 ( // selects ALU operand A
		.s(im_mux1),
		.in0(outA),
		.in1(uze_outALU),  
		.out(aluinput1)
	);	
	
	mux3to1 ALUMux2 ( // selects ALU operand B
		.in0(outB),
		.in1(lze_outALU), 
		.in2(32'b1),
		.sel(im_mux2),
		.out(aluinput2)
	);
	
	
	mux3to1 DataMux ( // selects data to put on databus 
		.in0(data_in),
		.in1(memOUT),
		.in2(alu_output),
		.sel(data_mux),
		.out(databus)
	);
	
	// registers
	
	register32bit reg_A ( // register A
		.D(inA),
		.clk(clk),
		.reset(clr_A),
		.Q(outA),
		.ld(ld_A)
	);
	
	
	register32bit reg_B ( // register B
		.D(inB),
		.clk(clk),
		.reset(clr_B),
		.Q(outB),
		.ld(ld_B)
	);
	
	// Instruction Register
	
	register32bit reg_IR ( 
		.D(databus),
		.clk(clk),
		.reset(clr_IR),
		.Q(outIR),
		.ld(ld_IR)
	);
	
	// Program Counter
	 
	pc PC ( 
		.clk(clk),
		.reset(clr_PC),
		.pc(AddrOut),
		.new_pc(lze_outPC), 
		.inc(inc_PC),
		.ld(ld_PC)
	);
	
	// ALU
	
	ALU32Bit alu ( 
		.a(aluinput1),
		.b(aluinput2),
		.op(alu_op),
		.result(alu_output),
		.cout(out_C),
		.zero(out_Z)
	);
	
	// Data Memory
	
	DataMem datamemory (
		.clk(mclk),
		.addr(red_mem_out), // lower 8 bits of IR are used as address
		.data_in(memIN),
		.wen(wen),
		.en(en),
		.data_out(memOUT)
	);

	// output buffers
	
	assign out_IR = outIR;
	assign out_A = outA;
	assign out_B = outB;
	assign mem_in = memIN;
	assign mem_out = memOUT;
	assign out_PC = AddrOut; 
	assign addr_out = AddrOut;
	assign mem_addr = red_mem_out;
	
endmodule 