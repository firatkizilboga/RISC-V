`include "core/core.v"
module top ();
    reg clock;
    CORE c(
        .clock(clock)
    );
    initial begin
        clock = 0;
    end

    always @(clock) begin
        clock = ~clock;
        #200;
    end
endmodule