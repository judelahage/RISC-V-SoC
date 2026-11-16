module core(
    input clk, //input from outside
    input rst, //input from outside
    input [31:0] imem_rdata, //input from imem
    input [31:0] dmem_rdata, //input from dmem
    
    output [31:0] imem_addr, //output to imem
    output [31:0] dmem_addr, //output to dmem
    output [31:0] dmem_wdata, //output to dmem
    output dmem_wen //output to dmem
);

//beginning with instruction fetch stage

//next pc can either be pc+4 if sequential or it can be pc+immediate if jumping or banching
wire [31:0] pc_current;
wire [31:0] PCplus4;
wire [31:0] PCtarget;
wire [31:0] imm;
assign PCplus4 = pc_current + 4;
assign PCtarget = pc_current + imm; //pc_current gets its value from the PCreg module


wire [31:0] pc_next;
wire branch;
wire jump;
wire zero_flag;

wire pc_next_select; //if pc_next_select is 1 then next_pc is pc+imm but if its 0 then next_pc is pc+4 
assign pc_next_select = (zero_flag & branch) | jump;
assign pc_next = (pc_next_select) ? PCtarget : PCplus4;


assign imem_addr = (rst) ? 0 : pc_next; 
PCreg pc(.clk(clk), .rst(rst), .pc_next(imem_addr), .pc(pc_current));


wire [4:0] rs2;
wire [4:0] rs1;
wire [4:0] rd; 
wire [2:0] funct3;
wire [6:0] funct7;
wire [6:0] opcode;
instr_decoder inst_dec(
    .instruction(imem_rdata),
    .rs2(rs2),
    .rs1(rs1),
    .rd(rd),
    .funct3(funct3),
    .funct7(funct7),
    .opcode(opcode),
    .imm(imm)
);

reg [31:0] write_data;
wire [31:0] read_data2;
wire [31:0] alu_input_first;
wire reg_write_enable;


regfile register_file(
    .write_data(write_data),
    .write_enable(reg_write_enable),
    .read_data(alu_input_first),
    .read_data2(read_data2),
    .clk(clk),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd)

);

wire [1:0] rd_src_select;
wire [31:0] alu_result;
wire alu_src;
wire [3:0] alu_control;

control_unit ctrl_u(
    .funct3(funct3),
    .funct7(funct7),
    .opcode(opcode),
    .reg_write_enable(reg_write_enable),
    .mem_write_enable(dmem_wen),
    .alu_src(alu_src),
    .rd_src_select(rd_src_select),
    .alu_control(alu_control),
    .branch(branch),
    .jump(jump)
);

//second alu input is determined after control unit since we need to figure out where its going to come from
wire [31:0] alu_input_second;
assign alu_input_second = (alu_src) ? imm : read_data2;

arithmetic_logic_unit alu(
    .alu_control(alu_control),
    .a(alu_input_first), .b(alu_input_second),
    .result(alu_result),
    .zero_flag(zero_flag)
);



localparam RESULT_MEMORY = 2'b01;
localparam RESULT_ALU = 2'b00;
localparam RESULT_PC4 = 2'b10;
localparam RESULT_IMM = 2'b11;
always @(*) begin
    case(rd_src_select)
        RESULT_MEMORY: write_data = dmem_rdata;
        RESULT_ALU: write_data = alu_result;
        RESULT_PC4: write_data = PCplus4;
        RESULT_IMM: write_data = imm;
        default: write_data = dmem_rdata;
    endcase
end

assign dmem_addr = alu_result; //this gets alu_result because the alu calculates rs1+imm whenever we do a lw or a sw instruction to calculate mem address
assign dmem_wdata = read_data2; //this gets read_data2 which is basically the contents of rs2 since in a sw instruction (storing to memory) rs2 is the data that gets written and rs1+offset is the address

endmodule