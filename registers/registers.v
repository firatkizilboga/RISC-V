module Registers (
    input  wire        clock,
    input  wire        WR_EN,
    input  wire        SET,
    input  wire        RESET,
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
    $display("write select %h", write_select);
    $display("data in %h", data_in);
    $display("set %h", SET);
    $display("reset %h", RESET);
    if (SET) begin
      registers[write_select] = 32'b1;
    end

    if (RESET) begin
      registers[write_select] = 32'b0;
    end

    if (WR_EN && (write_select != 5'd0)) begin
      registers[write_select] = data_in;
    end
    print_regs();
  end



  task print_regs;
    begin
      for (integer i = 0; i < 32; i = i + 1) begin
        $display("Register %d: %d", i, registers[i]);
      end
    end
  endtask

endmodule
