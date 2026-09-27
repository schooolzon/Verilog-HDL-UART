`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/07 18:33:13
// Design Name: 
// Module Name: uart_tx
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


module uart_tx(
    input clk,
    input rst_n,
    input baud_en,
    input tx_start,
    input [7:0] tx_data,
    output reg tx,
    output tx_busy,
    output reg tx_done
    );
    
    localparam [1:0] s_idle=2'b00, s_start=2'b01, s_data=2'b10, s_stop=2'b11;
    
    reg [1:0] state;
    reg [3:0] baud_cnt;
    reg [2:0] bit_cnt;
    reg [7:0] tx_shift;
    
    assign tx_busy = (state != s_idle);
    
    always @(posedge clk or negedge rst_n) begin 
        if (!rst_n) begin 
            state <=s_idle;
            baud_cnt <=4'd0;
            bit_cnt <=3'd0;
            tx_shift <=8'd0;
            tx <=1'd1;
            tx_done <=1'b0;
        end
        else begin 
            tx_done <=1'b0;
            
            case (state)
                s_idle: begin 
                    tx <=1'b1;
                    baud_cnt <=4'd0;
                    bit_cnt <=3'd0;
                    if (tx_start) begin 
                        tx_shift <= tx_data;
                        state <=s_start;
                    end
                end
                
                s_start: begin 
                    tx <=1'b0;
                    if (baud_en) begin 
                        if (baud_cnt == 4'd15) begin 
                            baud_cnt <=4'd0;
                            state <=s_data;
                        end
                        else begin 
                            baud_cnt <= baud_cnt +1'b1;
                        end
                    end
                end
                
                s_data: begin 
                    tx <=tx_shift[0];
                    if (baud_en) begin 
                        if (baud_cnt == 4'd15) begin 
                            baud_cnt <=4'd0;
                            tx_shift <= {1'b0, tx_shift[7:1]}; //오른쪽 시프트
                            if (bit_cnt == 3'd7) begin 
                                bit_cnt <= 3'd0;
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
                    tx <=1'b1;
                    if (baud_en) begin 
                        if (baud_cnt == 4'd15) begin 
                            baud_cnt <=4'd0;
                            tx_done <=1'b1;
                            state <=s_idle;
                        end
                        else begin 
                            baud_cnt <= baud_cnt +1'b1;
                        end
                    end
                end
                
                default: state <= s_idle;
            endcase 
        end
    end
    
endmodule
