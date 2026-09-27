`timescale 1ns / 1ps

module tb_uart_top();

    reg         clk;
    reg         rst_n;
    reg  [15:0] baud_div;
    reg         tx_start;
    reg  [7:0]  tx_data;

    wire        tx;          // 송신 출력 핀
    wire        rx;          // 수신 입력 핀
    wire        tx_busy;
    wire        tx_done;
    wire [7:0]  rx_data;
    wire        rx_done;

    // -------------------------------------------------------------
    // 핵심: 루프백(Loopback) 연결!
    // tx 출력을 rx 입력선으로 바로 연결합니다.
    // -------------------------------------------------------------
    assign rx = tx;

    // DUT: 최상위 모듈 uart_top 인스턴스화
    uart_top uut_top (
        .clk(clk),
        .rst_n(rst_n),
        .baud_div(baud_div),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_busy(tx_busy),
        .tx_done(tx_done),
        .rx(rx),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    // 125MHz 클록 생성 (주기 8ns = #4 High, #4 Low)
    always #4 clk = ~clk;

    initial begin
        // 1. 시스템 초기화 및 안전한 리셋
        clk      = 0;
        rst_n    = 0;
        baud_div = 16'd0;
        tx_start = 0;
        tx_data  = 8'h00;

        #45;
        rst_n = 1; // 리셋 해제
        #100;

        // =============================================================
        // [테스트 1] 분주비 10 (고속 모드): 8'h55 송수신 루프백 검증
        // =============================================================
        baud_div = 16'd10;
        #100;

        @(posedge clk);
        tx_data  = 8'h55;
        tx_start = 1;      // 송신 시작 트리거
        @(posedge clk);
        tx_start = 0;

        // 수신기가 8'h55 수신을 끝마칠 때(rx_done 펄스)까지 대기
        @(posedge rx_done);
        #500;              // 프레임 간 여유 대기

        // =============================================================
        // [테스트 2] 교수님 요구사항 검증: 실시간 분주비 변경!
        // baud_div = 68 (125MHz 기준 표준 115200 bps): 8'hA5 송수신 검증
        // =============================================================
        baud_div = 16'd68; // 런타임 속도 변경
        #500;

        @(posedge clk);
        tx_data  = 8'hA5;
        tx_start = 1;
        @(posedge clk);
        tx_start = 0;

        @(posedge rx_done);
        #1000;

        $finish; // 시뮬레이션 종료 및 파형 확인
    end

endmodule
