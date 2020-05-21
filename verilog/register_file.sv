// -----------------------------------------------------------------------------
// Universidade Federal do Recôncavo da Bahia
// -----------------------------------------------------------------------------
// Author : Ejziel Santos, Fabrício Jesus, Mateus Velame, Rodrigo Suzart
// File   : register_file.sv
// Editor : Sublime Text 3, tab size (3)
// -----------------------------------------------------------------------------
// Module Purpose:
//    Register file
// -----------------------------------------------------------------------------
// Entradas: 
//      clock        : clock do sistema
//      wr           : write enable
//      ReadAddr1    : endereço de leitura 1
//      ReadAddr2    : endereço de leitura 2
//      WriteAddr    : endereço de escrita
//      WriteData    : dado a ser escrito na memória (se wr == 1)
// -----------------------------------------------------------------------------
// Saidas:
//      ReadData1    : dado lido da memória para ReadAddr1
//      ReadData2    : dado lido da memória para ReadAddr2
// -----------------------------------------------------------------------------

`timescale 1ns / 1ps
`default_nettype none

module register_file #(
   parameter Nloc = 32,                      // Quantidade de posições de memória
   parameter Dbits = 32                      // Quantidade de bits de dado
)(

   input wire clock,
   input wire Werf,                            // WriteEnable:  se wr==1, o dado é escrito em mem
   input wire [$clog2(Nloc)-1 : 0] ReadAddr1, ReadAddr2, WriteAddr, 	
                                             // 3 enderecos, dois para leitura e um para escrita
   input wire [Dbits-1 : 0] WriteData,       // Dado a ser escrito na memória (se wr==1)
   output logic [Dbits-1 : 0] ReadData1, ReadData2
                                             // 2 portas de saída
   );

   logic [Dbits-1 : 0] rf [Nloc-1 : 0];                     // Registradores onde o dado será armazenado

   always_ff @(posedge clock)                // Escrita na memória: somente quando wr==1, e somente na borda de subida do clock
      if(Werf)
         rf[WriteAddr] <= WriteData;
   
   assign ReadData1 = (ReadAddr1 == 0) ? 0 : rf[ReadAddr1];     // Primeira porta de saída
   assign ReadData2 = (ReadAddr2 == 0) ? 0 : rf[ReadAddr2];     // Segunda porta de saída
   
endmodule
