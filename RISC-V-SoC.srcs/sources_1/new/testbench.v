`timescale 1ns / 1ps

module testbench();
reg clk;
reg rst;
wire [15:0] led;

top topmodule(
    .clk(clk),
    .btnC(rst),
    .led(led)
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