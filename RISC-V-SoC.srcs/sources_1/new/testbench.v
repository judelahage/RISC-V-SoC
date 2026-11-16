`timescale 1ns / 1ps

module testbench();
reg clk;
reg rst;
wire [31:0] imem_rdata;
wire [31:0] dmem_rdata;
wire [31:0] imem_addr;
wire [31:0] dmem_addr;
wire [31:0] dmem_wdata;
wire dmem_wen;

core cpu(
    .clk(clk),
    .rst(rst),
    .imem_rdata(imem_rdata),
    .dmem_rdata(dmem_rdata),
    .imem_addr(imem_addr),
    .dmem_addr(dmem_addr),
    .dmem_wdata(dmem_wdata),
    .dmem_wen(dmem_wen)
);

dmem data_memory(
    .clk(clk),
    .dmem_addr(dmem_addr),
    .dmem_wdata(dmem_wdata),
    .dmem_wen(dmem_wen),
    .dmem_rdata(dmem_rdata)
);

imem instruction_memory(
    .clk(clk),
    .imem_addr(imem_addr),
    .instruction(imem_rdata)
);



initial begin
    clk = 0;
    rst = 1;
    #20;
    rst = 0;
    #200;
    $finish;
end

always begin
    #5;
    clk = ~clk;
end
endmodule