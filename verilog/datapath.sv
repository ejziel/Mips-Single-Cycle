// -----------------------------------------------------------------------------
// Universidade Federal do Recôncavo da Bahia
// -----------------------------------------------------------------------------
// Author : Ejziel Santos, Fabrício Jesus, Mateus Velame, Rodrigo Suzart
// File   : datapath.sv
// Create : 2019-10-23 14:58:37
// Editor : Visual Studio Code
// -----------------------------------------------------------------------------
// Module Purpose:
//    Datapath of mips processor
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps
`default_nettype none
`include "opcode.svh"
`include "aluop.svh"

module datapath #(
   	parameter Nloc = 32,                      
   	parameter Dbits = 32                     
	)(
		input wire clk,
		input wire reset,
		input wire enable,
		input wire [31:0] instr,
		input wire [1:0] pcsel,
		input wire [1:0] wasel,
		input wire sext,
		input wire bsel,
		input wire [1:0] wdsel,
		input wire [3:0] alufn,
		input wire werf,
		input wire [1:0] asel,
		output logic [31:0] pc,
		output wire Z,
		output wire [Dbits-1:0] mem_addr,
		output wire [Dbits-1:0] mem_writedata,
		input wire [Dbits-1:0] mem_readdata                                        
	);

	logic [$clog2(Nloc)-1 : 0] reg_writeaddr;
	logic [Dbits-1 : 0] reg_writedata;
	logic [Dbits-1 : 0] ReadData1, ReadData2, ALUResult, aluA, aluB, signImm, newPC;
	logic [Dbits-1 : 0] pcPlus4, BT, JT;

	initial begin
		newPC = 32'h00400000;
	end

	always @(*) begin
		case (wasel)
		2'b00 : reg_writeaddr = instr[15:11];
		2'b01 : reg_writeaddr = instr[20:16];
		2'b10 : reg_writeaddr = 31;
		endcase
	end

	always @(*) begin
		case (wdsel)
		2'b00 : reg_writedata = pcPlus4; 
		2'b01 : reg_writedata = ALUResult;
		2'b10 : reg_writedata = mem_readdata;
		endcase
	end

	always @(*) begin
		case (asel)
		2'b00 : aluA = ReadData1; 
		2'b01 : aluA = instr[10:6];
		2'b10 : aluA = 16;
		endcase
	end
	
	always @(*) begin
		case (sext)
		1'b0 : signImm = {16'h0000, instr[15:0]}; 
		1'b1 : signImm = {{16{instr[15]}}, instr[15:0]};
		default : signImm = {16'h0000, instr[15:0]};
		endcase
	end
	

	always @(*) begin
		case (bsel)
		1'b0 : aluB = ReadData2;
		1'b1 : aluB = signImm;
		endcase
	end

	always @(*) begin		
		case (pcsel)
			2'b00 : newPC = pcPlus4; 
			2'b01 : newPC = BT; 
			2'b10 : newPC = {pc[31:28],instr[25:0],2'b00};
			2'b11 : newPC = ReadData1; //JT
		endcase
	end

	
	always_ff @(posedge clk) begin
		if(~reset) begin
			if(enable) begin
				pc = newPC;
				pcPlus4 = pc + 32'h4;
				BT = pcPlus4 + (signImm<<2);
			end
		end else begin
			pc = 32'h00400000;
		end
	end
	

	register_file #(Nloc, Dbits) register (
		.clock(clk),
		.Werf(werf),
		.ReadAddr1(instr[25:21]), 
      	.ReadAddr2(instr[20:16]), 
      	.WriteAddr(reg_writeaddr),
      	.WriteData(reg_writedata), 
      	.ReadData1(ReadData1), 
      	.ReadData2(ReadData2)
	);


	alu ALU (
		.A(aluA),
		.B(aluB),
		.aluop(alufn),
		.out(ALUResult),
		.Z(Z)
	);

	assign mem_writedata[Dbits-1:0] = ReadData2[31:0];
	assign mem_addr[Dbits-1:0] = ALUResult[31:0];

endmodule
