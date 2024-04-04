`include "alu/alu.v"
`define R_TYPE 7'b0110011
`define I_TYPE 7'b0010011
`define J_TYPE 7'b1101111
`define U_TYPE 7'b0110111
`define B_TYPE 7'b1100011
`define S_TYPE 7'b0100011

module DecodeControl (
    input   wire    [31:0]                              instruction ,

    output  reg                                         PC_IN_MUX_SEL   ,

    output  reg                                         ALU_OP_1_MUX_SEL    ,
    output  reg                                         ALU_OP_2_MUX_SEL    ,
    output  reg     [2:0]                               ALU_OPCODE  ,

    output  reg                                         RF_WR_EN    ,
    output  reg     [1:0]                               RF_DATA_IN_MUX_SEL  ,

    output  reg                                         DATA_MEMORY_WR_EN   ,
    output  reg     [31:0]                              immediate   ,

    output  reg     [4:0]                               RF_SEL_1    ,
    output  reg     [4:0]                               RF_SEL_2    ,
    output  reg     [4:0]                               RF_SEL_RD   ,

    output reg branch_taken,
    output  reg     [6:0]                               OPCODE  

    );
    reg             [6:0]                               func7   ;
    reg             [2:0]                               func3   ;
always @(instruction    ) begin
        OPCODE  = instruction[6:0];


    //type detection
    case (OPCODE    )
        `R_TYPE: processRType(instruction   );
        `I_TYPE: processIType(instruction   );
        `J_TYPE: processJType(instruction   );
        `U_TYPE: processUType(instruction   );
        `B_TYPE: processBType(instruction   );
        `S_TYPE: processSType(instruction   );
        default: $finish;
    endcase
end

task processRType(input [31:0]instr );
    begin
        func7           = instruction[31:25];  
        RF_SEL_2        = instruction[24:20];
        RF_SEL_1        = instruction[19:15];
        func3           = instruction[14:12];
        RF_SEL_RD       = instruction[11: 7];

        case (func3)
            3'h0://add sub
                begin
                if (func7 == 7'h00) begin
                    ALU_OPCODE  = `ALU_OPERATION_ADD;
                end 
                if (func7 == 7'h20) begin
                    ALU_OPCODE  = `ALU_OPERATION_SUB;
                end
                end
                

            3'h4://xor
                if (func7 == 7'h00) begin
                    ALU_OPCODE  = `ALU_OPERATION_XOR;
                end

            3'h6://or
                if (func7 == 7'h00) begin
                    ALU_OPCODE  = `ALU_OPERATION_OR;
                end

            3'h7://and
                if (func7 == 7'h00) begin
                    ALU_OPCODE  = `ALU_OPERATION_AND;
                end

            3'h1://sll
                if (func7 == 7'h00) begin
                    ALU_OPCODE  = `ALU_OPERATION_SLL;
                end

            3'h5://srl //sra
                begin    
                if (func7 == 7'h00) begin
                    ALU_OPCODE  = `ALU_OPERATION_SRL;
                end
                if (func7 == 7'h20) begin
                    ALU_OPCODE  = `ALU_OPERATION_SRA;
                end
                end
            3'h2://slt
                if (func7 == 7'h00) begin
                    //TODO: IMPLEMENT LATER
                    $finish;
                end

            3'h3://sltu 
                if (func7 == 7'h00) begin
                    //TODO: IMPLEMENT LATER
                    $finish;
                end

            default: 
                $finish;  
        endcase

        PC_IN_MUX_SEL = 1'b0;
        ALU_OP_1_MUX_SEL = 1'b1;
        ALU_OP_2_MUX_SEL = 1'b0;
        branch_taken = 1'b0;
        DATA_MEMORY_WR_EN = 1'b0;
        RF_DATA_IN_MUX_SEL = 2'b01;
        RF_WR_EN    = 1'b1;
    end
endtask



task processIType(input [31:0]instr );
    begin
        immediate       = instruction[31:20];
        RF_SEL_1        = instruction[19:15];
        func3           = instruction[14:12];
        RF_SEL_RD       = instruction[11: 7];

        case (func3)
            3'h0://addi
                    ALU_OPCODE  = `ALU_OPERATION_ADD;

            3'h4://xori
                    ALU_OPCODE  = `ALU_OPERATION_XOR;

            3'h6://ori
                    ALU_OPCODE  = `ALU_OPERATION_OR;

            3'h7://andi
                    ALU_OPCODE  = `ALU_OPERATION_AND;

            3'h1://slli
                if (immediate[11:5] == 7'h00) begin
                    ALU_OPCODE  = `ALU_OPERATION_SLL;
                end
            3'h5://srl //sra
                begin    
                if (immediate[11:5] == 7'h00) begin
                    ALU_OPCODE  = `ALU_OPERATION_SRL;
                end
                if (immediate[11:5] == 7'h20) begin
                    ALU_OPCODE  = `ALU_OPERATION_SRA;

                end
                end
            3'h2://slti
                    //TODO: IMPLEMENT LATER
                    $finish;

            3'h3://slti
                    //TODO: IMPLEMENT LATER
                    $finish;

            default: 
                $finish;  
        endcase

        PC_IN_MUX_SEL = 1'b0;
        RF_WR_EN    = 1'b1;
        branch_taken = 1'b0;

        ALU_OP_1_MUX_SEL = 1'b1;
        ALU_OP_2_MUX_SEL = 1'b1;
        DATA_MEMORY_WR_EN = 1'b0;
        RF_DATA_IN_MUX_SEL = 2'b01;

    end
endtask

task processJType(input [31:0] instr    );
    begin
        // Implementation for I-Type instructions
        // ...
    end
endtask

task processUType(input [31:0] instr    );
    begin
        // Implementation for I-Type instructions
        // ...
    end
endtask

task processBType(input [31:0] instr    );
    begin
        // Implementation for I-Type instructions
        // ...
    end
endtask

task processSType(input [31:0] instr    );
    begin
        // Implementation for I-Type instructions
        // ...
    end
endtask

endmodule












