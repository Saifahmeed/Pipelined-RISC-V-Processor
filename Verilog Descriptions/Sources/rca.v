`timescale 1ns / 1ps
/*********
*
* Module: rca.v
* Project: RISC-V Processor
* Author: Adham Ali, Saif Abdelfattah
* Description: This module implements a parameterized Ripple Carry Adder (RCA) using full adders. 
* Change history: 20/04/2024
********/
module rca #(parameter N = 32)(
    input [N-1:0] A,
    input [N-1:0] B,
    output [N:0] sum
);

    wire [N-1:0] cin;

    fulladder fa(
        .A(A[0]),
        .B(B[0]),
        .cin(1'b0),
        .sum(sum[0]),
        .cout(cin[0])
    );

    genvar i;
    generate
        for (i = 1; i < N; i = i + 1) begin
            fulladder fa2(
                .A(A[i]),
                .B(B[i]),
                .cin(cin[i-1]),
                .sum(sum[i]),
                .cout(cin[i])
            );
        end
    endgenerate

    assign sum[N] = cin[N-1];

endmodule
