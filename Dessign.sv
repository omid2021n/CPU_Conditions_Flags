`timescale 1ns / 1ps

///////////fields of IR
`define oper_type IR[31:27]// 5 bit
`define rdst      IR[26:22]// 5 bit
`define rsrc1     IR[21:17]// 5 bit
`define imm_mode  IR[16]   // 1 bit
`define rsrc2     IR[15:11]//5 bit
`define isrc      IR[10:0] //11 bit
/*
oper_type	31:27	Opcode (type of instruction like add, sub...)
rdst	    26:22	Destination register
rsrc1	    21:17	First source register
imm_mode	16	    Selects between register or immediate
rsrc2	    15:11	Second register (if not using immediate)
isrc	    15:0	Immediate value

*/

////////////////arithmetic operation
`define movsgpr        5'b00000
`define mov            5'b00001
`define add            5'b00010
`define sub            5'b00011
`define mul            5'b00100

////////////////logical operations : and or xor xnor nand nor not

`define ror            5'b00101
`define rand           5'b00110
`define rxor           5'b00111
`define rxnor          5'b01000
`define rnand          5'b01001
`define rnor           5'b01010
`define rnot           5'b01011


module top();






reg [31:0] IR;            ////// instruction register  <--ir[31:27]--><--ir[26:22]--><--ir[21:17]--><--ir[16]--><--ir[15:11]--><--ir[10:0]-->
                          //////fields                 <---  oper  --><--   rdest --><--   rsrc1 --><--modesel--><--  rsrc2 --><--unused  -->             
                          //////fields                 <---  oper  --><--   rdest --><--   rsrc1 --><--modesel--><--  immediate_date      -->      

reg [15:0] GPR [31:0] ;   ///////general purpose register gpr[0] ....... gpr[31]



reg [15:0] SGPR ;      ///// msb of multiplication --> special register

reg [31:0] mul_res;



always@(*)
begin
case(`oper_type)
///////////////////////////////
`movsgpr: begin

   GPR[`rdst] = SGPR;
   
end

/////////////////////////////////
`mov : begin
   if(`imm_mode)
        GPR[`rdst]  = `isrc;
   else
       GPR[`rdst]   = GPR[`rsrc1];
end

////////////////////////////////////////////////////

`add : begin
      if(`imm_mode)
        GPR[`rdst]   = GPR[`rsrc1] + `isrc;
     else
        GPR[`rdst]   = GPR[`rsrc1] + GPR[`rsrc2];
end

/////////////////////////////////////////////////////////

`sub : begin
      if(`imm_mode)
        GPR[`rdst]  = GPR[`rsrc1] - `isrc;
     else
       GPR[`rdst]   = GPR[`rsrc1] - GPR[`rsrc2];
end

/////////////////////////////////////////////////////////////

`mul : begin
      if(`imm_mode)
        mul_res   = GPR[`rsrc1] * `isrc;
     else
        mul_res   = GPR[`rsrc1] * GPR[`rsrc2];
        
     GPR[`rdst]   =  mul_res[15:0];
     SGPR         =  mul_res[31:16];
end

///////////////////////////////////////////////////////////// bitwise or

`ror : begin
      if(`imm_mode)
        GPR[`rdst]  = GPR[`rsrc1] | `isrc;
     else
       GPR[`rdst]   = GPR[`rsrc1] | GPR[`rsrc2];
end

////////////////////////////////////////////////////////////bitwise and

`rand : begin
      if(`imm_mode)
        GPR[`rdst]  = GPR[`rsrc1] & `isrc;
     else
       GPR[`rdst]   = GPR[`rsrc1] & GPR[`rsrc2];
end

//////////////////////////////////////////////////////////// bitwise xor

`rxor : begin
      if(`imm_mode)
        GPR[`rdst]  = GPR[`rsrc1] ^ `isrc;
     else
       GPR[`rdst]   = GPR[`rsrc1] ^ GPR[`rsrc2];
end

//////////////////////////////////////////////////////////// bitwise xnor

`rxnor : begin
      if(`imm_mode)
        GPR[`rdst]  = GPR[`rsrc1] ~^ `isrc;
     else
        GPR[`rdst]   = GPR[`rsrc1] ~^ GPR[`rsrc2];
end

//////////////////////////////////////////////////////////// bitwisw nand

`rnand : begin
      if(`imm_mode)
        GPR[`rdst]  = ~(GPR[`rsrc1] & `isrc);
     else
       GPR[`rdst]   = ~(GPR[`rsrc1] & GPR[`rsrc2]);
end

////////////////////////////////////////////////////////////bitwise nor

`rnor : begin
      if(`imm_mode)
        GPR[`rdst]  = ~(GPR[`rsrc1] | `isrc);
     else
       GPR[`rdst]   = ~(GPR[`rsrc1] | GPR[`rsrc2]);
end

////////////////////////////////////////////////////////////not

`rnot : begin
      if(`imm_mode)
        GPR[`rdst]  = ~(`isrc);
     else
        GPR[`rdst]   = ~(GPR[`rsrc1]);
end

////////////////////////////////////////////////////////////

endcase
end

/*

Jump if Zero (JZ): If Z = 1, jump to a new instruction address.
Jump if Not Zero (JNZ): If Z = 0, continue normally.
Jump if Negative (JN): If S = 1, the result was negative.
Jump if Overflow (JO): If V = 1, a signed overflow occurred.

*/

///////////////////////logic for condition flag
reg sign = 0, zero = 0, overflow = 0, carry = 0;
reg [16:0] temp_sum;

always@(*)
begin

/////////////////sign bit
if(`oper_type == `mul)
  sign = SGPR[15];
else
  sign = GPR[`rdst][15];

////////////////carry bit

if(`oper_type == `add)
   begin
      if(`imm_mode)
         begin
         temp_sum = GPR[`rsrc1] + `isrc;
         carry    = temp_sum[16]; 
         end
      else
         begin
         temp_sum = GPR[`rsrc1] + GPR[`rsrc2];
         carry    = temp_sum[16]; 
         end   end
   else
    begin
        carry  = 1'b0;
    end

///////////////////// zero bit
if(`oper_type == `mul)
  zero =  ~((|SGPR[15:0]) | (|GPR[`rdst]));
else
  zero =  ~(|GPR[`rdst]); 


//////////////////////overflow bit

if(`oper_type == `add)
     begin
       if(`imm_mode)
         overflow = ( (~GPR[`rsrc1][15] & ~IR[15] & GPR[`rdst][15] ) | (GPR[`rsrc1][15] & IR[15] & ~GPR[`rdst][15]) );
       else
         overflow = ( (~GPR[`rsrc1][15] & ~GPR[`rsrc2][15] & GPR[`rdst][15]) | (GPR[`rsrc1][15] & GPR[`rsrc2][15] & ~GPR[`rdst][15]));
     end
  else if(`oper_type == `sub)
    begin
       if(`imm_mode)
         overflow = ( (~GPR[`rsrc1][15] & IR[15] & GPR[`rdst][15] ) | (GPR[`rsrc1][15] & ~IR[15] & ~GPR[`rdst][15]) );
       else
         overflow = ( (~GPR[`rsrc1][15] & GPR[`rsrc2][15] & GPR[`rdst][15]) | (GPR[`rsrc1][15] & ~GPR[`rsrc2][15] & ~GPR[`rdst][15]));
    end 
  else
     begin
     overflow = 1'b0;
     end

end



endmodule
