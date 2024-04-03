`include "mux/mux.v"
// Top-level module or testbench
module top;

    // MUX select line and output
    reg select_line;
    wire [31:0] mux_output;

    // Declare input wires for the MUX
    reg [31:0] in_0, in_1;

    // Instantiate the MUX
    MUX_2IN_32DATA mux (
        .select(select_line),
        .out(mux_output),
        .in_0(in_0),
        .in_1(in_1)
        );

    // Testbench logic to drive the inputs and select line
    initial begin
        // Initialize inputs
        in_0 = 32'hAA; // Example values
        in_1 = 32'hBB;

        // Cycle through select lines and display output
        select_line = 0; #10;
        $display("Time: %d, Select: %d, Output: %h", $time, select_line, mux_output);
        
        select_line = 1; #10;
        $display("Time: %d, Select: %d, Output: %h", $time, select_line, mux_output);


        // Finish simulation
        $finish;
    end

endmodule
