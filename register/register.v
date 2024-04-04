module Register #(
    parameter                                           size    = 32,
    parameter                                           default_increment   = 4
    )           (
    input   wire                                        clock   ,
    input   wire    [size-1:0]                          in  ,
    output  reg     [size-1:0]                          out 
    );

initial begin
    out     = 0;
end

always @            (posedge clock  ) begin
    out     <= in;
end

endmodule

