module top(
    input clk,
    input btnC,
    output reg [15:0] led
);

wire dmem_wen;
reg ram_wen;
wire [31:0] imem_addr;
wire [31:0] dmem_addr;
wire [31:0] dmem_wdata;
wire [31:0] ram_rdata;
reg [31:0] dmem_rdata;
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


reg clk1hz;
reg [26:0] counter;
always @(posedge clk or posedge btnC) begin
    if(btnC) begin 
        counter <= 0; 
        clk1hz <= 0;
    end
    else if(counter == 49_999_999) begin
        clk1hz <= ~clk1hz;
        counter <= 0;
    end
    else counter <= counter + 1;
end

always @(*) begin
    case(dmem_addr)
        32'h10000000: begin
            dmem_rdata = {16'b0,led};
            ram_wen = 0;
        end
        32'h10000004: begin
            dmem_rdata = {31'b0,clk1hz};
            ram_wen = 0;
        end
        default: begin
            dmem_rdata = ram_rdata;
            ram_wen = dmem_wen;
        end
    endcase
end

endmodule
