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


PCreg pc(.clk(clk), .rst(rst), .pc_next(....), .pc(....));

control_unit ctrl_u(
    .funct3(....),
    .funct7(....),
    .opcode(....),
    .reg_write_enable(....),
    .mem_write_enable(....),
    .alu_src(....),
    .result_src(....),
    .alu_control(....),
    .branch(....),
    .jump(....)
);

arithmetic_logic_unit alu(
    .alu_control(....),
    .a(....), .b(.....),
    .result(....),
    .zero_flag(....)
);

instr_decoder inst_dec(
    .instruction(....),
    .rs2(....),
    .rs1(....),
    .rd(....),
    .funct3(....),
    .funct7(....),
    .opcode(....),
    .imm(....)
);

regfile register_file(
    .write_data(....),
    .write_enable(....),
    .read_data(....),
    .read_data2(....),
    .clk(....),
    .rs1(....),
    .rs2(....),
    .rd(....),
    
);