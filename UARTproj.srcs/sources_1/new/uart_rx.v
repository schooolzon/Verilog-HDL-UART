`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/15 18:09:23
// Design Name: 
// Module Name: uart_rx
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


module uart_rx(
    input clk,
    input rst_n,
    input baud_en,
    input rx,
    output reg [7:0] rx_data,
    output reg rx_done
    );
    
    localparam [1:0] s_idle=2'b00, s_start=2'b01, s_data=2'b10, s_stop=2'b11;
    
    reg [1:0] state;
    reg [3:0] baud_cnt;
    reg [2:0] bit_cnt;
    reg [7:0] rx_shift;
    
    reg rx_reg1, rx_reg2;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin 
            rx_reg1 <=1'b1;
            rx_reg2 <=1'b1;
        end
        else begin 
            rx_reg1 <=rx;
            rx_reg2 <=rx_reg1;
        end
    end
    
    always @(posedge clk or negedge rst_n) begin 
        if (!rst_n) begin 
            state <=s_idle;
            baud_cnt <=4'd0;
            bit_cnt <=3'd0;
            rx_shift <=8'd0;
            rx_data <=8'd0;
            rx_done <=1'b0;
        end
        else begin 
            rx_done <=1'b0;
            
            case (state)
                s_idle: begin 
                    baud_cnt <=4'd0;
                    bit_cnt <=3'd0;
                    if (rx_reg2 == 1'b0) begin 
                        state <=s_start;
                    end
                end
                
                s_start: begin 
                    if (baud_en) begin 
                        if (baud_cnt == 4'd7) begin 
                            if (rx_reg2 == 1'b0) begin 
                                baud_cnt <=4'd0;
                                state <=s_data;
                            end
                            else begin
                                state <=s_idle;
                            end
                        end
                        else begin 
                            baud_cnt <= baud_cnt +1'b1;
                        end
                    end
                end
                
                s_data: begin 
                    if (baud_en) begin 
                        if (baud_cnt == 4'd15) begin 
                            baud_cnt <=4'd0;
                            rx_shift <= {rx_reg2, rx_shift[7:1]};
                            if (bit_cnt == 3'd7) begin 
                                bit_cnt <=3'd0;
                                state <=s_stop;
                            end
                            else begin 
                                bit_cnt <= bit_cnt +1'b1;
                            end
                        end
                        else begin 
                            baud_cnt <= baud_cnt +1'b1;
                        end
                    end
                end
                
                s_stop: begin 
                    if (baud_en) begin 
                        if (baud_cnt == 4'd15) begin 
                            baud_cnt <=4'd0;
                            if (rx_reg2 == 1'b1) begin 
                                rx_data <=rx_shift;
                                rx_done <=1'b1;
                            end
                            state <=s_idle;
                        end
                        else begin 
                            baud_cnt <= baud_cnt +1'b1;
                        end
                    end
                end

                default: state <=s_idle;
            endcase 
        end
    end
    
endmodule
