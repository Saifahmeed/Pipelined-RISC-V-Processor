`timescale 1ns / 1ps
/*********
*
* Module: ImmGen.v
* Project: RISC-V Processor
* Author: Adham Ali, Saif Abdelfattah
* Description: Immediate generator for extracting and sign-extending immediate values from instructions.
*
* Change history: 05/11/2024
********/

module ImmGen(
    input [31:0] Instr,
    output reg [31:0] out
);

    reg [11:0] immedt;
    reg [20:0] immedt20;

    always @(*) begin
        if (Instr[6:0] == 7'b1101111)
            out = { {12{Instr[31]}}, Instr[19:12], Instr[20], Instr[30:25], Instr[24:21], 1'b0 };
        else if (Instr[6:0] == 7'b0010111 || Instr[6:0] == 7'b0110111) begin
            immedt20 = Instr[31:12];
            out = immedt20 << 12;
        end
        else if (Instr[6:0] == 7'b0100011) begin
            immedt = {Instr[31:25], Instr[11:7]};
            out = {{20{immedt[11]}}, immedt[11:0]};
        end
        else if (Instr[6:0] == 7'b1100011) begin
            immedt = {Instr[31], Instr[7], Instr[30:25], Instr[11:8]};
            out = {{19{immedt[11]}}, immedt[11:0], 1'b0};
        end
        else if (Instr[6:0] == 7'b0000011 || Instr[6:0] == 7'b1100111 || Instr[6:0] == 7'b0010011) begin
            if (Instr[14:12] == 3'h5 && Instr[30] == 1'b1) begin
                immedt = Instr[24:20];
                out = {27'd0, immedt};
            end
            else begin
                immedt = Instr[31:20];
                out = {{20{immedt[11]}}, immedt};
            end
        end
    end

endmodule
