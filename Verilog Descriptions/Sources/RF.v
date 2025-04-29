`timescale 1ns / 1ps
/*********
*
* Module: RF.v
* Project: RISC-V Processor
* Author: Adham Ali, Saif Abdelfattah
* Description: Register file module with 32 registers, supporting read and write operations.
*
* Change history: 10/11/2024
********/


module RF #(parameter N = 32)(
    input clk, rst,
    input [4:0] ReadReg1,
    input [4:0] ReadReg2,
    input [4:0] WriteReg,
    input [N-1:0] WriteData,
    input regWrite,
    output [N-1:0] ReadD1,
    output [N-1:0] ReadD2
);

    reg [N-1:0] RegFile [31:0];
    integer i;

    assign ReadD1 = RegFile[ReadReg1];
    assign ReadD2 = RegFile[ReadReg2];

    always @(negedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                RegFile[i] = 0;
        end
        else if (regWrite && (WriteReg != 0))
            RegFile[WriteReg] = WriteData;
    end

endmodule
