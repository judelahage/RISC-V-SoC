module instr_decoder(
    input [31:0] instruction,
    output [4:0] rs2,
    output [4:0] rs1,
    output [4:0] rd,
    output [6:0] funct7,
    output [2:0] funct3,
    output [6:0] opcode,
    output reg [31:0] imm
);

localparam OPCODE_LUI = 7'b0110111;
localparam OPCODE_AUIPC = 7'b0010111;
localparam OPCODE_JAL = 7'b1101111;
localparam OPCODE_JALR = 7'b1100111;
localparam OPCODE_BRANCH = 7'b1100011;
localparam OPCODE_LOAD = 7'b0000011;
localparam OPCODE_STORE = 7'b0100011;
localparam OPCODE_OP_IMM = 7'b0010011;
localparam OPCODE_OP = 7'b0110011;

assign rs2 = instruction[24:20];
assign rs1 = instruction[19:15];
assign rd = instruction[11:7];
assign funct7 = instruction[31:25];
assign funct3 = instruction[14:12];
assign opcode = instruction [6:0];

wire [31:0] imm_u, imm_j, imm_b, imm_i, imm_s;
assign imm_u = {instruction[31:12], 12'b0};
assign imm_j = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};
assign imm_b = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
assign imm_i = {{20{instruction[31]}}, instruction[31:20]};
assign imm_s = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};


always @(*) begin
    case(opcode)
        OPCODE_LUI: imm = imm_u;
        OPCODE_AUIPC: imm = imm_u;
        OPCODE_JAL: imm = imm_j;
        OPCODE_JALR: imm = imm_i;
        OPCODE_BRANCH: imm = imm_b;
        OPCODE_LOAD: imm = imm_i;
        OPCODE_STORE: imm = imm_s;
        OPCODE_OP_IMM: imm = imm_i;
        OPCODE_OP: imm = 0;
        default: imm = 0;
    endcase
end
endmodule
