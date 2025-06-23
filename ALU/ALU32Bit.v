module ALU32Bit (a, b, op, result, cout, zero);
    input [31:0] a, b;
    input [2:0] op;
    output [31:0] result;
    output cout, zero;
    wire [31:0] and_result, or_result, adder_result, Lshift_result, Rshift_result, bNot, b_inv;
    wire Sub = (op == 3'b011); // determines if op is addition or subtraction
	 wire Adder_cout; 
	 
	 // 32 bit adder for subtraction and addition
    adder32 Adder_32Bit (
        .a(a), 
        .b(b_inv), 
        .cin(Sub), 
        .sum(adder_result), 
        .cout(Adder_cout)
    );
    
	 // logic operations for bits, AND operation and OR operation ported from AND32Bit
	 
    AND32Bit And_32 (.a(a), .b(b), .result(and_result)); 
  
    OR32Bit OR_32 (.a(a), .b(b), .result(or_result)); 
    
	 // right shifts and left shifts for bits, ported from RightShift and LeftShift
	 
    RightShift RS (.a(a), .result(Rshift_result));
    
    LeftShift LS (.a(a), .result(Lshift_result));
	 
	 // NOT operation ported from NOT32Bit
    
    NOT32Bit NOT_32 (.x(b), .y(bNot));
    
	 // 8 to 1 multiplexer for selection of operations, depending on op bit, each operation can be selected
	 
    mux8to1 mux1 (
        .in0(and_result), // op = 000 (AND)
        .in1(or_result),  // op = 001 (OR)
        .in2(adder_result), // op = 010 (Addition)
        .in3(adder_result), // op = 011 (Subtraction)
        .in4(Rshift_result), // op = 100 (Right Shift)
        .in5(Lshift_result), // op = 101 (Left Shift)
        .in6(32'b0), // op = 110 (00000000000000000000000000000000)
        .in7(32'b0), // op = 111 (00000000000000000000000000000000)
        .s(op),
        .out(result)
    );
    
	 // 2 to 1 multiplexer to determine if b or ~b
	 
    mux2to1 mux2 (
        .in0(b),
        .in1(bNot),
        .s(Sub),
        .out(b_inv)
    );
    
    assign cout = Adder_cout; // connects internal wire to output port 'cout' of ALU          
    assign zero = ~|result;
    
endmodule