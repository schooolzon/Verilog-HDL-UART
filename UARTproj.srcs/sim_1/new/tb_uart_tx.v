`timescale 1ns / 1ps

module tb_uart_tx();
    reg clk;
    reg rst_n;
    reg [15:0] baud_div;
    reg tx_start;
    reg [7:0] tx_data;

    wire baud_en;
    wire tx;
    wire tx_busy;
    wire tx_done;

    baud_gen u_baud_gen (
        .clk(clk),
        .rst_n(rst_n),
        .baud_div(baud_div),
        .baud_en(baud_en)
    );

    uart_tx u_uart_tx (
        .clk(clk),
        .rst_n(rst_n),
        .baud_en(baud_en),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_busy(tx_busy),
        .tx_done(tx_done)
    );

    always #4 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        baud_div = 16'd0;
        tx_start = 0;
        tx_data = 8'h00;

        #45;
        baud_div = 16'd10;
        rst_n = 1;        
        #100;

        @(posedge clk);
        tx_data  = 8'b0101_0101;
        tx_start = 1;      
        @(posedge clk);
        tx_start = 0;

        @(posedge tx_done); 
        #500;               

        @(posedge clk);
        tx_data  = 8'b1010_0101;
        tx_start = 1;
        @(posedge clk);
        tx_start = 0;

        @(posedge tx_done);
        #500;

        $finish;
    end

endmodule
