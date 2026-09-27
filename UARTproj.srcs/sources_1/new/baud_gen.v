`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/06 18:46:10
// Design Name: 
// Module Name: baud_gen
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


module baud_gen(
    input clk,
    input rst_n,
    input [15:0] baud_div,
    output reg baud_en
    );
    reg [15:0] cnt;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <=16'd0;
            baud_en <=1'b0;
        end
        else begin 
            if (baud_div > 16'd1) begin 
                if (cnt >=(baud_div - 1'b1)) begin 
                    cnt <= 16'd0;
                    baud_en <= 1'b1;
                end
                else begin 
                    cnt <= cnt + 1'b1;
                    baud_en <= 1'b0;
                end
            end
            else begin 
                cnt <=16'd0;
                baud_en <=1'b0;
            end 
        end
    end
endmodule
