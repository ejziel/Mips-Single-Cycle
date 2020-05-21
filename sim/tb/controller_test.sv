// -----------------------------------------------------------------------------
// Universidade Federal do Recôncavo da Bahia
// -----------------------------------------------------------------------------
// Author : Ejziel Santos, Fabrício Jesus, Mateus Velame, Rodrigo Suzart
// File   : controller_test.sv
// Create : 2019-11-07 23:02:35
// Editor : Sublime Text 3, tab size (3)
// -----------------------------------------------------------------------------
// Description:
//  Testbench para a unidade de controle do MIPS231
// -----------------------------------------------------------------------------

`timescale 1ns / 1ps
`default_nettype none 
`include "opcode.svh"
`include "aluop.svh" 

module controller_test;

   logic enable = 1'b1;
   logic [5:0] op;
   logic [5:0] func;
   logic Z;
   
   wire [1:0] pcsel;
   wire [1:0] wasel; 
   wire sext;
   wire bsel;
   wire [1:0] wdsel; 
   wire [3:0] alufn; 
   wire wr;
   wire werf; 
   wire [1:0] asel;

   // Instantiate the Unit Under Test (UUT)
   controller uut(.*);                      // The ".*" connects all signals by name

   initial begin
      enable = 1'b1;

      // Add stimulus here
      // Inputs change every 1 ns
      
      #1 {op, func, Z} = {`LW,    6'b xxxxxx, 1'b x};
      #1 {op, func, Z} = {`SW,    6'b xxxxxx, 1'b x};
      #1 {op, func, Z} = {`ADDI,  6'b xxxxxx, 1'b x};
      #1 {op, func, Z} = {`ADDIU, 6'b xxxxxx, 1'b x};
      #1 {op, func, Z} = {`SLTI,  6'b xxxxxx, 1'b x};
      #1 {op, func, Z} = {`SLTIU, 6'b xxxxxx, 1'b x};
      #1 {op, func, Z} = {`ORI,   6'b xxxxxx, 1'b x};
      #1 {op, func, Z} = {`LUI,   6'b xxxxxx, 1'b x};
      #1 {op, func, Z} = {`BEQ,   6'b xxxxxx, 1'b 0};
      #1 {op, func, Z} = {`BEQ,   6'b xxxxxx, 1'b 1};
      #1 {op, func, Z} = {`BNE,   6'b xxxxxx, 1'b 0};
      #1 {op, func, Z} = {`BNE,   6'b xxxxxx, 1'b 1};
      #1 {op, func, Z} = {`J,     6'b xxxxxx, 1'b x};
      #1 {op, func, Z} = {`JAL,   6'b xxxxxx, 1'b x};
      
      #1 {op, func, Z} = {6'b 000000, `ADD,   1'b x};
      #1 {op, func, Z} = {6'b 000000, `SUB,   1'b x};
      #1 {op, func, Z} = {6'b 000000, `AND,   1'b x};
      #1 {op, func, Z} = {6'b 000000, `OR,    1'b x};
      #1 {op, func, Z} = {6'b 000000, `XOR,   1'b x};
      #1 {op, func, Z} = {6'b 000000, `NOR,   1'b x};
      #1 {op, func, Z} = {6'b 000000, `SLT,   1'b x};
      #1 {op, func, Z} = {6'b 000000, `SLTU,  1'b x};
      #1 {op, func, Z} = {6'b 000000, `SLL,   1'b x};
      #1 {op, func, Z} = {6'b 000000, `SLLV,  1'b x};
      #1 {op, func, Z} = {6'b 000000, `SRL,   1'b x};
      #1 {op, func, Z} = {6'b 000000, `SRA,   1'b x};
      #1 {op, func, Z} = {6'b 000000, `JR,    1'b x};

      #1 {op, func, Z} = {6'b 000000, `ADD,   1'b x};	// werf should be 1
      #1 enable = 1'b0;					                // disable processor
      #1 {op, func, Z} = {6'b 000000, `ADD,   1'b x};	// werf should be 0
      #1 enable = 1'b1;					                // re-enable processor
      #1 {op, func, Z} = {`SW,    6'b xxxxxx, 1'b x};	// wr should be 1
      #1 enable = 1'b0;					                // disable processor
      #1 {op, func, Z} = {`SW,    6'b xxxxxx, 1'b x};	// wr should be 0


      // Wait another 2 ns, and then finish simulation
      #2 $finish;
   end




   // SELF-CHECKING CODE
   
   selfcheck c();  // c(checker_RD1, checker_RD2, checker_ALUResult, checker_FlagZ);
   
   function mismatch;  // some trickery needed to match two values with don't cares
       input p, q;      // mismatch in a bit position is ignored if q has an 'x' in that bit
       integer p, q;
       mismatch = (((p ^ q) ^ q) !== q);
   endfunction
   
   wire ERROR;
   
   wire ERROR_pcsel = mismatch(pcsel, c.pcsel)? 1'bX : 1'b0;
   wire ERROR_wasel = mismatch(wasel, c.wasel)? 1'bX : 1'b0;
   wire ERROR_sext  = mismatch(sext, c.sext)? 1'bX : 1'b0;
   wire ERROR_bsel  = mismatch(bsel, c.bsel)? 1'bX : 1'b0;
   wire ERROR_wdsel = mismatch(wdsel, c.wdsel)? 1'bX : 1'b0;
   wire ERROR_alufn = mismatch(alufn, c.alufn)? 1'bX : 1'b0;
   wire ERROR_wr    = mismatch(wr, c.wr)? 1'bX : 1'b0;
   wire ERROR_werf  = mismatch(werf, c.werf)? 1'bX : 1'b0;
   wire ERROR_asel  = mismatch(asel, c.asel)? 1'bX : 1'b0;
   
   assign ERROR = ERROR_pcsel | ERROR_wasel | ERROR_sext | ERROR_bsel | ERROR_wdsel | ERROR_alufn | ERROR_wr | ERROR_werf | ERROR_asel;
   

   initial begin
      //$monitor("#%5d {pcsel, wasel, sext, bsel, wdsel, alufn, wr, werf, asel} <= {2'b%b, 2'b%b, 1'b%b, 1'b%b, 2'b%b, 5'b%b, 1'b%b, 1'b%b, 2'b%b};", $time, {pcsel, wasel, sext, bsel, wdsel, alufn, wr, werf, asel});
      $monitor("#%02d {pcsel, wasel, sext, bsel, wdsel, alufn, wr, werf, asel} <= {17'b%b};", $time, {pcsel, wasel, sext, bsel, wdsel, alufn, wr, werf, asel});
   end
   
endmodule


// CHECKER MODULE
module selfcheck();
   logic [1:0] pcsel;
   logic [1:0] wasel;
   logic sext;
   logic bsel;
   logic [1:0] wdsel;
   logic [3:0] alufn; //tava [3:0] alufn;
   logic wr;
   logic werf;
   logic [1:0] asel;
      
   initial begin
   fork
   #00 {pcsel, wasel, sext, bsel, wdsel, alufn, wr, werf, asel} <= {17'bxxxxxxxxxxxx00xx};
   #01 {pcsel, wasel, sext, bsel, wdsel, alufn, wr, werf, asel} <= {17'b0001111000000100};
   #02 {pcsel, wasel, sext, bsel, wdsel, alufn, wr, werf, asel} <= {17'b00xx11xx00001000};
   #03 {pcsel, wasel, sext, bsel, wdsel, alufn, wr, werf, asel} <= {17'b0001110100000100};
   #05 {pcsel, wasel, sext, bsel, wdsel, alufn, wr, werf, asel} <= {17'b0001110100100100};
   #06 {pcsel, wasel, sext, bsel, wdsel, alufn, wr, werf, asel} <= {17'b0001110100110100};
   #07 {pcsel, wasel, sext, bsel, wdsel, alufn, wr, werf, asel} <= {17'b0001010101010100};
   #08 {pcsel, wasel, sext, bsel, wdsel, alufn, wr, werf, asel} <= {17'b0001x10101110110}; 
   #09 {pcsel, wasel, sext, bsel, wdsel, alufn, wr, werf, asel} <= {17'b00xx10xx00010000};
   #10 {pcsel, wasel, sext, bsel, wdsel, alufn, wr, werf, asel} <= {17'b01xx10xx00010000};
   #12 {pcsel, wasel, sext, bsel, wdsel, alufn, wr, werf, asel} <= {17'b00xx10xx00010000};
   #13 {pcsel, wasel, sext, bsel, wdsel, alufn, wr, werf, asel} <= {17'b10xxxxxxxxxx00xx};
   #14 {pcsel, wasel, sext, bsel, wdsel, alufn, wr, werf, asel} <= {17'b1010xx00xxxx01xx};
   #15 {pcsel, wasel, sext, bsel, wdsel, alufn, wr, werf, asel} <= {17'b0000x00100000100};
   #16 {pcsel, wasel, sext, bsel, wdsel, alufn, wr, werf, asel} <= {17'b0000x00100010100};
   #17 {pcsel, wasel, sext, bsel, wdsel, alufn, wr, werf, asel} <= {17'b0000x00101000100};
   #18 {pcsel, wasel, sext, bsel, wdsel, alufn, wr, werf, asel} <= {17'b0000x00101010100};
   #19 {pcsel, wasel, sext, bsel, wdsel, alufn, wr, werf, asel} <= {17'b0000x00101100100};
   #20 {pcsel, wasel, sext, bsel, wdsel, alufn, wr, werf, asel} <= {17'b0000x00110110100};
   #21 {pcsel, wasel, sext, bsel, wdsel, alufn, wr, werf, asel} <= {17'b0000x00100100100};
   #22 {pcsel, wasel, sext, bsel, wdsel, alufn, wr, werf, asel} <= {17'b0000x00100110100};
   #23 {pcsel, wasel, sext, bsel, wdsel, alufn, wr, werf, asel} <= {17'b0000x00110000101};
   #24 {pcsel, wasel, sext, bsel, wdsel, alufn, wr, werf, asel} <= {17'b0000x00110000100};
   #25 {pcsel, wasel, sext, bsel, wdsel, alufn, wr, werf, asel} <= {17'b0000x00110010101};
   #26 {pcsel, wasel, sext, bsel, wdsel, alufn, wr, werf, asel} <= {17'b0000x00110100101};
   #27 {pcsel, wasel, sext, bsel, wdsel, alufn, wr, werf, asel} <= {17'b11xxxxxxxxxx00xx};
   #28 {pcsel, wasel, sext, bsel, wdsel, alufn, wr, werf, asel} <= {17'b0000x00100000100};
   #29 {pcsel, wasel, sext, bsel, wdsel, alufn, wr, werf, asel} <= {17'b0000x00100000000};
   #31 {pcsel, wasel, sext, bsel, wdsel, alufn, wr, werf, asel} <= {17'b0000x00100000100};
   #32 {pcsel, wasel, sext, bsel, wdsel, alufn, wr, werf, asel} <= {17'b00xx11xx00001000};
   #33 {pcsel, wasel, sext, bsel, wdsel, alufn, wr, werf, asel} <= {17'b00xx11xx00000000};   
   join
   end
endmodule
