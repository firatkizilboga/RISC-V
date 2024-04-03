`include "registers/register.v"
module top  (       );

    reg                                                 clk ;
    reg                                                 inc ;
    reg                                                 load    ;
    reg             [31:0]                              inval   ;

Register #  (
.size   (32     ),
.default_increment  (4      )
        ) register  (
    .clock  (clk        ),
    .inc    (inc        ),
    .load   (load       ),
    .in (inval      )
        );

initial begin
    clk         = 0;
    inc         = 0;
    load        = 0;
    inval       = 0;

    load        = 1;
    clk         = 1; #5;
    $display ("in: %x, inc: %b, load: %b, out: %x", register.out, inc, load, inval      );
    clk         = 0; #5;

    load        = 1;
    inval       = 32'hAAA0;
    clk         = 1; #5;
    $display ("in: %x, inc: %b, load: %b, out: %x", register.out, inc, load, inval      );
    clk         = 0; #5;


    load        = 0;
    inc         = 1;
    clk         = 1; #5;
    $display ("in: %x, inc: %b, load: %b, out: %x", register.out, inc, load, inval      );
    clk         = 0; #5;

end

endmodule