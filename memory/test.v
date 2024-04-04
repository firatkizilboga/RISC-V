`include "memory/memory.v"
`timescale 1ns / 1ps

module TestbenchDataMemory;

    // Parameters
    parameter DATA_WIDTH = 32;
    parameter ADDR_WIDTH = 32;

    // Signals
    reg clk;
    reg [ADDR_WIDTH-1:0] addr;
    reg [DATA_WIDTH-1:0] data_in;
    reg we;
    wire [DATA_WIDTH-1:0] data_out;

    // Instantiate the DATA_MEMORY module
    DATA_MEMORY data_memory_inst (
        .addr(addr),
        .data_in(data_in),
        .we(we),
        .data_out(data_out)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test sequence
    integer i;
    initial begin
        // Initialize
        clk = 0;
        we = 0;
        addr = 0;
        data_in = 0;

        // Write operation
        #10;
        we = 1;
        addr = 0;
        data_in = 8'h12;
        #10;
        we = 0;

        // Read and display operation
        for (i = 0; i < 9; i = i + 1) begin
            #10;
            addr = i;
            #10;
            $display("Data at address %h: %h", addr, data_out);
        end

        $finish;
    end

endmodule

`timescale 1ns / 1ps

module TestbenchInstructionMemory;

    // Parameters
    parameter DATA_WIDTH = 32;
    parameter ADDR_WIDTH = 32;

    // Signals
    reg clk;
    reg [ADDR_WIDTH-1:0] addr;
    wire [DATA_WIDTH-1:0] data_out;

    // Instantiate the INSTRUCTION_MEMORY module
    INSTRUCTION_MEMORY instruction_memory_inst (
        .addr(addr),
        .data_out(data_out)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test sequence
    integer i;
    initial begin
        // Initialize
        clk = 0;
        addr = 0;

        // Read and display operation
        for (i = 0; i < 9; i = i + 1) begin
            #10;
            addr = i;
            #10;
            $display("Instruction at address %h: %h", addr, data_out);
        end

        $finish;
    end

endmodule

