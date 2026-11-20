module uart(
    input clk,
    input rst,
    input rx,
    input [7:0] tx_data,
    input tx_start,
    output reg tx,
    output [7:0] rx_data,
    output reg rx_valid,
    output reg tx_ready
);

reg [9:0] counter_tx;
reg [9:0] counter_rx;
reg [1:0] state_tx;
reg [1:0] state_rx;
reg [2:0] bit_index_tx;
reg [2:0] bit_index_rx;
reg [7:0] tx_buffer;
localparam IDLE = 2'b00;
localparam START = 2'b01;
localparam DATA = 2'b10;
localparam STOP = 2'b11;


//tx bheavior
always @(posedge clk or posedge rst) begin

    if(rst) begin
        state_tx <= IDLE;
        tx <= 1;
        tx_ready <= 1;
        counter_tx <= 0;
        bit_index_tx <= 0;
    end
    else begin
        case(state_tx)
            IDLE: begin
                tx <= 1;
                counter_tx <= 0;
                tx_ready <= 1;
                tx_buffer <= tx_data;
                if(tx_start) begin
                    state_tx <= START;
                    tx_ready <= 0;
                end
            end
            START: begin
                tx <= 0;
                if(counter_tx == 867) begin
                    counter_tx <= 0;
                    state_tx <= DATA;
                end else counter_tx <= counter_tx + 1;
            end
            DATA: begin
                tx <= tx_buffer[bit_index_tx];
                if(counter_tx == 867) begin

                    if(bit_index_tx == 7) begin
                        counter_tx <= 0;
                        bit_index_tx <= 0;
                        state_tx <= STOP;
                    end else begin
                        counter_tx <= 0;
                        bit_index_tx <= bit_index_tx + 1;
                    end
                end else counter_tx <= counter_tx + 1;

            end
            STOP: begin
                tx <= 1;
                if(counter_tx == 867) begin
                    tx_ready <= 1;
                    state_tx <= IDLE;
                end else counter_tx <= counter_tx + 1;
            end
            default: state_tx <= IDLE;
        endcase
end

//rx behavior
always @(posedge clk or posedge rst) begin

    if(rst) begin
        counter_rx <= 0;
        state_rx <= IDLE;
        rx_valid <= 0;
        bit_index_rx <= 0;
    end
    else begin
        case(state_rx)

            IDLE: begin

            end

            START: begin
                if(counter_rx == 433) begin

                end
                else counter_rx <= counter_rx + 1;
            end

            DATA: begin
            end

            STOP: begin
            end



        endcase

end


endmodule

    
