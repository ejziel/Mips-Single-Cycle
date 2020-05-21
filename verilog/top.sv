// -----------------------------------------------------------------------------
// Universidade Federal do Recôncavo da Bahia
// -----------------------------------------------------------------------------
// Author : Ejziel Santos, Fabrício Jesus, Mateus Velame, Rodrigo Suzart
// File   : top.sv
// Create : 2019-11-07 21:24:18
// Editor : Sublime Text 3, tab size (3)
// -----------------------------------------------------------------------------
// Module Purpose:
//		Estrutura top level do processador MIPS231 com memórias
// -----------------------------------------------------------------------------
// Entradas: 
// 	enable : sinal de controle de escrita
// 	clk    : clock do processador
// 	reset  : sinal de reset
// -----------------------------------------------------------------------------

`timescale 1ns / 1ps
`default_nettype none

module top #(
    parameter imem_init="full_imem.mem",		// corrija o nome do arquivo dentro da pasta ../sim/test 
    parameter dmem_init="full_dmem.mem"		// corrija o nome do arquivo dentro da pasta ../sim/test 
)(
    input wire clk, reset, enable
);
   
   wire [31:0] pc, instr, mem_readdata, mem_writedata, mem_addr;
   wire mem_wr;

   mips mips(clk, reset, enable, instr, mem_readdata, pc, mem_wr, mem_addr, mem_writedata);

   imem #(.Nloc(64), .Dbits(32), .initfile(imem_init)) imem(pc[31:2], instr);  
   							// ignore os dois LSBs do endereço para a memória de instruções
   							
   dmem #(.Nloc(64), .Dbits(32), .initfile(dmem_init)) dmem(clk, mem_wr, mem_addr[31:2], mem_writedata, mem_readdata); 
   							// ignore os dois LSBs para o endereço da memória de dados

endmodule
