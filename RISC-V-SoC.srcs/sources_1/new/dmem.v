module dmem(
    input clk,
    input [31:0] dmem_addr, //input from core
    input [31:0] dmem_wdata, //input from core
    input dmem_wen, //input from core
    output [31:0] dmem_rdata
);


reg [31:0] blockram [0:255];

assign dmem_rdata = blockram [dmem_addr[9:2]];

always @(posedge clk) begin
    if(dmem_wen) blockram[dmem_addr[9:2]] <= dmem_wdata;
end

endmodule