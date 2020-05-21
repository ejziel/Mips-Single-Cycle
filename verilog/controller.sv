// -----------------------------------------------------------------------------
// Universidade Federal do Recôncavo da Bahia
// -----------------------------------------------------------------------------
// Author : Ejziel Santos, Fabrício Jesus, Mateus Velame, Rodrigo Suzart
// File   : controller.sv
// Create : 2019-11-07 22:26:57
// Editor : Visual Studio Code
// -----------------------------------------------------------------------------
// Module Purpose:
//		Unidade de controle para o processador MIPS231
// -----------------------------------------------------------------------------
// Entradas: 
// 	enable : sinal de controle de escrita
// 	op     : opcode da instrução
// 	func   : função para instruções R-type
//    Z      : flag zero vinda da ALU
// -----------------------------------------------------------------------------					
// Saidas:
// 	pcsel  : seletor do multiplexador de PC.
//    wasel  : seletor do multiplexador do endereço de escrita no register file
//    sext   : controle do sign extend (0 zero-extends, 1 sign-extends)
//    bsel   : seletor do multiplexador da entrada B da ALU
//    wdsel  : seletor do multiplexador de dados de escrita no register file
//    alufn  : função a ser executada pela ALU
//    wr     : write enable da memória de dados
//    werf   : write enable do register file
//    asel   : seletor do multiplexador da entrada A da ALU
// -----------------------------------------------------------------------------

`timescale 1ns / 1ps
`default_nettype none
`include "opcode.svh"
`include "aluop.svh" //Não tinha isso

module controller(
   input  wire enable,
   input  wire [5:0] op, 
   input  wire [5:0] func,
   input  wire Z,
   output wire [1:0] pcsel,
   output wire [1:0] wasel, 
   output wire sext,
   output wire bsel,
   output wire [1:0] wdsel, 
   output logic [3:0] alufn, 			
   output wire wr,
   output wire werf, 
   output wire [1:0] asel
   ); 

  assign pcsel = ((op == 6'b0) & (func == `JR)) ? 2'b11   // controla o multiplexador de  4-entradas
               : ((op == 6'b000100) & (Z)) || ((op == 6'b000101) & (!Z)) ?
       2'b01  : ((op == 6'b000010) || (op == 6'b000011))  ?                         
       2'b10  : 2'b00;

  logic [9:0] controls;
  wire _werf_, _wr_;
  assign werf = _werf_ & enable;       // desativa as escritas no registrador quando o processador está desativado
  assign wr = _wr_ & enable;           // destiva a escrita na memória quando o processador está desativado 
 
  assign {_werf_, wdsel[1:0], wasel[1:0], asel[1:0], bsel, sext, _wr_} = controls[9:0];

  always_comb
     case(op)                                       // instruções non-R-type 
        `LW: controls <= 10'b 1_10_01_00_1_1_0;     // LW
        `SW: controls <= 10'b 0_XX_01_00_1_1_1;     // SW
      `ADDI,                                        // ADDI
     `ADDIU,                                        // ADDIU
      `SLTI: controls <= 10'b 1_01_01_00_1_1_0;       // SLTI
     `SLTIU: controls <= 10'b 1_01_01_00_1_1_0;     // SLITIU
       `ORI: controls <= 10'b 1_01_01_00_1_0_0;     // ORI
       `LUI: controls <= 10'b 1_01_01_10_1_X_0;     // LUI
      `ANDI: controls <= 10'b 1_01_01_00_1_0_0;                                        // ANDI
      `XORI: controls <= 10'b 1_01_01_00_1_0_0;    // XORI
       `BEQ: controls <= 10'b 0_XX_XX_00_0_1_0;     // BEQ
       `BNE: controls <= 10'b 0_XX_XX_00_0_1_0;     // BNE
         `J: controls <= 10'b 0_XX_XX_XX_X_X_0;     // J 
       `JAL: controls <= 10'b 1_00_10_XX_X_X_0;     // JAL
      6'b000000:                                    
         case(func)                                 // R-type
             `ADD,
            `ADDU,                                        // ADD and ADDU
             `SUB: controls <= 10'b 1_01_00_00_0_X_0;     // SUB
             `AND: controls <= 10'b 1_01_00_00_0_X_0;     // AND
              `OR: controls <= 10'b 1_01_00_00_0_X_0;     // OR
             `XOR: controls <= 10'b 1_01_00_00_0_X_0;     // XOR
             `NOR: controls <= 10'b 1_01_00_00_0_X_0;     // NOR
             `SLT: controls <= 10'b 1_01_00_00_0_X_0;     // SLT
            `SLTU: controls <= 10'b 1_01_00_00_0_X_0;     // SLTU
             `SLLV: controls <= 10'b 1_01_00_00_0_X_0;    // SLLV 
             `SLL: controls <= 10'b 1_01_00_01_0_X_0;     // SLL
             `SRL: controls <= 10'b 1_01_00_01_0_X_0;     // SRL
             `SRA: controls <= 10'b 1_01_00_01_0_X_0;     // SRA
              `JR: controls <= 10'b 0_XX_XX_XX_X_X_0;     // JR
            default:   controls <= 10'b 0_xx_xx_xx_x_x_0; // instrução desconhecida, desative a escrita no registrador e na memória
         endcase
      default: controls <= 10'b 0_xx_xx_xx_x_x_0;         // instrução desconhecida, desative a escrita no registrador e na memória
    endcase
    

   aludec alu_decoder (
      .funct(func),
      .opcode(op),
      .aluop(alufn)
   );
    
endmodule
