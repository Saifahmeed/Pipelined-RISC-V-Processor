/*********
*
* Module: ALUCU.v
* Project: RISC-V Processor
* Author: Adham Ali, Saif Abdelfattah
* Description: ALU control unit to generate ALU selection signals based on instruction fields and ALU operation type.
*
* Change history: 03/11/2024
********/

`timescale 1ns / 1ps

module ALUCU(
    input [2:0] inst14,
    input inst30,
    input [1:0] ALUop,
    output reg [3:0] ALUsel
);

    always @(*) begin
        if (ALUop == 2'b00)
            ALUsel = 4'b0010;
        if (ALUop == 2'b01)
            ALUsel = 4'b0110;

        if (ALUop == 2'b11) begin
            case (inst14)
                3'b000: ALUsel = 4'b0010;
                3'b111: ALUsel = 4'b0000;
                3'b110: ALUsel = 4'b0001;
                3'b100: ALUsel = 4'b0011;
                3'b101: ALUsel = (inst30 == 1'b0) ? 4'b0100 : 4'b0111;
                3'b001: ALUsel = 4'b1000;
                3'b010: ALUsel = 4'b1101;
                3'b011: ALUsel = 4'b1111;
            endcase
        end

        if (ALUop == 2'b10) begin
            case ({inst14, inst30})
                4'b0000: ALUsel = 4'b0010;
                4'b0001: ALUsel = 4'b0110;
                4'b1110: ALUsel = 4'b0000;
                4'b1100: ALUsel = 4'b0001;
                4'b1000: ALUsel = 4'b0011;
                4'b1010: ALUsel = 4'b0100;
                4'b1011: ALUsel = 4'b0111;
                4'b0010: ALUsel = 4'b1000;
                4'b0100: ALUsel = 4'b1101;
                4'b0110: ALUsel = 4'b1111;
            endcase
        end
    end

endmodule

