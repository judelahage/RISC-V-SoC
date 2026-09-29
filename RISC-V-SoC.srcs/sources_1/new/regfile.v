`timescale 1ns / 1ps

module regfile(
        input [31:0] write_data,
        input write_enable,
        output [31:0] read_data,
        output [31:0] read_data2,
        input clk,

        input [4:0] rs1, //first operand
        input [4:0] rs2, //second operand
        input [4:0] rd //result

    );

    reg [31:0] registers [0:31];

    initial begin
        registers[0] <= 0;
    end

    assign read_data = registers[rs1];
    assign read_data2 = registers[rs2];

    always @(posedge clk) begin
        if(write_enable && rd != 0) registers[rd] <= write_data; //rd != 0 to make sure we don't write to x0
    end

endmodule
