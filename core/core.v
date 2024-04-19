`include "mux/mux.v"
`include "register/register.v"
`include "registers/registers.v"
`include "memory/memory.v"
`include "decode-control/decode-control.v"

module CORE (
	input wire clock
);
  wire [31:0] ALU_32__out;
  wire [31:0] ALU_OP_1_MUX__out;
  wire [31:0] ALU_OP_2_MUX__out;
  wire [2:0] DCU__ALU_OPCODE;
  wire DCU__ALU_OP_1_MUX_SEL;
  wire DCU__ALU_OP_2_MUX_SEL;
  wire DCU__DATA_MEMORY_SIGN_EXTEND;
  wire [1:0] DCU__DATA_MEMORY_SIZE_SEL;
  wire DCU__DATA_MEMORY_WR_EN;
  wire DCU__PC_IN_MUX_SEL;
  wire [1:0] DCU__RF_DATA_IN_MUX_SEL;
  wire DCU__RF_RESET;
  wire [4:0] DCU__RF_SEL_1;
  wire [4:0] DCU__RF_SEL_2;
  wire [4:0] DCU__RF_SEL_RD;
  wire DCU__RF_SET;
  wire DCU__RF_WR_EN;
  wire [31:0] DCU__immediate;
  wire [31:0] DM__data_out;
  wire [31:0] IM__data_out;
  wire [31:0] PCNext__out;
  wire [31:0] PC_IN_MUX__out;
  wire PC__out;
  wire [31:0] RF_DATA_IN_MUX__out;
  wire [31:0] RF__reg_1;
  wire [31:0] RF__reg_2;

  MUX_2IN_32DATA PC_IN_MUX (
      .in_0  (PCNext__out),
      .in_1  (ALU_32__out),
      .select(DCU__PC_IN_MUX_SEL),
      .out   (PC_IN_MUX__out)
  );

  Register PC (
      .clock(clock),
      .in   (PC_IN_MUX__out),
      .out  (PC__out)
  );

  PCINC PCNext (
      .clock(clock),
      .PC   (PC__out),
      .out  (PCNext__out)
  );

  INSTRUCTION_MEMORY IM (
      .clock   (clock),
      .addr    (PC__out),
      .data_out(IM__data_out)
  );

  DecodeControl DCU (
      .clock(clock),
      .instruction(IM__data_out),
      .REG_1(RF__reg_1),
      .REG_2(RF__reg_2),
      .PC_IN_MUX_SEL(DCU__PC_IN_MUX_SEL),
      .ALU_OP_1_MUX_SEL(DCU__ALU_OP_1_MUX_SEL),
      .ALU_OP_2_MUX_SEL(DCU__ALU_OP_2_MUX_SEL),
      .ALU_OPCODE(DCU__ALU_OPCODE),
      .RF_WR_EN(DCU__RF_WR_EN),
      .RF_SET(DCU__RF_SET),
      .RF_RESET(DCU__RF_RESET),
      .RF_DATA_IN_MUX_SEL(DCU__RF_DATA_IN_MUX_SEL),
      .DATA_MEMORY_WR_EN(DCU__DATA_MEMORY_WR_EN),
      .DATA_MEMORY_SIZE_SEL(DCU__DATA_MEMORY_SIZE_SEL),
      .DATA_MEMORY_SIGN_EXTEND(DCU__DATA_MEMORY_SIGN_EXTEND),
      .immediate(DCU__immediate),
      .RF_SEL_1(DCU__RF_SEL_1),
      .RF_SEL_2(DCU__RF_SEL_2),
      .RF_SEL_RD(DCU__RF_SEL_RD)
  );

  Registers RF (
      .clock(clock),
      .WR_EN(DCU__RF_WR_EN),
      .SET(DCU__RF_SET),
      .RESET(DCU__RF_RESET),
      .reg_1_select(DCU__RF_SEL_1),
      .reg_2_select(DCU__RF_SEL_2),
      .data_in(RF_DATA_IN_MUX__out),
      .write_select(DCU__RF_SEL_RD),
      .reg_1(RF__reg_1),
      .reg_2(RF__reg_2)
  );

  MUX_2IN_32DATA ALU_OP_1_MUX (
      .in_0  (PC__out),
      .in_1  (RF__reg_1),
      .select(DCU__ALU_OP_1_MUX_SEL),
      .out   (ALU_OP_1_MUX__out)
  );

  MUX_2IN_32DATA ALU_OP_2_MUX (
      .in_0  (RF__reg_2),
      .in_1  (DCU__immediate),
      .select(DCU__ALU_OP_2_MUX_SEL),
      .out   (ALU_OP_2_MUX__out)
  );

  ALU ALU_32 (
      .clock (clock),
      .opcode(DCU__ALU_OPCODE),
      .op_0  (ALU_OP_1_MUX__out),
      .op_1  (ALU_OP_2_MUX__out),
      .out   (ALU_32__out)
  );

  DATA_MEMORY DM (
      .clock      (clock),
      .addr       (ALU_32__out),
      .data_in    (RF__reg_2),
      .we         (DCU__DATA_MEMORY_WR_EN),
      .size       (DCU__DATA_MEMORY_SIZE_SEL),
      .sign_extend(DCU__DATA_MEMORY_SIGN_EXTEND),
      .data_out   (DM__data_out)
  );

  MUX_3IN_32DATA RF_DATA_IN_MUX (
      .in_0  (PCNext__out),             //PC+4
      .in_1  (ALU_32__out),
      .in_2  (DM__data_out),
      .select(DCU__RF_DATA_IN_MUX_SEL),
      .out(RF_DATA_IN_MUX__out)
  );

  always @(posedge clock) begin
    $display("############################");
    $display("Time: %d, Clock: %b", $time, clock);

    // Displaying outputs of PC_IN_MUX
    $display("PC_IN_MUX.out: %h", PC_IN_MUX__out);

    // Displaying outputs of PC (Program Counter)
    $display("PC.out: %h", PC__out);

    // Displaying outputs of PCNext (PC Increment)
    $display("PCNext.out: %h", PCNext__out);
    $display("PCNext.PC: %h", PCNext__PC);

    // Displaying outputs of Instruction Memory
    $display("IM.data_out: 0x%h", IM__data_out);

    // Displaying control signals from DecodeControl Unit (DCU)
    $display("DCU.PC_IN_MUX_SEL: %b", DCU__PC_IN_MUX_SEL);
    $display("DCU.RF_WR_EN: %b", DCU__RF_WR_EN);
    $display("DCU.RF_SEL_1: %h", DCU__RF_SEL_1);
    $display("DCU.RF_SEL_2: %h", DCU__RF_SEL_2);
    $display("DCU.RF_SEL_RD: %h", DCU__RF_SEL_RD);
    $display("DCU.RF_DATA_IN_MUX_SEL: %h", DCU__RF_DATA_IN_MUX_SEL);
    $display("DCU.ALU_OP_1_MUX_SEL: %b", DCU__ALU_OP_1_MUX_SEL);
    $display("DCU.ALU_OP_2_MUX_SEL: %b", DCU__ALU_OP_2_MUX_SEL);
    $display("DCU.ALU_OPCODE: %h", DCU__ALU_OPCODE);
    $display("DCU.immediate: 0x%h", DCU__immediate);
    $display("DCU.DATA_MEMORY_WR_EN: %b", DCU__DATA_MEMORY_WR_EN);
    $display("DCU.DATA_MEMORY_SIZE_SEL: %h", DCU__DATA_MEMORY_SIZE_SEL);
    $display("DCU.DATA_MEMORY_SIGN_EXTEND: %b", DCU__DATA_MEMORY_SIGN_EXTEND);

    // Add any additional DCU signals here

    // Displaying Register File outputs
    $display("RF.reg_1: %h, RF.reg_2: %h", RF__reg_1, RF__reg_2);

    // Displaying outputs of ALU Operand Muxes
    $display("ALU_OP_1_MUX.out: %h", ALU_OP_1_MUX__out);
    $display("ALU_OP_2_MUX.out: %h", ALU_OP_2_MUX__out);

    // Displaying output of ALU
    $display("ALU_32.out: %h", ALU_32__out);

    // Displaying Data Memory outputs
    $display("DM.data_out: %h", DM__data_out);

    // Displaying output of RF Data In Mux

    $display("RF_DATA_IN_MUX.out: %h", RF_DATA_IN_MUX__out);
  end

endmodule
