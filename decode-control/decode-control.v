`ifndef ALU_OPERATION_ADD
`include "alu/alu.v"
`endif

`define R_TYPE 7'b0110011
`define I_TYPE 7'b0010011
`define J_TYPE 7'b1101111
`define U_TYPE 7'b0110111
`define B_TYPE 7'b1100011
`define S_TYPE 7'b0100011

module DecodeControl (
input wire clock,
    input   wire    [31:0]                              instruction ,

    output  wire                                         PC_IN_MUX_SEL   ,

    output  wire                                         ALU_OP_1_MUX_SEL    ,
    output  wire                                         ALU_OP_2_MUX_SEL    ,
    output  wire     [2:0]                               ALU_OPCODE  ,

    output  wire                                         RF_WR_EN    ,
    output  wire     [1:0]                               RF_DATA_IN_MUX_SEL  ,

    output  wire                                         DATA_MEMORY_WR_EN   ,
    output  wire     [31:0]                              immediate   ,

    output  wire     [4:0]                               RF_SEL_1    ,
    output  wire     [4:0]                               RF_SEL_2    ,
    output  wire     [4:0]                               RF_SEL_RD   ,

    output  wire                                         branch_taken    ,
    output  wire     [6:0]                               OPERATION  

    );	

	assign OPERATION = instruction[6:0];
	
	assign R_TYPE = (instruction[6:0] == `R_TYPE);
	assign I_TYPE = (instruction[6:0] == `I_TYPE);
	assign J_TYPE = (instruction[6:0] == `J_TYPE);
	assign U_TYPE = (instruction[6:0] == `U_TYPE);
	assign B_TYPE = (instruction[6:0] == `B_TYPE);
	assign S_TYPE = (instruction[6:0] == `S_TYPE);

	assign func3  = instruction[14:12];
	
	wire [6:0] R_func7, R_rd, R_rs1, R_rs2;
	assign R_func7  = instruction[31:25];
	assign R_rd     = instruction[11:7];
	assign R_rs1    = instruction[19:15];
	assign R_rs2    = instruction[24:20];

	wire [4:0] I_rd, I_rs1, I_rs2;
	wire [11:0] I_imm;
	assign I_rd     = instruction[11:7];
	assign I_rs1    = instruction[19:15];
	assign I_imm    = instruction[31:20];

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
	assign ALU_OPCODE =			(R_TYPE && func3 == 3'h0 && R_func7 == 7'h0) ? `ALU_OPERATION_ADD :
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
						(I_TYPE && func3 == 3'h7) ? `ALU_OPERATION_AND : 3'b0;
	
	assign ALU_OP_1_MUX_SEL =	(R_TYPE) ? 1'b1 :
					(I_TYPE) ? 1'b1 : 1'b0;

	assign ALU_OP_2_MUX_SEL =	(R_TYPE) ? 1'b0 :
					(I_TYPE) ? 1'b1: 1'b0;
	
	
	assign DATA_MEMORY_WR_EN =	(S_TYPE) ? 1'b1 : 1'b0;

	assign immediate =	(I_TYPE) ? { {20{instruction[31]}}, instruction[31:20] } :
				(S_TYPE) ? { {20{instruction[31]}}, instruction[31:25], instruction[11:7] } :
				(B_TYPE) ? { {19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0 } :
				(U_TYPE) ? { {12{instruction[31]}}, instruction[31:12] } :
				(J_TYPE) ? { {11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0 } : 32'b0;
	
	assign RF_SEL_1 =	(R_TYPE) ? R_rs1 :
				(I_TYPE) ? I_rs1 : 5'b0;
	
	assign RF_SEL_2 =	(R_TYPE) ? R_rs2 :
				(I_TYPE) ? 5'b0 : 5'b0;

	assign RF_SEL_RD =	(R_TYPE) ? R_rd :
				(I_TYPE) ? I_rd : 5'b0;
	
	assign RF_WR_EN =	(R_TYPE) ? 1'b1 : 
				(I_TYPE) ? 1'b1 : 1'b0;
	
	assign RF_DATA_IN_MUX_SEL =	(R_TYPE) ? 2'b01 :
					(I_TYPE) ? 2'b01 : 2'b00;
	
	assign branch_taken =	(B_TYPE) ? 1'b1 : 1'b0;

	assign PC_IN_MUX_SEL =	(J_TYPE) ? 1'b1 : 1'b0;


endmodule












