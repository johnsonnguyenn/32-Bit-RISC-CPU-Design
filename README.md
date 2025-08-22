# 32-Bit-RISC-CPU-Design

An introductory project to get me familiar with Verilog, computer architecture, and digital designs. 

## Program Counter

* [**PC**](https://github.com/johnsonnguyenn/32-Bit-RISC-CPU-Design/tree/main/Register)

A program counter is a register that stores the memory address of the next instruction that is to be executed. This was implemented and coded via Verilog by designing a simple flip-flop register.
The program counter will either load a new address, or move to the next instruction by implementing 4, hence each instruction is 4 bytes long. 

## ALU 

* [**ALU**](https://github.com/johnsonnguyenn/32-Bit-RISC-CPU-Design/tree/main/ALU)

An arithmetic logic unit is a component that was designed to perform arithmetic and logic operations in 32 bits. Each logical component (AND, OR, etc.) was implemented individually, while addition and subtraction were handled by a 32-bit ripple-carry adder. 
By designing a ripple-carry adder, addition and subtraction are performed by selecting the inversion of B and adjusting the carry-in. Moreover, shifting bits left and right was also implemented individually. 

## Data Memory

* [**Data Memory**](https://github.com/johnsonnguyenn/32-Bit-RISC-CPU-Design/tree/main/Data_Mem)

A data memory module was designed and implemented on my RISC processor, allowing data to be retrieved and stored. It also supports both reading and writing operations, which allows instructions to store results into memory or load values back into registers. 
