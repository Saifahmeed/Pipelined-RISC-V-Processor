`timescale 1ns / 1ps

/*********
*
* Module: ForwardingUnit.v
* Project: RISC-V Processor
* Author: Adham Ali, Saif Abdelfattah
* Description: This module handles data forwarding to resolve hazards in the pipeline of the RISC-V processor.
* Change history: 05/10/2024
********/

`timescale 1ns / 1ps

module ForwardingUnit(
    input [4:0] ID_EX_rs1,
    input [4:0] ID_EX_rs2,
    input [4:0] EX_MEM_rd,
    input [4:0] MEM_WB_rd,
    input EX_MEM_CTRL_regwrite,
    input MEM_WB_CTRL_regwrite,
    output reg [1:0] ForwardA,
    output reg [1:0] ForwardB
);

    always @(*) begin
        if ((EX_MEM_CTRL_regwrite == 1'b1) && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rs1))
            ForwardA = 2'b10;
        else
            ForwardA = 2'b00;

        if ((EX_MEM_CTRL_regwrite == 1'b1) && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rs2))
            ForwardB = 2'b10;
        else
            ForwardB = 2'b00;
    end

endmodule
