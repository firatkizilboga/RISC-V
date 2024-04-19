`ifndef ALU
`define ALU

`define ALU_OPERATION_ADD 3'b000
`define ALU_OPERATION_SUB 3'b001
`define ALU_OPERATION_AND 3'b010
`define ALU_OPERATION_OR 3'b011
`define ALU_OPERATION_XOR 3'b100
`define ALU_OPERATION_SLL 3'b101
`define ALU_OPERATION_SRL 3'b110
`define ALU_OPERATION_SRA 3'b111

module PCINC (
    input wire clock,
    input wire [31:0] PC,
    output reg [31:0] out
);

  always @(negedge clock) begin
    out = PC + 32'd4;
  end

endmodule
module ALU (
    input  wire        clock,
    input  wire [ 2:0] opcode,
    input  wire [31:0] op_0,
    input  wire [31:0] op_1,
    output reg  [31:0] out,
    output reg         ZERO,
    output reg         NEGATIVE
);


  initial begin
    ZERO    = 1;
    NEGATIVE    = 0;
  end

  always @(posedge clock) begin

    case (opcode)
      `ALU_OPERATION_ADD: out = op_0 + op_1;
      `ALU_OPERATION_SUB: out = op_0 - op_1;
      `ALU_OPERATION_AND: out = op_0 & op_1;
      `ALU_OPERATION_OR:  out = op_0 | op_1;
      `ALU_OPERATION_XOR: out = op_0 ^ op_1;
      `ALU_OPERATION_SLL: out = op_0 << op_1[4:0];
      `ALU_OPERATION_SRL: out = op_0 >> op_1[4:0];
      `ALU_OPERATION_SRA: out = ($signed(op_0)) >>> op_1[4:0];
      default:            out = 0;
    endcase


    if (out == 0) begin
      ZERO <= 1;
    end else begin
      ZERO <= 0;
    end

    if (out[31] == 1) begin
      NEGATIVE <= 1;
    end else begin
      NEGATIVE <= 0;
    end

    $display("out: 0x%h zero: %b op_1: %b", out, ZERO, NEGATIVE);

  end


endmodule
`endif
