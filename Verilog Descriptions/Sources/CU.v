`timescale 1ns / 1ps
/*********
*
* Module: CU.v
* Project: RISC-V Processor
* Author: Adham Ali, Saif Abdelfattah
* Description: This module is the control unit of the RISC-V processor. It decodes the instruction opcode and generates the control signals required for different instruction types such as load, store, branch, and arithmetic operations.
*
* Change history: 13/11/2024
********/

`include "defines.v"

module CU(
    input [4:0] inst,
    output reg Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite,
    output reg [1:0] ALUOp,
    output reg Jal, Jalr, Lui, Auipc
);

    always @(*) begin
        case (inst)
            `OPCODE_Arith_R: begin
                Branch = 0; MemRead = 0; MemtoReg = 0; MemWrite = 0;
                ALUSrc = 0; RegWrite = 1; ALUOp = 2;
                Jal = 0; Jalr = 0; Lui = 0; Auipc = 0;
            end
            `OPCODE_Load: begin
                Branch = 0; MemRead = 1; MemtoReg = 1; MemWrite = 0;
                ALUSrc = 1; RegWrite = 1; ALUOp = 0;
                Jal = 0; Jalr = 0; Lui = 0; Auipc = 0;
            end
            `OPCODE_Store: begin
                Branch = 0; MemRead = 0; MemtoReg = 0; MemWrite = 1;
                ALUSrc = 1; RegWrite = 0; ALUOp = 0;
                Jal = 0; Jalr = 0; Lui = 0; Auipc = 0;
            end
            `OPCODE_Branch: begin
                Branch = 1; MemRead = 0; MemtoReg = 0; MemWrite = 0;
                ALUSrc = 0; RegWrite = 0; ALUOp = 1;
                Jal = 0; Jalr = 0; Lui = 0; Auipc = 0;
            end
            `OPCODE_Arith_I: begin
                Branch = 0; MemRead = 0; MemtoReg = 0; MemWrite = 0;
                ALUSrc = 1; RegWrite = 1; ALUOp = 3;
                Jal = 0; Jalr = 0; Lui = 0; Auipc = 0;
            end
            `OPCODE_JAL: begin
                Branch = 0; MemRead = 0; MemtoReg = 0; MemWrite = 0;
                RegWrite = 1; Jal = 1; Jalr = 0; Lui = 0; Auipc = 0;
            end
            `OPCODE_JALR: begin
                Branch = 0; MemRead = 0; MemtoReg = 0; MemWrite = 0;
                ALUOp = 0; ALUSrc = 1; RegWrite = 1;
                Jal = 0; Jalr = 1; Lui = 0; Auipc = 0;
            end
            `OPCODE_LUI: begin
                Branch = 0; MemRead = 0; MemtoReg = 0; MemWrite = 0;
                RegWrite = 1; Jal = 0; Jalr = 0; Lui = 1; Auipc = 0;
            end
            `OPCODE_AUIPC: begin
                Branch = 0; MemRead = 0; MemtoReg = 0; MemWrite = 0;
                RegWrite = 1; Jal = 0; Jalr = 0; Lui = 0; Auipc = 1;
            end
            5'b00011: begin
                Branch = 0; MemRead = 0; MemtoReg = 0; MemWrite = 0;
                RegWrite = 0; Jal = 0; Jalr = 0; Lui = 0; Auipc = 0;
            end
        endcase
    end

endmodule
