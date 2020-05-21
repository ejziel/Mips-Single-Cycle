// -----------------------------------------------------------------------------
// Universidade Federal do Recôncavo da Bahia
// -----------------------------------------------------------------------------
// Author : Ejziel Santos, Fabrício Jesus, Mateus Velame, Rodrigo Suzart
// File   : mips.sv
// Create : 2019-11-07 23:59:32
// Editor : Sublime Text 3, tab size (3)
// -----------------------------------------------------------------------------
// Module Purpose:
//		Estrutura top level do processador MIPS231
// -----------------------------------------------------------------------------
// Entradas: 
// 	enable : sinal de controle de escrita
// 	clk    : clock do processador
// 	reset  : sinal de reset
//    instr  : palavra da instrução de 32 bits
//    mem_readdata : dado lido da memória
// -----------------------------------------------------------------------------					
// Saidas:
// 	pc       : endereço da memória de instruções.
//    mem_wr   : habilita escrita na memória
//    mem_addr : endereço da memória de dados
//    mem_writedata   : dado a ser escrito na memória de dados
// -----------------------------------------------------------------------------

`timescale 1ns / 1ps
`default_nettype none

module mips (
   input wire clk, 
   input wire reset,
   input wire enable,    
   input wire [31:0] instr, 
   input wire [31:0] mem_readdata,
   output logic [31:0] pc, 
   output wire mem_wr, 
   output wire [31:0] mem_addr,
   output wire [31:0] mem_writedata    
);
    
   wire [1:0] pcsel, wdsel, wasel;
   wire [3:0] alufn;  
   wire Z, sext, bsel, dmem_wr, werf;
   wire [1:0] asel; 

   controller c (  
      .enable(enable), 
      .op(instr[31:26]), 
      .func(instr[5:0]), 
      .Z(Z),
      .pcsel(pcsel), 
      .wasel(wasel[1:0]), 
      .sext(sext), 
      .bsel(bsel), 
      .wdsel(wdsel), 
      .alufn(alufn), 
      .wr(mem_wr), 
      .werf(werf), 
      .asel(asel)
   );

   datapath #(    
      .Nloc(32), 
      .Dbits(32) 
   ) dp (
      .clk(clk), 
      .reset(reset), 
      .enable(enable),
      .pc(pc), 
      .instr(instr),
      .pcsel(pcsel), 
      .wasel(wasel[1:0]), 
      .sext(sext), 
      .bsel(bsel), 
      .wdsel(wdsel), 
      .alufn(alufn), 
      .werf(werf), 
      .asel(asel),
      .Z(Z), 
      .mem_addr(mem_addr), 
      .mem_writedata(mem_writedata), 
      .mem_readdata(mem_readdata)
   );

endmodule
