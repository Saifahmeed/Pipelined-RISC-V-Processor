`timescale 1ns / 1ps
/*********
*
* Module: ALUN.v
* Project: RISC-V Processor
* Author: Adham Ali, Saif Abdelfattah
* Description: ALU module supporting arithmetic and logical operations based on `Sel` control signal.
*
* Change history: 01/11/2024
********/

module ALUN #(parameter N = 32)(
    input [N - 1 : 0] A,
    input [N - 1 : 0] B,
    input [3 : 0] Sel,
    output reg [N - 1 : 0] out,
    output Zerof,
    output Sf,
    output Vf,
    output C
);

    reg [N - 1 : 0] NEWB;
    wire [31 : 0] Newout;
    wire [N - 1 : 0] BBoP;

    assign Zerof = (out == 0);
    assign BBoP = (~B);
    assign Sf = out[31];
    assign Vf = (A[31] ^ BBoP[31] ^ out[31] ^ C);

    always @(*) begin
        case (Sel)
            4'b0110: NEWB = (~B + 1);
            4'b0010: NEWB = B;
        endcase
    end

    rca rcainalu (A, NEWB, {C, Newout});

    always @(*) begin
        case (Sel)
            4'b0010: out = Newout;
            4'b0110: out = Newout;
            4'b1000: out = A << B;
            4'b1101: out = ($signed(A) < $signed(B)) ? 1 : 0;
            4'b0011: out = A ^ B;
            4'b0111: out = $signed(A) >>> B;
            4'b0000: out = A & B;
            4'b0001: out = A | B;
            4'b0100: out = A >> B;
            4'b1111: out = (A < B) ? 1 : 0;
        endcase
    end

endmodule
