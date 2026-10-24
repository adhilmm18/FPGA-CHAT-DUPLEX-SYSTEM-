`timescale 1ns/1ps
// Reconstructed controller: moves one byte from RX FIFO to TX FIFO.
module control_fsm(
    input wire clk, input wire rst,
    input wire rx_fifo_empty, output reg rx_fifo_rd_en,
    input wire [7:0] rx_fifo_data,
    input wire tx_fifo_full, output reg tx_fifo_wr_en,
    output reg [7:0] tx_fifo_data
);
    localparam [1:0] IDLE=0, READ_WAIT=1, WRITE_TX=2;
    reg [1:0] state;
    reg [7:0] held_byte;
    always @(posedge clk) begin
        if(rst) begin state<=IDLE; rx_fifo_rd_en<=0; tx_fifo_wr_en<=0; tx_fifo_data<=0; held_byte<=0; end
        else begin
            rx_fifo_rd_en<=0; tx_fifo_wr_en<=0;
            case(state)
                IDLE: if(!rx_fifo_empty) begin rx_fifo_rd_en<=1; state<=READ_WAIT; end
                READ_WAIT: begin held_byte<=rx_fifo_data; state<=WRITE_TX; end
                WRITE_TX: if(!tx_fifo_full) begin tx_fifo_data<=held_byte; tx_fifo_wr_en<=1; state<=IDLE; end
                default: state<=IDLE;
            endcase
        end
    end
endmodule
