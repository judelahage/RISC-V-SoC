module uart(
    input clk,
    input rst,
    input rx,
    input [7:0] tx_data,
    input tx_start,
    output reg tx,
    output [7:0] rx_data,
    output rx_valid,
    output reg tx_ready
);

reg [9:0] counter;
reg [1:0] state;
reg [2:0] bit_index;
reg [7:0] tx_buffer;
localparam IDLE = 2'b00;
localparam START = 2'b01;
localparam DATA = 2'b10;
localparam STOP = 2'b11;

always @(posedge clk or posedge rst) begin

    if(rst) begin
        state <= IDLE;
        tx <= 1;
        tx_ready <= 1;
        counter <= 0;
        bit_index <= 0;
    end
    else begin
        case(state)
            IDLE: begin
                tx <= 1;
                counter <= 0;
                tx_ready <= 1;
                tx_buffer <= tx_data;
                if(tx_start) begin
                    state <= START;
                    tx_ready <= 0;
                end
            end
            START: begin
                tx <= 0;
                if(counter == 867) begin
                    counter <= 0;
                    state <= DATA;
                end else counter <= counter + 1;
            end
            DATA: begin
                tx <= tx_buffer[bit_index];
                if(counter == 867) begin

                    if(bit_index == 7) begin
                        counter <= 0;
                        bit_index <= 0;
                        state <= STOP;
                    end else begin
                        counter <= 0;
                        bit_index <= bit_index + 1;
                    end
                end else counter <= counter + 1;

            end
            STOP: begin
                tx <= 1;
                if(counter == 867) begin
                    tx_ready <= 1;
                    state <= IDLE;
                end else counter <= counter + 1;
            end
            default: state <= IDLE;
        endcase
end 

endmodule

    
