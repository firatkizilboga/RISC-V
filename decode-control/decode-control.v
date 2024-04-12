`ifndef ALU_OPERATION_ADD
`include "alu/alu.v"
`endif

`define R_TYPE 7'b0110011
`define I_TYPE 7'b0010011
`define J_TYPE 7'b1101111
`define JALR_TYPE 7'b1100111
`define U_TYPE 7'b0110111
`define B_TYPE 7'b1100011
`define S_TYPE 7'b0100011
`define LOAD_TYPE 7'b0000011
`define LUI_TYPE 7'b0110111
`define AUIPC_TYPE 7'b0010111


module DecodeControl (
    input wire        clock,
    input wire [31:0] instruction,
    input wire [31:0] REG_1,
    input wire [31:0] REG_2,

    output wire PC_IN_MUX_SEL,

    output wire       ALU_OP_1_MUX_SEL,
    output wire       ALU_OP_2_MUX_SEL,
    output wire [2:0] ALU_OPCODE,

    output wire RF_WR_EN,
    output wire RF_SET,
    output wire RF_RESET,

    output wire [1:0] RF_DATA_IN_MUX_SEL,

    output wire DATA_MEMORY_WR_EN,
    output wire [1:0] DATA_MEMORY_SIZE_SEL,
    output wire DATA_MEMORY_SIGN_EXTEND,

    output wire [31:0] immediate,

    output wire [4:0] RF_SEL_1,
    output wire [4:0] RF_SEL_2,
    output wire [4:0] RF_SEL_RD,
    output wire       branch_taken,
    output wire [6:0] OPERATION
);

  assign OPERATION = instruction[6:0];

  assign R_TYPE = (instruction[6:0] == `R_TYPE);
  assign I_TYPE = (instruction[6:0] == `I_TYPE);
  assign J_TYPE = (instruction[6:0] == `J_TYPE);
  assign U_TYPE = (instruction[6:0] == `U_TYPE);
  assign B_TYPE = (instruction[6:0] == `B_TYPE);
  assign S_TYPE = (instruction[6:0] == `S_TYPE);
  assign LOAD_TYPE = (instruction[6:0] == `LOAD_TYPE);
  assign LUI_TYPE = (instruction[6:0] == `LUI_TYPE);
  assign AUIPC_TYPE = (instruction[6:0] == `AUIPC_TYPE);


  wire [2:0] func3;
  assign func3 = instruction[14:12];
  assign JALR_TYPE = (instruction[6:0] == `JALR_TYPE && func3 == 3'h0);

  wire [6:0] R_func7, R_rd, R_rs1, R_rs2;
  assign R_func7 = instruction[31:25];
  assign R_rd    = instruction[11:7];
  assign R_rs1   = instruction[19:15];
  assign R_rs2   = instruction[24:20];

  wire [4:0] I_rd, I_rs1, I_rs2;
  wire [11:0] I_imm;
  assign I_rd  = instruction[11:7];
  assign I_rs1 = instruction[19:15];
  assign I_imm = instruction[31:20];

  wire [4:0] B_rs1, B_rs2;
  assign B_rs1 = instruction[19:15];
  assign B_rs2 = instruction[24:20];

  //compute the related alu opcode
  // func3 & func7 -> alu opcode (R_TYPE && `ALU_OPERATION_XXX)
  // 0x0 & 0x0 -> add
  // 0x0 & 0x20 -> sub
  // 0x1 & 0x0 -> sll
  // 0x2 & 0x0 -> slt
  // 0x3 & 0x0 -> sltu
  // 0x4 & 0x0 -> xor
  // 0x5 & 0x0 -> srl
  // 0x5 & 0x20 -> sra
  // 0x6 & 0x0 -> or
  // 0x7 & 0x0 -> and
  assign ALU_OPCODE =   (R_TYPE && func3 == 3'h0 && R_func7 == 7'h0) ? `ALU_OPERATION_ADD :
                        (R_TYPE && func3 == 3'h0 && R_func7 == 7'h20) ? `ALU_OPERATION_SUB :
                        (R_TYPE && func3 == 3'h1 && R_func7 == 7'h0) ? `ALU_OPERATION_SLL :
                        (R_TYPE && func3 == 3'h4 && R_func7 == 7'h0) ? `ALU_OPERATION_XOR :
                        (R_TYPE && func3 == 3'h5 && R_func7 == 7'h0) ? `ALU_OPERATION_SRL :
                        (R_TYPE && func3 == 3'h5 && R_func7 == 7'h20) ? `ALU_OPERATION_SRA :
                        (R_TYPE && func3 == 3'h6 && R_func7 == 7'h0) ? `ALU_OPERATION_OR :
                        (R_TYPE && func3 == 3'h7 && R_func7 == 7'h0) ? `ALU_OPERATION_AND :
                        (I_TYPE && func3 == 3'h0) ? `ALU_OPERATION_ADD :
                        (I_TYPE && func3 == 3'h1 && I_imm[11: 5] == 7'h0) ? `ALU_OPERATION_SLL :
                        (I_TYPE && func3 == 3'h4) ? `ALU_OPERATION_XOR :
                        (I_TYPE && func3 == 3'h5  && I_imm[11: 5] == 7'h0) ? `ALU_OPERATION_SRL :
                        (I_TYPE && func3 == 3'h5  && I_imm[11: 5] == 7'h20) ? `ALU_OPERATION_SRA :
                        (I_TYPE && func3 == 3'h6) ? `ALU_OPERATION_OR :
                        (I_TYPE && func3 == 3'h7) ? `ALU_OPERATION_AND :
                        (LOAD_TYPE) ? `ALU_OPERATION_ADD :
                        (J_TYPE || JALR_TYPE) ? `ALU_OPERATION_ADD :
                        (S_TYPE) ? `ALU_OPERATION_ADD: 3'b0;

  assign ALU_OP_1_MUX_SEL = (R_TYPE) ? 1'b1 :
                            (I_TYPE) ? 1'b1 :
                            (LOAD_TYPE) ? 1'b1 :
                            (J_TYPE) ? 1'b0 :
                            (JALR_TYPE) ? 1'b1 :
                            (B_TYPE) ? 1'b0 :
                            (LUI_TYPE) ? 1'b1 :
                            (AUIPC_TYPE) ? 1'b0 :
                            (S_TYPE) ? 1'b1 : 1'b0;


  assign ALU_OP_2_MUX_SEL = (R_TYPE) ? 1'b0 :
                            (I_TYPE) ? 1'b1 :
                            (LOAD_TYPE) ? 1'b1 :
                            (J_TYPE) ? 1'b1 :
                            (JALR_TYPE) ? 1'b1 :
                            (B_TYPE) ? 1'b1 :
                            (LUI_TYPE) ? 1'b1 :
                            (AUIPC_TYPE) ? 1'b1 :
                            (S_TYPE) ? 1'b1: 1'b0;

  assign DATA_MEMORY_WR_EN = (S_TYPE) ? 1'b1 : 1'b0;

  // func3 -> data memory size
  // 0x0 -> byte
  // 0x1 -> half word
  // 0x2 -> word
  // 0x4 -> byte (Unsigned)
  // 0x5 -> half word (Unsigned)

  assign DATA_MEMORY_SIZE_SEL = ((LOAD_TYPE || S_TYPE) && func3 == 3'h0) ? 2'd0 :
                                ((LOAD_TYPE || S_TYPE) && func3 == 3'h1) ? 2'd1 :
                                ((LOAD_TYPE || S_TYPE) && func3 == 3'h2) ? 2'd3 :
                                (LOAD_TYPE && func3 == 3'h4) ? 2'd0 :
                                (LOAD_TYPE && func3 == 3'h5) ? 2'd1 : 2'd3;

  assign DATA_MEMORY_SIGN_EXTEND = (LOAD_TYPE && func3 == 3'h4) ? 1'b1 :
                                   (LOAD_TYPE && func3 == 3'h5) ? 1'b1 :
                                   (S_TYPE) ? 1'b1 : 1'b0;

  assign immediate =
    (I_TYPE || LOAD_TYPE || JALR_TYPE) ? { {20{instruction[31]}}, instruction[31:20] } :
    (S_TYPE) ? { {20{instruction[31]}}, instruction[31:25], instruction[11:7] } :

    (B_TYPE && (func3 != 7'h6) && (func3 != 7'h7)) ? 
        { {19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0 } :

    (B_TYPE && ((func3 == 7'h6) || (func3 == 7'h7))) ?
        { {19{1'b0}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0 } :

    (LUI_TYPE || AUIPC_TYPE) ? { instruction[31:12], 12'b0 } :

    (J_TYPE) ? { {11{instruction[31]}}, instruction[31], instruction[19:12],
                 instruction[20], instruction[30:21], 1'b0 } :
    32'b0;

  assign RF_SEL_1 = (R_TYPE || S_TYPE) ? R_rs1 :
                    (I_TYPE || LOAD_TYPE || JALR_TYPE) ? I_rs1 :
                    (B_TYPE) ? B_rs1 :
                    (LUI_TYPE) ? 5'b0 : 5'b0;

  assign RF_SEL_2 = (R_TYPE || S_TYPE) ? R_rs2 : (I_TYPE || LOAD_TYPE) ? 5'b0 : (B_TYPE) ? B_rs2 : 5'b0;

  assign RF_SEL_RD = (R_TYPE) ? R_rd : (I_TYPE || LOAD_TYPE || J_TYPE || JALR_TYPE || LUI_TYPE || AUIPC_TYPE) ? I_rd : 5'b0;

  assign RF_WR_EN = (R_TYPE && func3 != 7'h2 && func3 != 7'h3) ? 1'b1 :
                    ((I_TYPE && func3 !=7'h2 && func3 != 7'h3)) ||
                    (LOAD_TYPE || J_TYPE || JALR_TYPE) ? 1'b1 :
                    (LUI_TYPE || AUIPC_TYPE) ? 1'b1 : 1'b0;

  assign SLT_CONDITION = ($signed(REG_1) < $signed(REG_2)) ? 1'b1 : 1'b0;
  assign SLT_CONDITION_U = (REG_1 < REG_2) ? 1'b1 : 1'b0;

  assign SLTI_CONDITION = ($signed(REG_1) < $signed(immediate)) ? 1'b1 : 1'b0;
  assign SLTI_CONDITION_U = (REG_1 < immediate) ? 1'b1 : 1'b0;

  assign RF_SET =   (R_TYPE && ((func3 == 7'h2 && SLT_CONDITION) ||
                    ((func3 == 7'h3 && SLT_CONDITION_U)))) ||
                    (I_TYPE && ((func3 == 7'h2 && SLTI_CONDITION) ||
                    ((func3 == 7'h3 && SLTI_CONDITION_U)))) ? 1'b1 : 1'b0;

  assign RF_RESET = (R_TYPE && ((func3 == 7'h2 && ~SLT_CONDITION) ||
                    ((func3 == 7'h3 && ~SLT_CONDITION_U)))) ||
                    (I_TYPE && ((func3 == 7'h2 && ~SLTI_CONDITION) ||
                    ((func3 == 7'h3 && ~SLTI_CONDITION_U)))) ? 1'b1 : 1'b0;

  assign RF_DATA_IN_MUX_SEL =   (R_TYPE) ? 2'b01 :
                                (I_TYPE) ? 2'b01 :
                                (LOAD_TYPE) ? 2'b10 :
                                (J_TYPE || JALR_TYPE) ? 2'b00 :
                                (B_TYPE) ? 2'b01 :
                                (LUI_TYPE || AUIPC_TYPE) ? 2'b01 : 2'b00;
  BranchControl BC (
      .reg_1(REG_1),
      .reg_2(REG_2),
      .func3(func3)
  );

  assign branch_taken  = B_TYPE & BC.branch_taken;

  assign PC_IN_MUX_SEL = (J_TYPE || JALR_TYPE || branch_taken) ? 1'b1 : 1'b0;

  always @(instruction) begin
    #4;
    $display("Instruction: 0b%b", instruction);
    $display("Func3: 0x%h", func3);
    $display("Types");
    $display("R_TYPE: %b", R_TYPE);
    $display("I_TYPE: %b", I_TYPE);
    $display("J_TYPE: %b", J_TYPE);
    $display("U_TYPE: %b", U_TYPE);
    $display("LOAD TYPE: %b", LOAD_TYPE);
    $display("JALR TYPE: %b", JALR_TYPE);
    $display("B_TYPE: %b", B_TYPE);
    $display("S_TYPE: %b", S_TYPE);
    $display("LUI_TYPE: %b", LUI_TYPE);
    $display("AUIPC_TYPE: %b", AUIPC_TYPE);
  end

endmodule

module BranchControl (
    input wire [31:0] reg_1,
    input wire [31:0] reg_2,
    input wire [ 2:0] func3,

    output wire branch_taken
);

  assign branch_taken = (func3 == 3'h0 && reg_1 == reg_2) ? 1'b1 :
                        (func3 == 3'h1 && reg_1 != reg_2) ? 1'b1 :
                        (func3 == 3'h4 && $signed(
      reg_1
  ) < $signed(
      reg_2
  )) ? 1'b1 : (func3 == 3'h5 && $signed(
      reg_1
  ) >= $signed(
      reg_2
  )) ? 1'b1 : (func3 == 3'h6 && reg_1 < reg_2) ?
      1'b1 : (func3 == 3'h7 && reg_1 >= reg_2) ? 1'b1 : 1'b0;
endmodule
