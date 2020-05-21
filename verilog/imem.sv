// -----------------------------------------------------------------------------
// Universidade Federal do Recôncavo da Bahia
// -----------------------------------------------------------------------------
// Author : Ejziel Santos, Fabrício Jesus, Mateus Velame, Rodrigo Suzart
// File   : imem.sv
// Editor : Sublime Text 3, tab size (3)
// -----------------------------------------------------------------------------
// Module Purpose:
//    Single-port ROM
// -----------------------------------------------------------------------------
// Entradas: 
//      
// -----------------------------------------------------------------------------
// Saidas:
//      
// -----------------------------------------------------------------------------

`timescale 1ns / 1ps
`default_nettype none

module imem #(
   parameter Nloc = 32,                      // Number of memory locations
   parameter Dbits = 32,                      // Number of bits in data
   parameter initfile = "imemfile.mem"          // Name of file with initial values
)(
    input wire [31:2] pc,
    output wire [31:0] instr
    );
       
    logic [Dbits-1:0] mem [Nloc-1:0];
    initial $readmemh(initfile, mem, 0, Nloc-1);
    
    assign instr = mem[pc[7:2]]; 
    
endmodule
