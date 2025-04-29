`timescale 1ns / 1ps

/*********
*
* Module: BCD.v
* Project: RISC-V Processor
* Author: Adham Ali, Saif Abdelfattah
* Description: This module converts a 16-bit binary input into its BCD (Binary-Coded Decimal) representation, extracting the thousands, hundreds, tens, and ones digits using a double-dabble algorithm.
*
* Change history: 12/09/2024
********/


module BCD(
    input [15:0] num,
    output reg [3:0] thousands,
    output reg [3:0] Hundreds,
    output reg [3:0] Tens,
    output reg [3:0] Ones
);

    integer i;

    always @(num) begin
        thousands = 4'd0;
        Hundreds = 4'd0;
        Tens = 4'd0;
        Ones = 4'd0;

        for (i = 15; i >= 0; i = i - 1) begin
            if (thousands >= 5)
                thousands = thousands + 3;
            if (Hundreds >= 5)
                Hundreds = Hundreds + 3;
            if (Tens >= 5)
                Tens = Tens + 3;
            if (Ones >= 5)
                Ones = Ones + 3;

            thousands = thousands << 1;
            thousands[0] = Hundreds[3];
            Hundreds = Hundreds << 1;
            Hundreds[0] = Tens[3];
            Tens = Tens << 1;
            Tens[0] = Ones[3];
            Ones = Ones << 1;
            Ones[0] = num[i];
        end
    end

endmodule

