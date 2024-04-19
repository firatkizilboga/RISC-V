`ifndef MUX
`define MUX
module MUX_2IN_32DATA (
    input  wire [31:0] in_0,
    input  wire [31:0] in_1,
    input  wire        select,
    output reg  [31:0] out
);
  reg [31:0] out_reg;

  always @(*) begin

    case (select)
      0:   out   <= in_0;
      1:   out   <= in_1;
      default:    out <= 31'bZ;
    endcase

  end
endmodule

module MUX_3IN_32DATA (
    input  wire [31:0] in_0,
    input  wire [31:0] in_1,
    input  wire [31:0] in_2,
    input  wire [ 1:0] select,
    output reg  [31:0] out
);
  reg [31:0] out_reg;

  always @(*) begin
    case (select)
      2'b00:   out = in_0;
      2'b01:   out = in_1;
      2'b10:   out = in_2;
      default: out = 31'bZ;
    endcase
    $display("inside the mux3, in0 = %h in1 = %h in2 = %h, sel %b, time = %d", in_0, in_1, in_2,
             select, $time);
    $display("mux3 out: 0x%h", out);
  end

endmodule

`endif
