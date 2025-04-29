`timescale 1ns / 1ps

/*********
*
* Module: Mem.v
* Project: RISC-V Processor
* Author: Adham Ali, Saif Abdelfattah
* Description: This module implements the memory unit for the RISC-V processor. It supports both read and write operations based on control signals.
*
* Change history: 13/11/2024
********/


module Mem(
    input clk,
    input MemRead,
    input MemWrite,
    input [2:0] func3,
    input [13:0] addr,
    input [31:0] dataIn,
    output reg [31:0] dataO
);

    reg [7:0] mem [0:4095];
    reg [31:0] neww [0:31];

    initial begin
        $readmemh("C:/Users/saif_ahmed/tests/test2/test_case2.hex", neww);
    end

    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1)
            {mem[(i * 4) + 3], mem[(i * 4) + 2], mem[(i * 4) + 1], mem[i * 4]} = neww[i];
    end

    initial begin
        {mem[131], mem[130], mem[129], mem[128]} = 32'd17;
        {mem[135], mem[134], mem[133], mem[132]} = 32'd9;
        {mem[139], mem[138], mem[137], mem[136]} = 32'd25;
        {mem[143], mem[142], mem[141], mem[140]} = 32'd34;
    end

    always @(posedge clk) begin
        if (MemWrite == 1'b1) begin
            case (func3)
                3'b000: mem[addr[13:7] + 128] = dataIn[7:0];
                3'b001: {mem[addr[13:7] + 129], mem[addr[13:7] + 128]} = dataIn[15:0];
                3'b010: {mem[addr[13:7] + 131], mem[addr[13:7] + 130], mem[addr[13:7] + 129], mem[addr[13:7] + 128]} = dataIn;
                default: ;
            endcase
        end
    end

    always @(*) begin
        if (~clk) begin
            if (MemRead) begin
                case (func3)
                    3'd0: dataO <= {{24{mem[addr[13:7] + 128][7]}}, mem[addr[13:7] + 128]}; // Sign-extend byte
                    3'd1: dataO <= {{16{mem[addr[13:7] + 1 + 128][7]}}, mem[addr[13:7] + 1 + 128], mem[addr[13:7] + 128]};
                    3'd2: dataO <= {mem[addr[13:7] + 3 + 128], mem[addr[13:7] + 2 + 128], mem[addr[13:7] + 1 + 128], mem[addr[13:7] + 128]};
                    3'd4: dataO <= {24'd0, mem[addr[13:7] + 128]};
                    3'd5: dataO <= {16'd0, mem[addr[13:7] + 1 + 128], mem[addr[13:7] + 128]};
                    default: dataO <= 0;
                endcase
            end
        end else begin
            dataO = {mem[addr[6:0] + 3], mem[addr[6:0] + 2], mem[addr[6:0] + 1], mem[addr[6:0]]};
        end
    end

endmodule
