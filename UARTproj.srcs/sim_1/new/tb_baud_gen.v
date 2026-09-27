`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/06 18:56:22
// Design Name: 
// Module Name: tb_baud_gen
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


module tb_baud_gen();
    reg clk;
    reg rst_n;
    reg [15:0] baud_div;
    wire baud_en;
    
    baud_gen uut(
        .clk(clk),
        .rst_n(rst_n),
        .baud_div(baud_div),
        .baud_en(baud_en)
    );
    
    always #4 clk = ~clk;
    
    initial begin
        clk =0;
        rst_n =0;
        baud_div =16'd0;
        
        #20; rst_n =1;
        #20;
        baud_div =16'd10;
        #1000;
        
        baud_div =16'd68;
        #5000;
        
        rst_n =0;
        #50;
        rst_n =1;
        #2000;
        
        $finish;
    end
endmodule
