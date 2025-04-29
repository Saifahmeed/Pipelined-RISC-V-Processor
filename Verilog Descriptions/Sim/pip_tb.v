`timescale 1ns / 1ps
/*********
*
* Module: pip_tb.v
* Project: RISC-V Processor
* Author: Adham Ali, Saif Abdelfattah
* Description: This is the testbench for the Top module of the RISC-V processor. It initializes the clock and reset signals, and generates periodic clock signals to simulate the functionality of the processor.
*
* Change history: 10/11/2024
********/


module pip_tb();
    reg clk;
    reg rst;
    reg [1:0] ledsel;
    reg [3:0] ssdSel;
    reg ssdClk;
    wire [15:0] leds;
    wire [3:0] Anode;
    wire [6:0] ssd_out;

    localparam period = 10;
    Top top(clk, rst, ledsel, ssdSel, ssdClk, leds, Anode, ssd_out);

    initial begin
        ssdClk = 0;
        forever #(period / 2) ssdClk = ~ssdClk;
    end

    initial begin
        rst = 1;
        #period
        rst = 0;
        #(period * 50);
    end

endmodule
