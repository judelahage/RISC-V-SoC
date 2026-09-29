module alu(
    input [3:0] alu_control,
    input [31:0] a, b,
    output reg [31:0] result,
    output zero_flag
);

localparam ADD = 4'b0000;
localparam SUB = 4'b0001;
localparam AND = 4'b0011;
localparam OR = 4'b0111;
localparam XOR = 4'b1111;
localparam SLL = 4'b1110;
localparam SRL = 4'b1100;
localparam SRA = 4'b1000;
localparam SLT = 4'b1001;
localparam SLTU = 4'b1011;

assign zero_flag = (result == 32'b0) ? 1 : 0;

always @(*) begin
    case(alu_control)
        ADD: result = a + b;
        SUB: result = a - b;
        AND: result = a & b;
        OR: result = a | b;
        XOR: result = a ^ b;
        SLL: result = a << b[4:0]; //shift left logical
        SRL: result = a >> b[4:0]; //shift right logical
        SRA: result = $signed(a) >>> b[4:0]; //shift right arithmetic (keep the sign bit)
        SLT: result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0; //less than signed
        SLTU: result = (a < b) ? 32'd1 : 32'd0; //less than unsigned
        default: result = 32'd0;
        
    endcase
end
endmodule
