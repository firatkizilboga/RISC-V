`define ALU_OPERATION_ADD 3'b000
`define ALU_OPERATION_SUB 3'b001
`define ALU_OPERATION_AND 3'b010
`define ALU_OPERATION_OR  3'b011
`define ALU_OPERATION_XOR 3'b100
`define ALU_OPERATION_SLL 3'b101
`define ALU_OPERATION_SRL 3'b110
`define ALU_OPERATION_SRA 3'b111

module ALU (
    input   wire    [2:0]                               opcode  ,
    input   wire    [31:0]                              in_0    ,
    input   wire    [31:0]                              in_1    ,
    output  reg     [31:0]                              out ,
    output  reg                                         ZERO    ,   
    output  reg                                         NEGATIVE    
            );
    

initial begin
    out     = 0;
    ZERO    = 1;
    NEGATIVE    = 0;
end

always @(opcode, in_0, in_1 ) begin
    

    case (opcode    )
        `ALU_OPERATION_ADD:
            out     = in_0 + in_1;
        `ALU_OPERATION_SUB:
            out     = in_0 - in_1;
        `ALU_OPERATION_AND:
            out     = in_0 & in_1;
        `ALU_OPERATION_OR:
            out     = in_0 | in_1;
        `ALU_OPERATION_XOR:
            out     = in_0 ^ in_1;
        `ALU_OPERATION_SLL:
            out     = in_0 << in_1[4:0];
        `ALU_OPERATION_SRL:
            out     = in_0 >> in_1[4:0];
        `ALU_OPERATION_SRA:
            out     = ($signed(in_0)) >>> in_1[4:0]; 
        default: 
            out     = 0;
    endcase


    if (out == 0) begin
        ZERO    <= 1;
    end else begin
        ZERO    <= 0;
    end
    
    if (out[31] ==  1) begin
        NEGATIVE    <= 1;
    end else begin
        NEGATIVE    <= 0;
    end

end


endmodule