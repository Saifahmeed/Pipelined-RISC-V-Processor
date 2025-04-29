`timescale 1ns / 1ps

/*********
*
* Module: DFlipFlop.v
* Project: RISC-V Processor
* Author: Adham Ali, Saif Abdelfattah
* Description: This module implements a D flip-flop with an asynchronous reset. 
*
* Change history: 1/10/2024
********/


module DFlipFlop (
    input clk,
    input rst,
    input D,
    output reg Q
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Q <= 1'b0;
        end else begin
            Q <= D;
        end
    end

endmodule
