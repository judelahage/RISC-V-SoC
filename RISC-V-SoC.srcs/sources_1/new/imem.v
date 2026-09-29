module imem(
    input [31:0] pc,
    output [31:0] instruction
);

reg [31:0] blockram [0:255];

assign instruction = blockram[pc[9:2]];

endmodule