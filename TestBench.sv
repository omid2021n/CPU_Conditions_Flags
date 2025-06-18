`timescale 1ns / 1ps
module tb_top;

  // Instantiate the DUT (Device Under Test)
  reg [31:0] IR;
  reg [15:0] GPR [31:0];
  wire sign, zero, overflow, carry;

  // Instantiate the top module
  top uut();

  // Task to display flags
  task display_flags;
    input [31:0] instr;
    begin
      uut.IR = instr;
      #1; // Wait for combinational logic to settle
   //   $display("-----------------------------------------------------------------------------------------");
      $display("Instruction: %b", instr);
      $display("Sign: %b, Zero: %b, Overflow: %b, Carry: %b\n", uut.sign, uut.zero, uut.overflow, uut.carry);
    end
  endtask

  initial begin
    // Initialize GPRs
    uut.GPR[1] = 16'h0001;
    uut.GPR[2] = 16'hFFFF; // -1 in 2's complement
    uut.GPR[3] = 16'h7FFF; // Max positive
    uut.GPR[4] = 16'h8000; // Min negative
    
    // ADD: No overflow, no carry
    $display("----------------------------------------------------------------------------------------");
    display_flags({`add, 5'd5, 5'd1, 1'b0, 5'd2, 11'd0});
    $display("ADD 1--------------rdst :%0d,  rsrc1 :%0d,  rsrc2 :%0d",uut.GPR[5],uut.GPR[1],uut.GPR[2]);

    // ADD: Overflow (positive + positive = negative)
    $display("-----------------------------------------------------------------------------------------");
    display_flags({`add, 5'd5, 5'd3, 1'b0, 5'd3, 11'd0});
    $display("ADD 2--------------rdst :%0d,  rsrc1 :%0d,  rsrc2 :%0d",uut.GPR[5],uut.GPR[3],uut.GPR[3]);

    // ADD: Carry (unsigned overflow)
    $display("-----------------------------------------------------------------------------------------");
    display_flags({`add, 5'd5, 5'd3, 1'b0, 5'd4, 11'd0});
    $display("ADD 3--------------rdst :%0d,  rsrc1 :%0d,  rsrc2 :%0d",uut.GPR[5],uut.GPR[3],uut.GPR[4]);

    // SUB: Overflow (positive - negative = negative)
    $display("-----------------------------------------------------------------------------------------");
    display_flags({`sub, 5'd5, 5'd3, 1'b0, 5'd4, 11'd0});
    $display("SUB  4--------------rdst :%0d,  rsrc1 :%0d,  rsrc2:%0d",uut.GPR[5],uut.GPR[3],uut.GPR[4]);

    //If both operands have the same sign/but the result has a different sign → Overflow
    
    // MUL: Result zero
    uut.GPR[1] = 16'h0001;
    $display("-----------------------------------------------------------------------------------------");
    display_flags({`mul, 5'd5, 5'd2, 1'b0, 5'd2, 11'd0});
    $display("MUL  5--------------rdst :%0d,  rsrc1 :%0d,  rsrc2 :%0d",uut.GPR[5],uut.GPR[2],uut.GPR[2]);

    // MUL: Negative result
    uut.GPR[1] = 16'hFFFF; // -1
    uut.GPR[2] = 16'h0002;
    $display("-----------------------------------------------------------------------------------------");
    display_flags({`mul, 5'd5, 5'd1, 1'b0, 5'd2, 11'd0});//  Oper_type/rdst/rsrc1/imm_mode/rsrc2
    $display("MUL  6--------------rdst :%0d,  rsrc1 :%0d,  rsrc2 :%0d",uut.GPR[5],uut.GPR[1],uut.GPR[2]);

    $finish;
  end
/*

\mul`	5 bits	Opcode for MUL	Operation type (e.g., multiply)
5'd5	5 bits	Destination Register (rdst) = 5	
5'd1	5 bits	Source Register 1 (rsrc1) = 1	
1'b0	1 bit	Immediate mode = 0 (register mode)	
5'd2	5 bits	Source Register 2 (rsrc2) = 2	
11'd0	11 bits	Unused or immediate value (not used in register mode)	


*/
endmodule
