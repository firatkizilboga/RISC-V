module Registers (
    input  wire        clock,
    input  wire        WR_EN,
    input  wire [ 4:0] reg_1_select,
    input  wire [ 4:0] reg_2_select,
    input  wire [31:0] data_in,
    input  wire [ 4:0] write_select,
    output reg  [31:0] reg_1,
    output reg  [31:0] reg_2
);

  reg [31:0] registers[31:0];

  initial begin

    for (integer i = 0; i < 32; i = i + 1) begin
      registers[i] = 32'b0;
    end
    reg_1 = 32'b0;
    reg_2 = 32'b0;
  end



  always @(*) begin
    reg_1 = registers[reg_1_select];
    reg_2 = registers[reg_2_select];
    $display("out vals %h %h", reg_1, reg_2);
  end

  always @(negedge clock) begin
    if (WR_EN && (write_select != 5'd0)) begin
      $display("$$$$$$$$$$$$$$$$$$$$$");
      $display("Writing to register %d, %d", write_select, $time);
      $display("Writing value 0x%h", data_in);
      registers[write_select] = data_in;
    end
    print_regs();
  end



  task print_regs;
    begin
      for (integer i = 0; i < 32; i = i + 1) begin
        $display("Register %d: 0x%h", i, registers[i]);
      end
    end
  endtask

endmodule
