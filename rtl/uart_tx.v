`timescale 1ns/1ps
module uart_tx #(
    parameter integer CLK_FREQ = 100_000_000,
    parameter integer BAUD_RATE = 115200
)(
    input wire clk, input wire rst,
    input wire [7:0] tx_data, input wire tx_start,
    output reg tx, output reg tx_done
);
    localparam integer DIVISOR = CLK_FREQ / BAUD_RATE;
    localparam [2:0] IDLE=0, START=1, DATA=2, STOP=3, DONE=4;
    reg [2:0] state;
    reg [31:0] baud_count;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    always @(posedge clk) begin
        if (rst) begin
            state<=IDLE; tx<=1'b1; tx_done<=1'b0;
            baud_count<=0; bit_count<=0; shift_reg<=0;
        end else begin
            tx_done<=1'b0;
            case(state)
                IDLE: begin
                    tx<=1'b1; baud_count<=0;
                    if(tx_start) begin shift_reg<=tx_data; state<=START; tx<=1'b0; end
                end
                START: if(baud_count==DIVISOR-1) begin
                    baud_count<=0; bit_count<=0; tx<=shift_reg[0]; state<=DATA;
                end else baud_count<=baud_count+1;
                DATA: if(baud_count==DIVISOR-1) begin
                    baud_count<=0;
                    if(bit_count==7) begin tx<=1'b1; state<=STOP; end
                    else begin bit_count<=bit_count+1; shift_reg<=shift_reg>>1; tx<=shift_reg[1]; end
                end else baud_count<=baud_count+1;
                STOP: if(baud_count==DIVISOR-1) begin
                    baud_count<=0; tx<=1'b1; tx_done<=1'b1; state<=DONE;
                end else baud_count<=baud_count+1;
                DONE: begin state<=IDLE; tx<=1'b1; end
                default: state<=IDLE;
            endcase
        end
    end
endmodule
