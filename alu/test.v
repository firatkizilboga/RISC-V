`timescale 1ns / 1ps
`include "alu/alu.v"
module ALUTest;

    // Inputs
    reg [2:0] opcode;
    reg [31:0] op_0;
    reg [31:0] op_1;

    // Outputs
    wire [31:0] out;
    wire ZERO;
    wire NEGATIVE;

    // Instantiate the ALU module
    ALU uut (
        .opcode(opcode), 
        .op_0(op_0), 
        .op_1(op_1), 
        .out(out), 
        .ZERO(ZERO), 
        .NEGATIVE(NEGATIVE)
    );

    initial begin
        // Test ADD operation
        opcode = `ALU_OPERATION_ADD; // ADD
        op_0 = 32'd15;
        op_1 = 32'd10;
        #10; // Wait for the operation to complete
        $display("ADD Test: %d + %d = %d", op_0, op_1, out);
        $display("flags, ZERO=%d, NEGATIVE = %d", ZERO, NEGATIVE);


        // Test SUB operation
        opcode = `ALU_OPERATION_SUB; // SUB
        op_0 = 32'd20;
        op_1 = 32'd5;
        #10;
        $display("SUB Test: %d - %d = %d", op_0, op_1, out);
        $display("flags, ZERO=%d, NEGATIVE = %d", ZERO, NEGATIVE);

        opcode = `ALU_OPERATION_SUB; // SUB
        op_0 = 32'd5;
        op_1 = 32'd20;
        #10;
        $display("SUB Test: %d - %d = %d", op_0, op_1, $signed(out));
        $display("flags, ZERO=%d, NEGATIVE = %d", ZERO, NEGATIVE);

        // Test AND operation
        opcode = `ALU_OPERATION_AND; // AND
        op_0 = 32'b10101010;
        op_1 = 32'b11001100;
        #10;
        $display("AND Test: %b & %b = %b", op_0, op_1, out);
        $display("flags, ZERO=%d, NEGATIVE = %d", ZERO, NEGATIVE);

        // Test OR operation
        opcode = `ALU_OPERATION_OR; // OR
        op_0 = 32'b10101010;
        op_1 = 32'b11001100;
        #10;
        $display("OR Test: %b | %b = %b", op_0, op_1, out);
        $display("flags, ZERO=%d, NEGATIVE = %d", ZERO, NEGATIVE);

        // Test XOR operation
        opcode = `ALU_OPERATION_XOR; // XOR
        op_0 = 32'b10101010;
        op_1 = 32'b11001100;
        #10;
        $display("XOR Test: %b ^ %b = %b", op_0, op_1, out);
        $display("flags, ZERO=%d, NEGATIVE = %d", ZERO, NEGATIVE);

        // Test SLL operation
        opcode = `ALU_OPERATION_SLL; // SLL
        op_0 = 32'd15;
        op_1 = 32'h4; // Shift by 4
        #10;
        $display("SLL Test: %d << %h = %d", op_0, op_1[4:0], out);
        $display("flags, ZERO=%d, NEGATIVE = %d", ZERO, NEGATIVE);

        // Test SRL operation
        opcode = `ALU_OPERATION_SRL; // SRL
        op_0 = 32'd120;
        op_1 = 32'h3; // Shift by 3
        #10;
        $display("SRL Test (Unsigned): %d >> %h = %d", op_0, op_1[4:0], out);
        $display("flags, ZERO=%d, NEGATIVE = %d", ZERO, NEGATIVE);

        // Test SRA operation
        opcode = `ALU_OPERATION_SRA; // SRA
        op_0 = -32'd120;
        op_1 = 32'h3; // Shift by 3
        #10;
        $display("SRA Test (Signed): %b >>> %b = %b", op_0, op_1[4:0], out);
        $display("flags, ZERO=%d, NEGATIVE = %d", ZERO, NEGATIVE);

        #10;
        $display("SRA Test (Signed): %b >>> %b = %b", op_0, op_1[4:0], out);
        $display("flags, ZERO=%d, NEGATIVE = %d", ZERO, NEGATIVE);
        $finish;
    end

endmodule
