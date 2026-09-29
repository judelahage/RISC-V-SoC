module control_unit(

    input [2:0] funct3,
    input [6:0] funct7,
    input [6:0] opcode,
    output reg reg_write_enable,
    output reg mem_write_enable,
    output reg alu_src, //determines whether we pass rs2 or an imm to the alu -> 0 for rs2, 1 for imm
    output reg [1:0] result_src, //determines whether destination register reads alu result, data memory, or PC+4 for jumps
    output reg [3:0] alu_control, //determines what mathematical or logical operation alu should do
    output reg branch, //lets the PC know it should jump to PC+imm if a condition is true
    output reg jump //lets the PC know it should jump not just increment by 4
);

//destination register can read from these sources
localparam RESULT_MEMORY = 2'b01;
localparam RESULT_ALU = 2'b00;
localparam RESULT_PC4 = 2'b10;
localparam RESULT_IMM = 2'b11;

//ALU select
localparam ALU_ADD = 4'b0000;
localparam ALU_SUB = 4'b0001;
localparam ALU_AND = 4'b0011;
localparam ALU_OR = 4'b0111;
localparam ALU_XOR = 4'b1111;
localparam ALU_SLL = 4'b1110;
localparam ALU_SRL = 4'b1100;
localparam ALU_SRA = 4'b1000;
localparam ALU_SLT = 4'b1001;
localparam ALU_SLTU = 4'b1011;

//Opcodes
localparam OPCODE_LUI = 7'b0110111;
localparam OPCODE_AUIPC = 7'b0010111;
localparam OPCODE_JAL = 7'b1101111;
localparam OPCODE_JALR = 7'b1100111;
localparam OPCODE_BRANCH = 7'b1100011;
localparam OPCODE_LOAD = 7'b0000011;
localparam OPCODE_STORE = 7'b0100011;
localparam OPCODE_OP_IMM = 7'b0010011;
localparam OPCODE_OP = 7'b0110011;

//funct3 ----note that these funct3 codes are also the same for ADD, SLT, SLTU, XOR, (basically all the non imm instructions)
localparam FUNCT3_ADD_SUB = 3'b000;
localparam FUNCT3_SLT = 3'b010;
localparam FUNCT3_SLTU = 3'b011;
localparam FUNCT3_XOR = 3'b100;
localparam FUNCT3_OR = 3'b110;
localparam FUNCT3_AND = 3'b111;
localparam FUNCT3_SLL = 3'b001;
localparam FUNCT3_SRL_SRA = 3'b101;


always@(*) begin

    //defaults---------------
    branch = 0;
    jump = 0;
    reg_write_enable = 0;
    mem_write_enable = 0;
    alu_src = 0;
    result_src = RESULT_ALU;
    alu_control = ALU_ADD;
    //defaults----------------
    case(opcode)
        OPCODE_LUI: begin
            result_src = RESULT_IMM;
            reg_write_enable=1;
        end
        OPCODE_AUIPC: begin
            result_src = RESULT_ALU;
            reg_write_enable=1;
            alu_src = 1; //we are feeding an immediate into the alu not rs2. 
            alu_control = ALU_ADD;
        end

        OPCODE_JAL: begin
            result_src=RESULT_PC4; //saves next pc into rd so that it can return after jumping
            reg_write_enable=1; //we are writing into rd so we need to enable
            jump = 1;
        end

        OPCODE_JALR: begin
            result_src=RESULT_PC4; //saves next pc into rd so that it can return after jumping
            reg_write_enable=1; //we are writing into rd so we need to enable
            jump = 1;
            alu_src = 1; //target jump address is rs1 + imm so we need to send alu an imm
            alu_control = ALU_ADD; //target jump address is rs1 + imm so we are adding
        end

        OPCODE_BRANCH: begin
            reg_write_enable=0;
            branch = 1;
            alu_src = 0; //for branching we need to feed rs2 into the alu not an immediate
            alu_control = ALU_SUB; //we are subtracting to see if the result is positive or negative, this tells us greater or less than
        end 

        OPCODE_LOAD: begin
            result_src=RESULT_MEMORY; //rd is getting something from memory, not the alu and not the next pc inc.
            reg_write_enable=1;
            alu_src = 1; //calculating memory address is rs1 + imm so we need to send alu an imm
            alu_control = ALU_ADD; //adding rs1 + imm so alu needs to add
        end

        OPCODE_STORE: begin
            mem_write_enable=1;
            alu_src = 1; //calculatin memory adress is rs1 + imm so we need to send alu an imm
            alu_control = ALU_ADD; //adding rs1 + imm so alu needs to add
        end
        OPCODE_OP_IMM: begin
            result_src=RESULT_ALU;
            reg_write_enable=1;
            alu_src = 1; //we are feeding an immediate to the alu not rs2
            case(funct3)
                FUNCT3_ADD_SUB: alu_control = ALU_ADD; //there is no SUBI so we don't need to do a funct7 check here
                FUNCT3_SLT: alu_control = ALU_SLT;
                FUNCT3_SLTU: alu_control = ALU_SLTU;
                FUNCT3_XOR: alu_control = ALU_XOR;
                FUNCT3_OR: alu_control = ALU_OR;
                FUNCT3_AND: alu_control = ALU_AND;
                FUNCT3_SLL: alu_control = ALU_SLL;
                FUNCT3_SRL_SRA: alu_control = (funct7[5]) ? ALU_SRA : ALU_SRL;
            endcase
        end

        OPCODE_OP: begin
            result_src=RESULT_ALU;
            reg_write_enable=1;
            alu_src = 0; //we are feeding rs2 to the alu not an immediate
            case(funct3)
                FUNCT3_ADD_SUB: alu_control = (funct7[5]) ? ALU_SUB : ALU_ADD;
                FUNCT3_SLT: alu_control = ALU_SLT;
                FUNCT3_SLTU: alu_control = ALU_SLTU;
                FUNCT3_XOR: alu_control = ALU_XOR;
                FUNCT3_OR: alu_control = ALU_OR;
                FUNCT3_AND: alu_control = ALU_AND;
                FUNCT3_SLL: alu_control = ALU_SLL;
                FUNCT3_SRL_SRA: alu_control = (funct7[5]) ? ALU_SRA : ALU_SRL;
            endcase
        end

        default:
    endcase

    
end

endmodule