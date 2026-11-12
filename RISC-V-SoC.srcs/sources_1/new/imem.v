module imem(
    input [31:0] imem_addr,
    output [31:0] instruction
);

reg [31:0] blockram [0:255];

initial begin
    $readmemh("program.mem", blockram);
end


assign instruction = blockram[imem_addr[9:2]];

endmodule