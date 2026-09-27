`timescale 1ns / 1ps

module uart_top (
    input  wire        clk,          // 시스템 클록 (125MHz)
    input  wire        rst_n,        // Active-Low 비동기 리셋
    input  wire [15:0] baud_div,     // 사용자 설정 분주비 = f_clk / (16 * Baud)

    // 송신(TX) 인터페이스
    input  wire        tx_start,     // 송신 시작 펄스 (1클록 폭)
    input  wire [7:0]  tx_data,      // 송신할 8비트 병렬 데이터
    output wire        tx,           // 외부 직렬 출력 핀 (TXD)
    output wire        tx_busy,      // 현재 송신 중 플래그
    output wire        tx_done,      // 송신 완료 펄스 (1클록 폭)

    // 수신(RX) 인터페이스
    input  wire        rx,           // 외부 직렬 수신 핀 (RXD)
    output wire [7:0]  rx_data,      // 수신 완료된 8비트 병렬 데이터
    output wire        rx_done       // 수신 완료 펄스 (1클록 폭)
);

    // 내부 연결 와이어: baud_gen에서 나오는 16배수 틱 펄스
    wire baud_en;

    // 1. Baud Rate Generator 인스턴스화
    baud_gen u_baud_gen (
        .clk(clk),
        .rst_n(rst_n),
        .baud_div(baud_div),
        .baud_en(baud_en)
    );

    // 2. UART Transmitter 인스턴스화
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

    // 3. UART Receiver 인스턴스화
    uart_rx u_uart_rx (
        .clk(clk),
        .rst_n(rst_n),
        .baud_en(baud_en),
        .rx(rx),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

endmodule
