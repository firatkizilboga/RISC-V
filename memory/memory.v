module DATA_MEMORY #(
    parameter DATA_WIDTH = 8,      // Width of the data
    parameter ADDR_WIDTH = 32,      // Number of address bits
    parameter MEM_DEPTH = 1 << ADDR_WIDTH  // Depth of the memory
) (
    input wire clk,
    input wire [ADDR_WIDTH-1:0] addr,  // Address input
    input wire [DATA_WIDTH-1:0] data_in,  // Data input for write operations
    input wire we,  // Write enable
    output reg [DATA_WIDTH-1:0] data_out  // Data output for read operations
);

    // Memory array
    reg [DATA_WIDTH-1:0] mem_array [0:10];

    // Read and Write operations
    always @(posedge clk) begin
        if (we) begin
            mem_array[addr] <= data_in;  // Write operation
        end
        data_out <= mem_array[addr];  // Read operation
    end

    // Initial block to load memory from a file
    initial begin
        $readmemh("memory/data.mem", mem_array); // Replace "memory_file.mem" with your variable file name
    end

endmodule

module INSTRUCTION_MEMORY #(
    parameter DATA_WIDTH = 8,      // Width of the data
    parameter ADDR_WIDTH = 32,      // Number of address bits
    parameter MEM_DEPTH = 1 << ADDR_WIDTH  // Depth of the memory
) (
    input wire clk,
    input wire [ADDR_WIDTH-1:0] addr,  // Address input
    output reg [DATA_WIDTH-1:0] data_out  // Data output for read operations
);

    // Memory array
    reg [DATA_WIDTH-1:0] mem_array [0:20];

    // Read and Write operations
    always @(posedge clk) begin
        data_out <= mem_array[addr];  // Read operation
    end

    // Initial block to load memory from a file
    initial begin
        $readmemh("memory/instructions.mem", mem_array); // Replace "memory_file.mem" with your variable file name
    end
    
endmodule
