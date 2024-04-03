`include "registers/registers.v"
`timescale 1ns / 1ps

module test;

    // Inputs
    reg clock;
    reg write_enable;
    reg [4:0] reg_1_select;
    reg [4:0] reg_2_select;
    reg [31:0] data_in;
    reg [4:0] write_select;

    // Outputs
    wire [31:0] reg_1;
    wire [31:0] reg_2;

    // Instantiate the Unit Under Test (UUT)
    Registers uut (
        .clock(clock), 
        .write_enable(write_enable), 
        .reg_1_select(reg_1_select), 
        .reg_2_select(reg_2_select), 
        .data_in(data_in), 
        .write_select(write_select), 
        .reg_1(reg_1), 
        .reg_2(reg_2)
    );

    initial begin
        // Initialize Inputs
        clock = 0;
        write_enable = 0;
        reg_1_select = 0;
        reg_2_select = 0;
        data_in = 0;
        write_select = 0;

        // Wait 100 ns for global reset to finish
        #100;
        
        // Write 0xAAAA_AAAA to register 16
        write_enable = 1;
        write_select = 5'd16;
        data_in = 32'hAAAA_AAAA;
        $display("Time: %d, Writing 0x%h to register %d", $time, data_in, write_select);
        #10; clock = 1; #10; clock = 0;

        // Write 0xBBBB_BBBB to register 17
        write_select = 5'd17;
        data_in = 32'hBBBB_BBBB;
        $display("Time: %d, Writing 0x%h to register %d", $time, data_in, write_select);
        #10; clock = 1; #10; clock = 0;

        // Read from registers 16 and 17
        write_enable = 0;
        reg_1_select = 5'd16;
        reg_2_select = 5'd17;
        #10; clock = 1; #10; clock = 0;
        $display("Time: %d, Read reg_1: 0x%h, reg_2: 0x%h", $time, reg_1, reg_2);

        // Attempt to write to register 0
        write_enable = 1;
        write_select = 5'd0;
        data_in = 32'hCCCC_CCCC;
        $display("Time: %d, Attempting to write 0x%h to register %d", $time, data_in, write_select);
        #10; clock = 1; #10; clock = 0;

        // Read from register 1 (expected unchanged)
        write_enable = 0;
        reg_1_select = 5'd1;
        #10; clock = 1; #10; clock = 0;
        $display("Time: %d, Read reg_1 (expected unchanged): 0x%h", $time, reg_1);

    end

    // Clock generation
    always #5 clock = ~clock; // Generate a clock with a period of 10 ns

endmodule
