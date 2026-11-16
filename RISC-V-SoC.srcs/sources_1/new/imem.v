module imem(
    input clk,
    input [31:0] imem_addr,
    output reg [31:0] instruction
);

(*ram_style = "block"*) reg [31:0] blockram [0:255];

initial begin
    $readmemh("program.mem", blockram);
end

always @(posedge clk) begin
    instruction <= blockram[imem_addr[9:2]];
end

endmodule