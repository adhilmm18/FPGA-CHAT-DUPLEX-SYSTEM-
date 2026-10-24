`timescale 1ns/1ps
module fifo #(
    parameter integer DEPTH=16,
    parameter integer DATA_WIDTH=8
)(
    input wire clk, input wire rst,
    input wire wr_en, input wire rd_en,
    input wire [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out,
    output wire full, output wire empty
);
    localparam integer PTR_WIDTH = (DEPTH <= 2) ? 1 : $clog2(DEPTH);
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    reg [PTR_WIDTH-1:0] wr_ptr, rd_ptr;
    reg [PTR_WIDTH:0] count;
    assign full = (count == DEPTH);
    assign empty = (count == 0);
    always @(posedge clk) begin
        if(rst) begin wr_ptr<=0; rd_ptr<=0; count<=0; data_out<=0; end
        else begin
            case ({wr_en && !full, rd_en && !empty})
                2'b10: begin mem[wr_ptr]<=data_in; wr_ptr <= (wr_ptr==DEPTH-1)?0:wr_ptr+1'b1; count<=count+1'b1; end
                2'b01: begin data_out<=mem[rd_ptr]; rd_ptr <= (rd_ptr==DEPTH-1)?0:rd_ptr+1'b1; count<=count-1'b1; end
                2'b11: begin mem[wr_ptr]<=data_in; data_out<=mem[rd_ptr]; wr_ptr <= (wr_ptr==DEPTH-1)?0:wr_ptr+1'b1; rd_ptr <= (rd_ptr==DEPTH-1)?0:rd_ptr+1'b1; end
                default: ;
            endcase
        end
    end
endmodule
