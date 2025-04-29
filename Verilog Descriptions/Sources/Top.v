`timescale 1ns / 1ps
/*********
*
* Module: Top.v
* Project: RISC-V Processor
* Author: Adham Ali, Saif Abdelfattah
* Description: This is the top-level module of the RISC-V processor. It handles the integration of components such as the ALU, register file, control unit, and memory. It manages the clocking, reset, and control signals for instruction execution and display.
*
* Change history: 13/11/2024
********/

module Top(
    input clk,
    input rst,
    input [1:0] ledsel,
    input [3:0] ssdSel,
    input ssdClk,
    output reg [15:0] leds,
    output reg [3:0] Anode,
    output reg [6:0] LED_out
);
wire [15:0] Signs;
reg [3:0] LEDbcd;
wire [31:0] new_PC;
wire [31:0] Inst_OUT;
wire [1:0] ALUOp;
wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
wire [31:0] WritData;
wire [31:0] out_PC;
reg [31:0] in_PC;
wire [31:0] GenOut;
wire [31:0] Imm_PC;
reg out_gate;
wire [31:0] ALUI2;
wire [3:0] ALUsel;
wire [31:0] ALU_out;
wire ZeroF;
wire JALR;
wire [31:0] pickInst;
wire [8:0] Muxed;
wire EX_MEM_Carry;
wire JAL;
wire AUIPC;
wire LUI;
wire PCsrc;
wire [31:0] dataOut;
wire [31:0] IF_ID_PC;
wire [31:0] IF_ID_Inst;
wire [31:0] ID_EX_PC;
wire [31:0] ID_EX_RegR1;
wire [31:0] ID_EX_RegR2;
wire [31:0] ID_EX_Imm;
wire [11:0] ID_EX_Ctrl;
wire [3:0] ID_EX_Func;
wire [4:0] ID_EX_Rs1;
wire [4:0] ID_EX_Rs2;
wire [4:0] ID_EX_Rd;
wire [31:0] EX_MEM_BranchAddOut;
wire [31:0] EX_MEM_PC;
wire [31:0] EX_MEM_IMM;
wire [31:0] EX_MEM_ALU_out;
wire [31:0] EX_MEM_RegR2;
wire [8:0] EX_MEM_Ctrl;
wire [4:0] EX_MEM_Rd;
wire [2:0] EX_MEM_Func;
wire EX_MEM_Zero;
wire [31:0] MEM_WB_Mem_out;
wire [31:0] MEM_WB_Imm_PC;
wire [31:0] MEM_WB_PC;
wire [31:0] MEM_WB_IMM;
wire [31:0] MEM_WB_ALU_out;
wire [5:0] MEM_WB_Ctrl;
wire [4:0] MEM_WB_Rd;
wire [1:0] ForwardA;
wire [1:0] ForwardB;
wire [31:0] ALUI1;
wire [31:0] ALUI2MUX;
wire [11:0] CUpicked;
wire [31:0] ID_EX_INST;
wire [31:0] EX_MEM_INST;
reg [13:0] ssd;
reg [19:0] refreshC = 0;
wire [1:0] LEDAcounter;
wire [31:0] ReadD1;
wire [31:0] ReadD2;
assign pickInst = (PCsrc) ? 32'd0 : dataOut; //MUX
Register #(64) regifid(~ssdClk, 1'b1, rst, {out_PC, pickInst}, {IF_ID_PC, IF_ID_Inst});
assign CUpicked = (PCsrc) ? 12'd0 : {JAL, JALR, LUI, AUIPC, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, ALUOp};//mux
Register #(191) regid_ed(ssdClk, 1'b1, rst, {CUpicked, IF_ID_Inst, IF_ID_PC, ReadD1, ReadD2, GenOut, {IF_ID_Inst[30], IF_ID_Inst[14:12]}, IF_ID_Inst[19:15], IF_ID_Inst[24:20], IF_ID_Inst[11:7]}, {ID_EX_Ctrl, ID_EX_INST, ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm, ID_EX_Func, ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd});

assign Muxed = (PCsrc) ? 9'd0 : {ID_EX_Ctrl[11:4], ID_EX_Ctrl[2]};//MUX
Register #(211) regexmem(~ssdClk, 1'b1, rst, {ID_EX_INST, ID_EX_Imm, ID_EX_PC, C, ID_EX_Func[2:0], Muxed, Imm_PC, ZeroF, ALU_out, ALUI2MUX, ID_EX_Rd}, {EX_MEM_INST, EX_MEM_IMM, EX_MEM_PC, EX_MEM_Carry, EX_MEM_Func, EX_MEM_Ctrl, EX_MEM_BranchAddOut, EX_MEM_Zero, EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_Rd});
Register #(172) regmemwb(ssdClk, 1'b1, rst, {EX_MEM_BranchAddOut, EX_MEM_IMM, EX_MEM_PC, {EX_MEM_Ctrl[8:5], EX_MEM_Ctrl[2], EX_MEM_Ctrl[0]}, dataOut, EX_MEM_ALU_out, EX_MEM_Rd}, {MEM_WB_Imm_PC, MEM_WB_IMM, MEM_WB_PC, MEM_WB_Ctrl, MEM_WB_Mem_out, MEM_WB_ALU_out, MEM_WB_Rd});

CU cuuuu(IF_ID_Inst[6:2], Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, ALUOp, JAL, JALR, LUI, AUIPC);
RF #(32) regfile( ssdClk, rst,IF_ID_Inst[19:15], IF_ID_Inst[24:20], MEM_WB_Rd, WritData, MEM_WB_Ctrl[0], ReadD1, ReadD2);

always @(ssdClk || rst) begin
    if (rst) begin
        in_PC <= 32'd0;
    end else if (!((EX_MEM_INST[6:0] == 7'b1110011) && (EX_MEM_INST[20] == 1'b1)))
        in_PC <= (out_gate || EX_MEM_Ctrl[8]) ? EX_MEM_BranchAddOut : (EX_MEM_Ctrl[7]) ? EX_MEM_ALU_out : new_PC;
end

Register #(32) regn(ssdClk, 1'b1, rst, in_PC, out_PC);
assign new_PC = out_PC + 4;
ImmGen immmgen(IF_ID_Inst,GenOut);
assign Imm_PC = ID_EX_PC + ID_EX_Imm;
assign ALUI2MUX = (ForwardB == 2'b00) ? ID_EX_RegR2 : (ForwardB == 2'b01) ? WritData : EX_MEM_ALU_out;//MUX
assign ALUI2 = (ID_EX_Ctrl[3]) ? ID_EX_Imm : ALUI2MUX; //MUX
ALUCU alucu(ID_EX_Func[2:0], ID_EX_Func[3], ID_EX_Ctrl[1:0], ALUsel);

assign ALUI1 = (ForwardA == 2'b00) ? ID_EX_RegR1 : (ForwardA == 2'b01) ? WritData : EX_MEM_ALU_out;//mux
ALUN #(32) alu(ALUI1, ALUI2, ALUsel, ALU_out, ZeroF, N, V, C);

always @(*) begin
    if (EX_MEM_Ctrl[4]) begin
        case (EX_MEM_Func)
            3'b000: out_gate = EX_MEM_Zero;
            3'b001: out_gate = ~EX_MEM_Zero;
            3'b100: out_gate = ~((~EX_MEM_Carry) + EX_MEM_Zero);
            3'b101: out_gate = (~EX_MEM_Carry) + EX_MEM_Zero;
            3'b110: out_gate = ~EX_MEM_Carry;
            3'b111: out_gate = EX_MEM_Carry;
        endcase
    end else
        out_gate = 1'b0;
end

assign PCsrc = out_gate || EX_MEM_Ctrl[8] || EX_MEM_Ctrl[7];
ForwardingUnit forwardu(
    ID_EX_Rs1,
    ID_EX_Rs2,
    EX_MEM_Rd,
    MEM_WB_Rd,
    EX_MEM_Ctrl[0],
    MEM_WB_Ctrl[0],
    ForwardA,
    ForwardB
);

Mem mem(
    ssdClk,
    EX_MEM_Ctrl[3],
    EX_MEM_Ctrl[1],
    EX_MEM_Func,
    {EX_MEM_ALU_out[6:0], out_PC[6:0]},
    EX_MEM_RegR2,
    dataOut
);

assign WritData = (MEM_WB_Ctrl[1]) ? MEM_WB_Mem_out :
                  (MEM_WB_Ctrl[5] || MEM_WB_Ctrl[4]) ? (MEM_WB_PC + 4) :
                  (MEM_WB_Ctrl[3]) ? MEM_WB_IMM :
                  (MEM_WB_Ctrl[2]) ? (MEM_WB_PC + MEM_WB_IMM) :
                  MEM_WB_ALU_out;

assign Signs = {2'b00, ALUOp, ALUsel, ZeroF, out_gate, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite};

always @(*) begin
    case (ledsel)
        2'b00: leds = Inst_OUT[15:0];
        2'b01: leds = Inst_OUT[31:16];
        2'b10: leds = Signs;
    endcase
end


always @(posedge ssdClk) begin
    refreshC <= refreshC + 1;
end

assign LEDAcounter = refreshC[19:18];

always @(*) begin
    case (LEDAcounter)
        2'b00: begin
            Anode = 4'b0111;
            LEDbcd = ssd / 1000;
        end
        2'b01: begin
            Anode = 4'b1011;
            LEDbcd = (ssd % 1000) / 100;
        end
        2'b10: begin
            Anode = 4'b1101;
            LEDbcd = ((ssd % 1000) % 100) / 10;
        end
        2'b11: begin
            Anode = 4'b1110;
            LEDbcd = ((ssd % 1000) % 100) % 10;
        end
    endcase
end
always @(*)
begin
case(LEDbcd)
4'b0000: LED_out = 7'b0000001; // "0"
4'b0001: LED_out = 7'b1001111; // "1"
4'b0010: LED_out = 7'b0010010; // "2"
4'b0011: LED_out = 7'b0000110; // "3"
4'b0100: LED_out = 7'b1001100; // "4"
4'b0101: LED_out = 7'b0100100; // "5"
4'b0110: LED_out = 7'b0100000; // "6"
4'b0111: LED_out = 7'b0001111; // "7"
4'b1000: LED_out = 7'b0000000; // "8"
4'b1001: LED_out = 7'b0000100; // "9"
default: LED_out = 7'b0000001; // "0"
endcase
end

always @(*) begin
    case (ssdSel)
        4'b0000: ssd <= out_PC;
        4'b0001: ssd <= new_PC;
        4'b0010: ssd <= Imm_PC;
        4'b0011: ssd <= in_PC;
        4'b0100: ssd <= ReadD1;
        4'b0101: ssd <= ReadD2;
        4'b0110: ssd <= WritData;
        4'b0111: ssd <= GenOut;
        4'b1000: ssd <= {GenOut[30:0], 1'b0};
        4'b1001: ssd <= ALUI2;
        4'b1010: ssd <= ALU_out;
        4'b1011: ssd <= dataOut;
    endcase
end


endmodule
