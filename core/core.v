`include "mux/mux.v"
module CORE     (
    input wire clock
);
    MUX_2IN_32DATA PCMUX    (
        .in_0   (),
        .in_1   (),
        .select (),
    );

    
endmodule