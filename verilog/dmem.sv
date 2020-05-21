// -----------------------------------------------------------------------------
// Universidade Federal do Recôncavo da Bahia
// -----------------------------------------------------------------------------
// Author : Ejziel Santos, Fabrício Jesus, Mateus Velame, Rodrigo Suzart
// File   : dmem.sv
// Editor : Sublime Text 3, tab size (3)
// -----------------------------------------------------------------------------
// Module Purpose:
//    Single-port RAM
// -----------------------------------------------------------------------------
// Entradas: 

// -----------------------------------------------------------------------------
// Saidas:
// -----------------------------------------------------------------------------

`timescale 1ns / 1ps
`default_nettype none

module dmem #(
   parameter Nloc = 32,                      // Number of memory locations
   parameter Dbits = 32,                      // Number of bits in data
   parameter initfile = "dmemfile.mem"          // Name of file with initial values
)(
    input wire clk,
    input wire mem_wr,
    input wire [31:2] mem_addr, 
    input wire [31:0] mem_writedata,
    output wire [31:0] mem_readdata
    );
    
       logic [Dbits-1 : 0] mem [Nloc-1 : 0];     // The actual storage where data resides
       initial $readmemh(initfile, mem, 0, Nloc-1); // Initialize memory contents from a file
    
       always_ff @(posedge clk)                // Memory write: only when wr==1, and only at posedge clock
          if(mem_wr)
             mem[mem_addr[7:2]] <= mem_writedata;
    
       assign mem_readdata = mem[mem_addr[7:2]];                  // Memory read: read continuously, no clock involved
    
endmodule