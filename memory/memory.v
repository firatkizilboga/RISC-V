module DATA_MEMORY (
    input wire [31:0] addr,  // Address input
    input wire [31:0] data_in,  // Data input for write operations
    input wire we,  // Write enable
    input wire [1:0] size,
    input wire sign_extend,
    output reg [31:0] data_out  // Data output for read operations
);

  // Memory array
  reg [7:0] mem_array[0:7];


  always @(addr, data_in, data_out, we, size) begin
    if (we) begin
      case (size)
        2'd0: mem_array[addr] = data_in[7:0];
        2'd1: begin
          mem_array[addr+1] = data_in[15:8];
          mem_array[addr]   = data_in[7:0];
        end
        2'd2: begin
          mem_array[addr+2] = data_in[23:16];
          mem_array[addr+1] = data_in[15:8];
          mem_array[addr]   = data_in[7:0];
        end
        2'd3: begin
          mem_array[addr+3] = data_in[31:24];
          mem_array[addr+2] = data_in[23:16];
          mem_array[addr+1] = data_in[15:8];
          mem_array[addr]   = data_in[7:0];
        end
        default: begin
          mem_array[addr+3] = data_in[31:24];
          mem_array[addr+2] = data_in[23:16];
          mem_array[addr+1] = data_in[15:8];
          mem_array[addr]   = data_in[7:0];
        end
      endcase
    end
    case (size)
      2'd0: begin
        if (sign_extend && mem_array[addr][7]) data_out = {24'hFFFFFF, mem_array[addr]};
        else data_out = {24'h000000, mem_array[addr]};
      end
      2'd1: begin
        if (sign_extend && mem_array[addr][7])
          data_out = {16'hFFFF, mem_array[addr], mem_array[addr+1]};
        else data_out = {16'h0000, mem_array[addr], mem_array[addr+1]};
      end
      2'd2: begin
        if (sign_extend && mem_array[addr][7])
          data_out = {8'hFF, mem_array[addr], mem_array[addr+1], mem_array[addr+2]};
        else data_out = {8'h00, mem_array[addr], mem_array[addr+1], mem_array[addr+2]};
      end
      2'd3: data_out = {mem_array[addr], mem_array[addr+1], mem_array[addr+2], mem_array[addr+3]};
      default:
      data_out = {mem_array[addr], mem_array[addr+1], mem_array[addr+2], mem_array[addr+3]};
    endcase

  end

  // Initial block to load memory from a file
  initial begin
    $readmemh("memory/data.mem",
              mem_array);  // Replace "memory_file.mem" with your variable file name
  end

endmodule

module INSTRUCTION_MEMORY (
    input wire clock,
    input wire [31:0] addr,  // Address input
    input wire [1:0] size,
    output reg [31:0] data_out  // Data output for read operations
);

  reg [7:0] mem_array[0:15];
  always @(negedge clock) begin
    $display("addr: 0x%h", addr);

    case (size)
      2'd0: data_out = {mem_array[addr]};
      2'd1: data_out = {mem_array[addr], mem_array[addr+1]};
      2'd2: data_out = {mem_array[addr], mem_array[addr+1], mem_array[addr+2]};
      2'd3: data_out = {mem_array[addr], mem_array[addr+1], mem_array[addr+2], mem_array[addr+3]};
      default:
      data_out = {mem_array[addr], mem_array[addr+1], mem_array[addr+2], mem_array[addr+3]};
    endcase


  end

  initial begin
    $readmemh("memory/instructions.mem",
              mem_array);  // Replace "memory_file.mem" with your variable file name
  end
endmodule
