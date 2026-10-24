`timescale 1ns/1ps
module top #(
    parameter integer CLK_FREQ=100_000_000,
    parameter integer BAUD_RATE=115200,
    parameter integer FIFO_DEPTH=16
)(
    input wire clk, input wire rst, input wire rx, output wire tx
);
    wire baud_tick;
    wire [7:0] rx_data, rx_fifo_data, tx_fifo_data, tx_data;
    wire rx_done, tx_done, rx_full, rx_empty, tx_full, tx_empty;
    wire rx_fifo_wr_en, rx_fifo_rd_en, tx_fifo_wr_en, tx_fifo_rd_en;
    wire tx_start, tx_busy;
    reg tx_start_reg;
    reg [7:0] tx_byte_reg;

    baud_gen #(.CLK_FREQ(CLK_FREQ),.BAUD_RATE(BAUD_RATE)) u_baud
        (.clk(clk),.rst(rst),.baud_tick(baud_tick));
    uart_rx #(.CLK_FREQ(CLK_FREQ),.BAUD_RATE(BAUD_RATE)) u_rx
        (.clk(clk),.rst(rst),.rx(rx),.rx_data(rx_data),.rx_done(rx_done));
    assign rx_fifo_wr_en = rx_done && !rx_full;
    fifo #(.DEPTH(FIFO_DEPTH),.DATA_WIDTH(8)) u_rx_fifo
        (.clk(clk),.rst(rst),.wr_en(rx_fifo_wr_en),.rd_en(rx_fifo_rd_en),
         .data_in(rx_data),.data_out(rx_fifo_data),.full(rx_full),.empty(rx_empty));

    control_fsm u_ctrl(.clk(clk),.rst(rst),.rx_fifo_empty(rx_empty),
        .rx_fifo_rd_en(rx_fifo_rd_en),.rx_fifo_data(rx_fifo_data),
        .tx_fifo_full(tx_full),.tx_fifo_wr_en(tx_fifo_wr_en),.tx_fifo_data(tx_fifo_data));

    fifo #(.DEPTH(FIFO_DEPTH),.DATA_WIDTH(8)) u_tx_fifo
        (.clk(clk),.rst(rst),.wr_en(tx_fifo_wr_en),.rd_en(tx_fifo_rd_en),
         .data_in(tx_fifo_data),.data_out(tx_fifo_data_out),.full(tx_full),.empty(tx_empty));
    wire [7:0] tx_fifo_data_out;
    reg [1:0] tx_state;
    localparam [1:0] T_IDLE=0,T_LOAD=1,T_SEND=2;
    assign tx_fifo_rd_en = (tx_state==T_LOAD) && !tx_empty;
    assign tx_start = tx_start_reg;
    uart_tx #(.CLK_FREQ(CLK_FREQ),.BAUD_RATE(BAUD_RATE)) u_tx
        (.clk(clk),.rst(rst),.tx_data(tx_byte_reg),.tx_start(tx_start),.tx(tx),.tx_done(tx_done));
    always @(posedge clk) begin
        if(rst) begin tx_state<=T_IDLE; tx_start_reg<=0; tx_byte_reg<=0; end
        else begin
            tx_start_reg<=0;
            case(tx_state)
                T_IDLE: if(!tx_empty) tx_state<=T_LOAD;
                T_LOAD: if(!tx_empty) begin tx_byte_reg<=tx_fifo_data_out; tx_start_reg<=1; tx_state<=T_SEND; end
                T_SEND: if(tx_done) tx_state<=T_IDLE;
                default: tx_state<=T_IDLE;
            endcase
        end
    end
endmodule
