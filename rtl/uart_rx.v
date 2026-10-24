`timescale 1ns/1ps
module uart_rx #(
    parameter integer CLK_FREQ = 100_000_000,
    parameter integer BAUD_RATE = 115200
)(
    input wire clk, input wire rst, input wire rx,
    output reg [7:0] rx_data, output reg rx_done
);
    localparam integer DIVISOR = CLK_FREQ / BAUD_RATE;
    localparam integer HALF_DIV = DIVISOR/2;
    localparam [1:0] IDLE=0, START=1, DATA=2, STOP=3;
    reg [1:0] state;
    reg [31:0] baud_count;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg rx_meta, rx_sync;
    always @(posedge clk) begin rx_meta<=rx; rx_sync<=rx_meta; end
    always @(posedge clk) begin
        if(rst) begin state<=IDLE; baud_count<=0; bit_count<=0; shift_reg<=0; rx_data<=0; rx_done<=0; end
        else begin
            rx_done<=1'b0;
            case(state)
                IDLE: begin baud_count<=0; bit_count<=0; if(!rx_sync) state<=START; end
                START: if(baud_count==HALF_DIV) begin
                    baud_count<=0;
                    if(!rx_sync) state<=DATA; else state<=IDLE;
                end else baud_count<=baud_count+1;
                DATA: if(baud_count==DIVISOR-1) begin
                    baud_count<=0; shift_reg[bit_count]<=rx_sync;
                    if(bit_count==7) state<=STOP; else bit_count<=bit_count+1;
                end else baud_count<=baud_count+1;
                STOP: if(baud_count==DIVISOR-1) begin
                    baud_count<=0; rx_data<=shift_reg;
                    if(rx_sync) rx_done<=1'b1;
                    state<=IDLE;
                end else baud_count<=baud_count+1;
                default: state<=IDLE;
            endcase
        end
    end
endmodule
