module Registers     (
    input   wire                                        WR_EN    ,
    input   wire    [4:0]                               reg_1_select    ,
    input   wire    [4:0]                               reg_2_select    ,
    input   wire    [31:0]                              data_in ,
    input   wire    [4:0]                               write_select    ,
    output  reg     [31:0]                              reg_1   ,
    output  reg     [31:0]                              reg_2   
                );

    reg             [31:0]                              registers   [31:0];

initial begin

    for (integer i = 0; i < 32; i = i + 1) begin
        registers[i] <= 32'b0; 
    end
    reg_1 <= 32'b0; 
    reg_2 <= 32'b0; 
end



always @(WR_EN, reg_1_select ,reg_2_select, data_in, write_select) begin
    reg_1   <= registers[reg_1_select];
    reg_2   <= registers[reg_2_select];

    if (WR_EN && (write_select != 5'd0)) begin
        registers[write_select]     <= data_in;
    end
end


endmodule