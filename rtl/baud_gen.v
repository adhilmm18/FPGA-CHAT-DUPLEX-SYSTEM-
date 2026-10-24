`timescale 1ns/1ps
module baud_gen #(
    parameter integer CLK_FREQ = 100_000_000,
    parameter integer BAUD_RATE = 115200
)(
    input wire clk,
    input wire rst,
    output reg baud_tick
);
    localparam integer DIVISOR = CLK_FREQ / BAUD_RATE;
    reg [31:0] count;
    always @(posedge clk) begin
        if (rst) begin count <= 0; baud_tick <= 1'b0; end
        else if (count >= DIVISOR-1) begin count <= 0; baud_tick <= 1'b1; end
        else begin count <= count + 1'b1; baud_tick <= 1'b0; end
    end
endmodule
