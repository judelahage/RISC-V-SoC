module PCreg (
    input clk,
    input rst,
    input [31:0] pc_next,
    output reg [31:0] pc
);

always @(posedge clk or posedge rst) begin
    if(rst) pc <= 0;
    else pc <= pc_next;
end


endmodule