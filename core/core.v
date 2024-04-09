`include "mux/mux.v"
`include "register/register.v"
`include "registers/registers.v"
`include "memory/memory.v"
`include "decode-control/decode-control.v"

module CORE     (
    input   wire                                        clock   
        );

    MUX_2IN_32DATA PC_IN_MUX    (
        .in_0   (PCNext.out ),
        .in_1   (ALU_32.out ),
        .select (DCU.PC_IN_MUX_SEL  )
            );
    
    Register PC(
        .clock(clock    ),
        .in(PC_IN_MUX.out   )
        );

    PCINC PCNext(
        .clock(clock),
        .PC(PC.out)
        );

    INSTRUCTION_MEMORY IM(
	.clock(clock),
        .addr(PC.out)
        );
    

    DecodeControl DCU(
        .clock(clock),
        .instruction(IM.data_out)
        );

    Registers RF(
        .clock(clock),
        .WR_EN(DCU.RF_WR_EN ),
        .reg_1_select(DCU.RF_SEL_1  ),
        .reg_2_select(DCU.RF_SEL_2  ),
        .data_in(RF_DATA_IN_MUX.out  ),
        .write_select(DCU.RF_SEL_RD )
        );


    MUX_2IN_32DATA ALU_OP_1_MUX    (
        .in_0   (PC.out ),
        .in_1   (RF.reg_1   ),
        .select (DCU.ALU_OP_1_MUX_SEL   )
        );

    MUX_2IN_32DATA ALU_OP_2_MUX    (
        .in_0   (RF.reg_2   ),
        .in_1   (DCU.immediate  ),
        .select (DCU.ALU_OP_2_MUX_SEL   )
        );

    ALU ALU_32(
        .clock(clock),
        .opcode(DCU.ALU_OPCODE  ),
        .op_0(ALU_OP_1_MUX.out  ),
        .op_1(ALU_OP_2_MUX.out  )
        );

    DATA_MEMORY DM(
        .addr(ALU_32.out    ),
        .data_in(RF.reg_2   ),
        .we(DATA_MEMORY_WR_EN   )
        );

    MUX_3IN_32DATA RF_DATA_IN_MUX(
        .in_0(PCNext.out    ), //PC+4
        .in_1(ALU_32.out    ),
        .in_2(DM.data_out   ),
        .select(DCU.RF_DATA_IN_MUX_SEL  )
        );
    
    always @(clock) begin
        $display("############################");
        $display("Time: %d, Clock: %b", $time, clock);

        // Displaying outputs of PC_IN_MUX
        $display("PC_IN_MUX.out: %h", PC_IN_MUX.out);

        // Displaying outputs of PC (Program Counter)
        $display("PC.out: %h", PC.out);

        // Displaying outputs of PCNext (PC Increment)
        $display("PCNext.out: %h", PCNext.out);
        $display("PCNext.PC: %h", PCNext.PC);

        // Displaying outputs of Instruction Memory
        $display("IM.data_out: %h", IM.data_out);

        // Displaying control signals from DecodeControl Unit (DCU)
        $display("DCU.PC_IN_MUX_SEL: %b", DCU.PC_IN_MUX_SEL);
        $display("DCU.RF_WR_EN: %b", DCU.RF_WR_EN);
        $display("DCU.RF_SEL_1: %h", DCU.RF_SEL_1);
        $display("DCU.RF_SEL_2: %h", DCU.RF_SEL_2);
        $display("DCU.RF_SEL_RD: %h", DCU.RF_SEL_RD);
	$display("DCU.RF_DATA_IN_MUX_SEL: %h", DCU.RF_DATA_IN_MUX_SEL);
        $display("DCU.ALU_OP_1_MUX_SEL: %b", DCU.ALU_OP_1_MUX_SEL);
        $display("DCU.ALU_OP_2_MUX_SEL: %b", DCU.ALU_OP_2_MUX_SEL);
        $display("DCU.ALU_OPCODE: %h", DCU.ALU_OPCODE);
        $display("DCU.immediate: %h", DCU.immediate);
        // Add any additional DCU signals here

        // Displaying Register File outputs
        $display("RF.reg_1: %h, RF.reg_2: %h", RF.reg_1, RF.reg_2);

        // Displaying outputs of ALU Operand Muxes
        $display("ALU_OP_1_MUX.out: %h", ALU_OP_1_MUX.out);
        $display("ALU_OP_2_MUX.out: %h", ALU_OP_2_MUX.out);

        // Displaying output of ALU
        $display("ALU_32.out: %h", ALU_32.out);

        // Displaying Data Memory outputs
        $display("DM.data_out: %h", DM.data_out);

        // Displaying output of RF Data In Mux

        $display("RF_DATA_IN_MUX.out: %h", RF_DATA_IN_MUX.out);
    end

endmodule
