module top(
    input clk,
    input btnC,
    input rx,
    output reg [15:0] led,
    output tx
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

//uart
wire tx_ready; //HIGH if transmitter is idle and ready, LOW if is currently busy sending bits.
wire rx_valid; //HIGH if data has arrived and is waiting to be read, LOW if no data has arrived
wire [7:0] rx_data;
wire [7:0] tx_data;
wire tx_start;

uart transmitter(
    .clk(clk),
    .rst(btnC),
    .rx(rx),
    .tx(tx),
    .tx_data(tx_data),
    .tx_start(tx_start),
    .rx_data(rx_data),
    .rx_valid(rx_valid),
    .tx_ready(tx_ready)
);
assign tx_data = dmem_wdata[7:0];
assign tx_start = (dmem_addr == 32'h10000008 && dmem_wen) ? 1 : 0;

//1hz clock signal generation
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

//reset behavior and led flashing
always @(posedge clk or posedge btnC) begin
    if (btnC) begin
        led <= 16'b0;
    end
    else if (dmem_addr == 32'h10000000 && dmem_wen) led <= dmem_wdata[15:0]; 
end

//memory mapped peripherals
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
        32'h10000008: begin //data register
            dmem_rdata = {24'b0, tx_data};
            ram_wen = 0;
        end
        32'h1000000C: begin //status register
            dmem_rdata = {30'b0, rx_valid, tx_ready};
            ram_wen = 0;
        end
        default: begin
            dmem_rdata = ram_rdata;
            ram_wen = dmem_wen;
        end
    endcase
end

endmodule
