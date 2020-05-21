// -----------------------------------------------------------------------------
// Universidade Federal do Recôncavo da Bahia
// -----------------------------------------------------------------------------
// Author : Ejziel Santos, Fabrício Jesus, Mateus Velame, Rodrigo Suzart
// File   : alu.sv
// Create : 2019-04-13 15:56:57
// Editor : Visual Studio Code
// -----------------------------------------------------------------------------
// Module Purpose:
//		ALU de 32-bits para o processador MIPS231
// -----------------------------------------------------------------------------
// Entradas: 
// 	A: a 32-bit value
// 	B: a 32-bit value
// 	aluop: Selects the ALU's operation 
// -----------------------------------------------------------------------------					
// Saidas:
// 	out: The chosen function mapped to A and B.
//    Z: Flag Zero.
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps
`default_nettype none
`include "opcode.svh"
`include "aluop.svh"

module alu(
   input  wire  [31:0] A,B,
   input  wire  [3:0] aluop,
   output logic [31:0] out,
   output wire Z
);


always_comb begin
   case(aluop)   
      `ALU_ADDU: out <= (A + B);
      `ALU_SUBU: out <= (A - B);
      `ALU_SLT: out <= ($signed(A) < $signed(B));
      `ALU_SLTU: out <= (A < B);
      `ALU_AND: out <= (A & B);
      `ALU_OR: out <= (A | B);
      `ALU_XOR: out <= (A ^ B);
      `ALU_LUI: out <= {B[15:0],16'd0};
      `ALU_SLL: out <= (B << A);
      `ALU_SRL: out <= (B >> A);
      `ALU_SRA: out <= ($signed(B) >>> A);
      `ALU_NOR: out <= (~A & ~B);
      `ALU_XXX: out <= (32'd0);
   endcase
end

assign Z = (out == 0) ? 1'b1 : 1'b0;

endmodule
