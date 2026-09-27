`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/15 18:50:18
// Design Name: 
// Module Name: tb_uart_rx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_uart_rx();
    reg clk;
    reg rst_n;
    reg [15:0] baud_div;
    reg rx;
    
    wire baud_en;
    wire [7:0] rx_data;
    wire rx_done;
    
    baud_gen u_baud_gen (
        .clk(clk),
        .rst_n(rst_n),
        .baud_div(baud_div),
        .baud_en(baud_en)
    );

    uart_rx u_uart_rx (
        .clk(clk),
        .rst_n(rst_n),
        .baud_en(baud_en),
        .rx(rx),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );
    
    always #4 clk = ~clk;
    
    localparam bit_time = 1280;
    
    initial  begin 
        clk =0;
        rst_n =0;
        baud_div =16'd0;
        rx =1'b1;
        
        #45;
        baud_div =16'd10;
        rst_n =1;
        
        //0101_0101
        rx = 1'b0; #(bit_time); //startbit
        rx = 1'b1; #(bit_time); //LSB
        rx = 1'b0; #(bit_time); 
        rx = 1'b1; #(bit_time); 
        rx = 1'b0; #(bit_time); 
        rx = 1'b1; #(bit_time); 
        rx = 1'b0; #(bit_time); 
        rx = 1'b1; #(bit_time); 
        rx = 1'b0; #(bit_time); //MSB
        rx = 1'b1; #(bit_time); //stopbit
        
        #1000;
        
        //1010_0101
        rx = 1'b0; #(bit_time); //startbit
        rx = 1'b1; #(bit_time); //LSB
        rx = 1'b0; #(bit_time); 
        rx = 1'b1; #(bit_time); 
        rx = 1'b0; #(bit_time); 
        rx = 1'b0; #(bit_time); 
        rx = 1'b1; #(bit_time); 
        rx = 1'b0; #(bit_time); 
        rx = 1'b1; #(bit_time); //MSB
        rx = 1'b1; #(bit_time); //stopbit
        
        #1000;
        $finish;
    end
endmodule
