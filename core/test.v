`include "core/core.v"
module top ();
  reg clock;
  CORE c (.clock(clock));
  reg [31:0] ticks;
  initial begin

    clock = 0;
    ticks = 0;
  end

  always @(clock) begin
    #100;
    ticks = ticks + 1;
    clock <= ~clock;

    if (ticks == 100) begin
      $finish;
    end
  end
endmodule
