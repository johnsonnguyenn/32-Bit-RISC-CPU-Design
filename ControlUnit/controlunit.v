module controlunit (
	input clk, mclk,
	input enable, 
	input StatusC, StatusZ, 
	input [31:0] INST, 
	output reg A_Mux, B_Mux, 
	output reg IM_MUX1, REG_MUX, 
	output reg [1:0] IM_MUX2, DATA_MUX, 
	output reg [2:0] ALU_OP,
	output reg inc_PC, ld_PC,
	output reg clr_A, clr_B, clr_C, clr_Z,
	output reg ld_A, ld_B, ld_C, ld_Z, ld_IR,
	output reg [2:0] T,
	output reg wen, en
); 

	parameter T0 = 2'b00, T1 = 2'b01, T2 = 2'b10; 

	reg [1:0] current_state;
	reg [1:0] next_state; 
	
	// state register
	
	always @(posedge clk or negedge enable) begin
		if (!enable) 
			current_state <= T0;
				else 
					current_state <= next_state; 
	end 
	
	always @(*) begin 
		case (current_state) 
			T0: next_state = T1; 
			T1: next_state = T2;
			T2: next_state = T0;
			default: next_state = T0; 
		endcase
	end
	
	// control logic
	
	always @(*) begin 
		case (current_state) 
			T0: T = 3'b001; 
			T1: T = 3'b010;
			T2: T = 3'b100;
			default: T = 3'b000;
		endcase
	end
	
	always @(*) begin 
		A_Mux = 0; 
		B_Mux = 0;
		IM_MUX1 = 0;
		IM_MUX2 = 2'b00;
		REG_MUX = 0; 
		DATA_MUX = 2'b00;
		ALU_OP = 3'b000;
		inc_PC = 0; 
		ld_PC = 0; 
		clr_A = 0;
		clr_B = 0;
		clr_C = 0;
		clr_Z = 0;
		ld_A = 0;
		ld_B = 0; 
		ld_C = 0;
		ld_Z = 0;
		
	if (enable) begin 
		case (current_state) 
			T0: begin
				ld_IR = 1; 
			end
			T1: begin 
				ld_PC = 1;
				inc_PC = 1; 
			case (INST[31:28])
				4'b0000: ld_A = 1;	 //LDAI 
				4'b0001: ld_B = 1; 	 //LDBI
				4'b0010:; 			 	 //STA
				4'b0011: REG_MUX = 1; //STB
				4'b1001: begin 		 //LDA
					DATA_MUX = 2'b01; 
					ld_A = 1; 
				end 
				4'b1010: begin			 //LDB
					DATA_MUX = 2'b01; 
					REG_MUX = 1; 
					ld_B = 1; 
				end
				default: ld_IR = 1; 
			endcase
		end
			T2: begin 
				case (INST[31:28])
				4'b0100: begin 		//LUI
					IM_MUX1 = 1; 
					DATA_MUX = 2'b01; 
					ALU_OP = 3'b010; 
					clr_B = 0; 
					ld_A = 1; 
					ld_C = 1; 
					ld_Z = 1; 
				end
				4'b0101: begin 		//JMP
					ld_IR = 1; 
				end 
				4'b0110: 				//BEQ
					if (StatusZ) begin 
						ALU_OP = 3'b011;
						ld_PC = 1; ld_IR = 1;
					end 
				4'b1000:					//BNE
					if (StatusC) begin 
						ld_PC = 1; 
					end
				4'b0111: begin
					case (INST[27:24])
						4'b0000: begin //ADD
							ALU_OP = 3'b010;
							DATA_MUX = 2'b10; 
							ld_A = 1;
							ld_C = 1;
							ld_Z = 1; 
						end
						4'b0001: begin //ADDI
							ALU_OP = 3'b010; 
							DATA_MUX = 2'b10; 
							IM_MUX2 = 2'b01; 
							ld_A = 1; 
							ld_C = 1;
							ld_Z = 1;
						end
						4'b0010: begin  //SUB
							ALU_OP = 3'b011;
							DATA_MUX = 2'b10; 
							ld_A = 1;
							ld_C = 1;
							ld_Z = 1;
						end
						4'b0011: begin  //INCA
							IM_MUX2 = 2'b10;
							DATA_MUX = 2'b10;
							ALU_OP = 3'b010;
							ld_A = 1;
							ld_C = 1;
							ld_Z = 1;
						end
						4'b0100: begin //ROL
							ALU_OP = 3'b100;
							DATA_MUX = 2'b10;
							ld_A = 1;
							ld_C = 1;
							ld_Z = 1;
						end
						4'b0101: clr_A = 1; //CLRA
						4'b0110: clr_B = 1; //CLRB
						4'b0111: clr_C = 1; //CLRC
						4'b1000: clr_Z = 1; //CLRZ
						4'b1001: begin 	  //ANDI
							DATA_MUX = 2'b10;
							ALU_OP = 3'b000;
							ld_A = 1;
							ld_C = 1;
							ld_Z = 1;
						end
						4'b1010: 			// TSTZ
							if (StatusZ) begin
								ld_PC = 1;
								inc_PC = 1;
							end 
						4'b1011: begin    //AND
							DATA_MUX = 2'b010;
							ALU_OP = 3'b000;
							ld_A = 1;
							ld_C = 1;
							ld_Z = 1;
						end
						4'b1100:  			//TSTC
							if (StatusC) begin
								inc_PC = 1;
								ld_PC = 1;
							end
						4'b1101: begin    //ORI
							IM_MUX2 = 2'b01; 
							DATA_MUX = 2'b010;
							ALU_OP = 3'b001;
							ld_A = 1;
							ld_C = 1;
							ld_Z = 1;
						end
						4'b1110: begin    //DECA
							IM_MUX2 = 2'b10;
							DATA_MUX = 2'b010;
							ALU_OP = 3'b011;
							ld_A = 1;
							ld_C = 1;
							ld_Z = 1;
						end
						4'b1111: begin		//ROR
							DATA_MUX = 2'b010;
							ALU_OP = 3'b101;
							ld_A = 1;
							ld_C = 1;
							ld_Z = 1;						
						end
							default:; 
						endcase
					end
						default: ld_IR = 1;
				endcase 
			end
				default: ld_IR = 1;
			endcase
		end
	end

// data memory instructions

	always @(negedge mclk) begin
		if (current_state == T1 && clk == 0) begin
			case (INST[31:28])
				4'b0010, 4'b0011: begin 
					en = 1; 
					wen = 1;
				end
				4'b1000, 4'b1001: begin 
					en = 1;
					wen = 0;
				end
				default: begin 
					en = 0;
					wen = 0;
				end
			endcase
		end else if (current_state == T2 && clk == 1) begin
			en = 0;
			wen = 0;
		end else if (current_state == T1) begin 
			case (INST[31:28])
				4'b0010, 4'b0011: begin 
					en = 1; 
					wen = 1;
				end
				4'b1000, 4'b1001: begin 
					en = 1;
					wen = 0;
				end
				default: begin 
					en = 0;
					wen = 0;
				end
			endcase				
		end
	end
	
endmodule
					
				
				


