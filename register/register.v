module Register #(
    parameter                                           size    = 32,
    parameter                                           default_increment   = 4
    )           (
    input   wire                                        clock   ,
    input   wire                                        inc ,
    input   wire                                        load    ,
    input   wire    [size-1:0]                          in  ,
    output  reg     [size-1:0]                          out 
    );

initial begin
    out     = 0;
end

always @            (posedge clock  ) begin
    if          (inc    ) begin
            out     <= out + default_increment;
    end else if     (load   ) begin
            out     <= in;
    end
end

endmodule

