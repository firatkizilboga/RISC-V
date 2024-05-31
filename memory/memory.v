module DATA_MEMORY (
    input wire clock,
    input wire [31:0] addr,  // Address input
    input wire [31:0] data_in,  // Data input for write operations
    input wire we,  // Write enable
    input wire [1:0] size,
    input wire sign_extend,
    output reg [31:0] data_out  // Data output for read operations
);

  // Memory array
  reg [7:0] mem_array[0:8191];  // Smaller buffer of 8192 locations
  integer fd;
  integer i, j;

  // Function to calculate memory index for read and write operations
  function [31:0] calc_index;
      input [31:0] base_addr;
      input [1:0] offset;
      begin
          calc_index = (base_addr << 2) + offset;
      end
  endfunction

  always @(negedge clock) begin
    if (we) begin
      $display("DATA MEMORY WRITE addr data_in: 0x%h", addr, data_in);
      case (size)
        2'b00: mem_array[calc_index(addr, 2'b00)] = data_in[7:0];
        2'b01: begin
          mem_array[calc_index(addr, 2'b00)] = data_in[15:8];
          mem_array[calc_index(addr, 2'b01)] = data_in[7:0];
        end
        2'b10: begin
          mem_array[calc_index(addr, 2'b00)] = data_in[23:16];
          mem_array[calc_index(addr, 2'b01)] = data_in[15:8];
          mem_array[calc_index(addr, 2'b10)] = data_in[7:0];
        end
        2'b11: begin
          mem_array[calc_index(addr, 2'b00)] = data_in[31:24];
          mem_array[calc_index(addr, 2'b01)] = data_in[23:16];
          mem_array[calc_index(addr, 2'b10)] = data_in[15:8];
          mem_array[calc_index(addr, 2'b11)] = data_in[7:0];
        end
        default: begin
          mem_array[calc_index(addr, 2'b00)] = data_in[31:24];
          mem_array[calc_index(addr, 2'b01)] = data_in[23:16];
          mem_array[calc_index(addr, 2'b10)] = data_in[15:8];
          mem_array[calc_index(addr, 2'b11)] = data_in[7:0];
        end
      endcase

      res = $fseek(fd, 0, 0);  // Seek to the beginning of the file
      for (i = 0; i <= 8191; i = i + 1) begin
        $fwrite(fd, "%c", mem_array[i]);
      end
    end
  end

  always @(*) begin
    case (size)
      2'b00: begin
          if (sign_extend && mem_array[calc_index(addr, 2'b00)][7]) begin 
              data_out = {24'hFFFFFF, mem_array[calc_index(addr, 2'b00)]}; 
          end

          else begin 
              data_out = {24'h000000, mem_array[calc_index(addr, 2'b00)]}; 
          end 
      end
      2'b01: begin
          if (sign_extend && mem_array[calc_index(addr, 2'b00)][7]) begin
              data_out = {16'hFFFF, mem_array[calc_index(addr, 2'b00)], mem_array[calc_index(addr, 2'b01)]}; 
          end
          else begin
              data_out = {16'h0000, mem_array[calc_index(addr, 2'b00)], mem_array[calc_index(addr, 2'b01)]};
         end 
      end

      2'b10: begin
          if (sign_extend && mem_array[calc_index(addr, 2'b00)][7]) begin
              data_out = {8'hFF, mem_array[calc_index(addr, 2'b00)], mem_array[calc_index(addr, 2'b01)], mem_array[calc_index(addr, 2'b10)]};
          end
          else begin
              data_out = {8'h00, mem_array[calc_index(addr, 2'b00)], mem_array[calc_index(addr, 2'b01)], mem_array[calc_index(addr, 2'b10)]};
          end
      end

      default: begin
          data_out = {mem_array[calc_index(addr, 2'b00)], mem_array[calc_index(addr, 2'b01)], mem_array[calc_index(addr, 2'b10)], mem_array[calc_index(addr, 2'b11)]}; 
      end
    endcase
  end

  // Initial block to load memory from a file
  integer res;
  initial begin
    $readmemh("memory/data.mem", mem_array);  // Replace "memory_file.mem" with your variable file name

    // Fill data memory with all zeros
    for (integer i = 0; i < 8200; i = i + 1) begin
      mem_array[i] = 8'h00;
    end
    fd = $fopen("VGA_BUFFER.bin", "wb");
    j = 0;
  end

  task memdump;
    begin
      for (integer i = 0; i < 20; i = i + 1) begin
        $display("memor[0x%h] -> 0x%h", i + 32'd4000, mem_array[i + 32'd4000]);
      end
    end
  endtask

endmodule


module DATA_MEMORY1 (
    input wire clock,
    input wire [31:0] addr,  // Address input
    input wire [31:0] data_in,  // Data input for write operations
    input wire we,  // Write enable
    input wire [1:0] size,
    input wire sign_extend,
    output reg [31:0] data_out  // Data output for read operations
);

  // Memory array
  reg [7:0] mem_array[0:70];
  integer fd;
  integer i;
  always @(negedge clock) begin
    if (we) begin
      $display("DATA MEMORY WRITE addr data_in: 0x%h", addr, data_in);
      case (size)
        2'd0: mem_array[addr] = data_in[7:0];
        2'd1: begin
          mem_array[addr] = data_in[15:8];
          mem_array[addr+1]   = data_in[7:0];
        end
        2'd2: begin
          mem_array[addr] = data_in[23:16];
          mem_array[addr+1] = data_in[15:8];
          mem_array[addr+2]   = data_in[7:0];
        end
        2'd3: begin
          mem_array[addr] = data_in[31:24];
          mem_array[addr+1] = data_in[23:16];
          mem_array[addr+2] = data_in[15:8];
          mem_array[addr+3]   = data_in[7:0];
        end      default: begin
          mem_array[addr] = data_in[31:24];
          mem_array[addr+1] = data_in[23:16];
          mem_array[addr+2] = data_in[15:8];
          mem_array[addr+3]   = data_in[7:0];
        end
      endcase

    res = $fseek(fd, 0, 0);  // Seek to the beginning of the file
      for (i = 0; i <= 32'd70000; i = i + 1) begin
            $fwrite(fd, "%c", mem_array[i]);
        end

    end
   //memdump();
  end
  always @(*) begin
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

    integer j;
  // Initial block to load memory from a file
  integer res;
  initial begin
    $readmemh("memory/data.mem",
              mem_array);  // Replace "memory_file.mem" with your variable file name

    //fill data memory with all zeros
    for (integer i = 0; i < 8200; i = i + 1) begin
      mem_array[i] = 8'h00;
    end
    fd = $fopen("VGA_BUFFER.bin", "wb");
    j = 0;
  end



task memdump;
    begin
      for (integer i = 0; i < 20; i = i + 1) begin
        $display("memor[0x%h] -> 0x%h", i + 32'd4000, mem_array[i + 32'd4000]);
      end
    end
  endtask

endmodule

module INSTRUCTION_MEMORY (
    input wire clock,
    input wire [31:0] addr,  // Address input
    input wire [1:0] size,
    output reg [31:0] data_out  // Data output for read operations
);

  reg [7:0] mem_array[0:1024];
  always @(negedge clock) begin
    $display("addr: 0x%h", $unsigned(addr));
    data_out = {mem_array[addr], mem_array[addr+1], mem_array[addr+2], mem_array[addr+3]};
  end

  initial begin
    $readmemh("memory/instructions.mem",
              mem_array);  // Replace "memory_file.mem" with your variable file name
  end
endmodule
