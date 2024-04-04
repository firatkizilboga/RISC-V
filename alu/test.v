`timescale 1ns / 1ps
`include "alu/alu.v"
module ALUTest;

    // Inputs
    reg [2:0] opcode;
    reg [31:0] in_0;
    reg [31:0] in_1;

    // Outputs
    wire [31:0] out;
    wire ZERO;
    wire NEGATIVE;

    // Instantiate the ALU module
    ALU uut (
        .opcode(opcode), 
        .in_0(in_0), 
        .in_1(in_1), 
        .out(out), 
        .ZERO(ZERO), 
        .NEGATIVE(NEGATIVE)
    );

    initial begin
        // Test ADD operation
        opcode = `ALU_OPERATION_ADD; // ADD
        in_0 = 32'd15;
        in_1 = 32'd10;
        #10; // Wait for the operation to complete
        $display("ADD Test: %d + %d = %d", in_0, in_1, out);
        $display("flags, ZERO=%d, NEGATIVE = %d", ZERO, NEGATIVE);


        // Test SUB operation
        opcode = `ALU_OPERATION_SUB; // SUB
        in_0 = 32'd20;
        in_1 = 32'd5;
        #10;
        $display("SUB Test: %d - %d = %d", in_0, in_1, out);
        $display("flags, ZERO=%d, NEGATIVE = %d", ZERO, NEGATIVE);

        opcode = `ALU_OPERATION_SUB; // SUB
        in_0 = 32'd5;
        in_1 = 32'd20;
        #10;
        $display("SUB Test: %d - %d = %d", in_0, in_1, $signed(out));
        $display("flags, ZERO=%d, NEGATIVE = %d", ZERO, NEGATIVE);

        // Test AND operation
        opcode = `ALU_OPERATION_AND; // AND
        in_0 = 32'b10101010;
        in_1 = 32'b11001100;
        #10;
        $display("AND Test: %b & %b = %b", in_0, in_1, out);
        $display("flags, ZERO=%d, NEGATIVE = %d", ZERO, NEGATIVE);

        // Test OR operation
        opcode = `ALU_OPERATION_OR; // OR
        in_0 = 32'b10101010;
        in_1 = 32'b11001100;
        #10;
        $display("OR Test: %b | %b = %b", in_0, in_1, out);
        $display("flags, ZERO=%d, NEGATIVE = %d", ZERO, NEGATIVE);

        // Test XOR operation
        opcode = `ALU_OPERATION_XOR; // XOR
        in_0 = 32'b10101010;
        in_1 = 32'b11001100;
        #10;
        $display("XOR Test: %b ^ %b = %b", in_0, in_1, out);
        $display("flags, ZERO=%d, NEGATIVE = %d", ZERO, NEGATIVE);

        // Test SLL operation
        opcode = `ALU_OPERATION_SLL; // SLL
        in_0 = 32'd15;
        in_1 = 32'h4; // Shift by 4
        #10;
        $display("SLL Test: %d << %h = %d", in_0, in_1[4:0], out);
        $display("flags, ZERO=%d, NEGATIVE = %d", ZERO, NEGATIVE);

        // Test SRL operation
        opcode = `ALU_OPERATION_SRL; // SRL
        in_0 = 32'd120;
        in_1 = 32'h3; // Shift by 3
        #10;
        $display("SRL Test (Unsigned): %d >> %h = %d", in_0, in_1[4:0], out);
        $display("flags, ZERO=%d, NEGATIVE = %d", ZERO, NEGATIVE);

        // Test SRA operation
        opcode = `ALU_OPERATION_SRA; // SRA
        in_0 = -32'd120;
        in_1 = 32'h3; // Shift by 3
        #10;
        $display("SRA Test (Signed): %b >>> %b = %b", in_0, in_1[4:0], out);
        $display("flags, ZERO=%d, NEGATIVE = %d", ZERO, NEGATIVE);

        #10;
        $display("SRA Test (Signed): %b >>> %b = %b", in_0, in_1[4:0], out);
        $display("flags, ZERO=%d, NEGATIVE = %d", ZERO, NEGATIVE);
        $finish;
    end

endmodule
