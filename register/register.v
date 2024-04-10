module Register #(
    parameter size = 32
) (
    input  wire            clock,
    input  wire [size-1:0] in,
    output reg  [size-1:0] out
);

  initial begin
    out = 32'h00000000;
  end

  always @(posedge clock) begin
    out = in;
  end

endmodule

