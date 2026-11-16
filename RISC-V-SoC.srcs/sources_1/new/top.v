module top(
    input clk,
    input btnC,
    output reg [15:0] led
);

wire dmem_wen;
wire ram_wen;
wire [31:0] imem_addr;
wire [31:0] dmem_addr;
wire [31:0] dmem_wdata;
wire [31:0] ram_rdata;
wire [31:0] dmem_rdata;
wire [31:0] instruction;

imem instruction_memory(
    .clk(clk),
    .imem_addr(imem_addr),
    .instruction(instruction)
);

dmem data_memory(
    .clk(clk),
    .dmem_addr(dmem_addr),
    .dmem_wdata(dmem_wdata),
    .dmem_wen(ram_wen),
    .dmem_rdata(ram_rdata)
);

core cpu(
    .clk(clk),
    .rst(btnC),
    .imem_rdata(instruction),
    .dmem_rdata(dmem_rdata),
    .imem_addr(imem_addr),
    .dmem_addr(dmem_addr),
    .dmem_wdata(dmem_wdata),
    .dmem_wen(dmem_wen)
);

always @(posedge clk or posedge btnC) begin
    if (btnC) led <= 16'b0;
    else if (dmem_addr == 32'h10000000 && dmem_wen) led <= dmem_wdata[15:0];
end

assign ram_wen = (dmem_wen & dmem_addr != 32'h10000000) ? 1 : 0;
assign dmem_rdata = (dmem_addr == 32'h10000000) ?{16'b0,led} : ram_rdata;
endmodule
