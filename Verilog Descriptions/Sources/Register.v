`timescale 1ns / 1ps
/*********
*
* Module: Register.v
* Project: RISC-V Processor
* Author: Adham Ali, Saif Abdelfattah
* Description: This module implements a parameterized register with n-bit width. It uses D flip-flops to store the input data when load is high and reset functionality for asynchronous reset.
*
* Change history: 09/11/2024
********/


module Register #(parameter n = 8)(
    input clk,
    input load,
    input rst,
    input [n-1:0] D,
    output [n-1:0] Q
);
    wire [n-1:0] ans;
    genvar i;

    generate
        for (i = 0; i < n; i = i + 1) begin
            assign ans[i] = (load == 0) ? Q[i] : D[i];
            DFlipFlop df(.clk(clk), .rst(rst), .D(ans[i]), .Q(Q[i]));
        end
    endgenerate

endmodule
