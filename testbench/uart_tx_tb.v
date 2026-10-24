`timescale 1ns/1ps
module uart_tx_tb;
    localparam integer CLK_FREQ=1000000;
    localparam integer BAUD_RATE=100000;
    localparam integer DIV=CLK_FREQ/BAUD_RATE;
    reg clk=0, rst=1, tx_start=0;
    reg [7:0] tx_data=0;
    wire tx, tx_done;
    integer i;
    reg [7:0] expected;
    uart_tx #(.CLK_FREQ(CLK_FREQ),.BAUD_RATE(BAUD_RATE)) dut
        (.clk(clk),.rst(rst),.tx_data(tx_data),.tx_start(tx_start),.tx(tx),.tx_done(tx_done));
    always #5 clk=~clk;

    task send_and_check(input [7:0] value);
        begin
            @(negedge clk); tx_data=value; tx_start=1;
            @(negedge clk); tx_start=0;
            // Start bit is low. Sample near the middle of each bit.
            repeat(DIV/2) @(posedge clk);
            if(tx !== 1'b0) $fatal(1,"Start bit error for %02x",value);
            for(i=0;i<8;i=i+1) begin
                repeat(DIV) @(posedge clk);
                if(tx !== value[i]) $fatal(1,"Data bit %0d mismatch for %02x",i,value);
            end
            repeat(DIV) @(posedge clk);
            if(tx !== 1'b1) $fatal(1,"Stop bit error for %02x",value);
            wait(tx_done===1'b1);
            $display("PASS: UART TX byte %02x",value);
            repeat(2) @(posedge clk);
        end
    endtask

    initial begin
        repeat(4) @(posedge clk); rst=0;
        send_and_check(8'hA5);
        send_and_check(8'h00);
        send_and_check(8'hFF);
        $display("All UART TX tests passed.");
        $finish;
    end
    initial begin #200000; $fatal(1,"Testbench timeout"); end
endmodule
