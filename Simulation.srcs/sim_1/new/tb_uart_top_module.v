`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/02/28 09:25:57
// Design Name: 
// Module Name: uart_tb
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


module tb_uart_module;
  reg         CLK_UART_50M;
  reg         RST_N;
  reg         UART_RX;
  wire        UART_TX;
  wire [63:0] UART_REG;
  wire        uart_ready_flag;
  reg  [ 9:0] a1 = {1'b1, 8'h1, 1'b0};
  reg  [ 9:0] a2 = {1'b1, 8'h2, 1'b0};
  reg  [ 9:0] a3 = {1'b1, 8'h3, 1'b0};
  reg  [ 9:0] a4 = {1'b1, 8'h4, 1'b0};
  parameter CLK_FRE = 1;
  localparam CYCLE = CLK_FRE * 1000000 / 115200 * 2;
  integer i;
  initial begin
    CLK_UART_50M = 1;
    RST_N        = 0;
    UART_RX      = 1;
    #200;
    RST_N = 1;
    #20;
    for (i = 0; i < 10; i = i + 1) begin
      UART_RX = a1[i];
      #CYCLE;
    end
    for (i = 0; i < 10; i = i + 1) begin
      UART_RX = a2[i];
      #CYCLE;
    end
    for (i = 0; i < 10; i = i + 1) begin
      UART_RX = a3[i];
      #CYCLE;
    end
    for (i = 0; i < 10; i = i + 1) begin
      UART_RX = a4[i];
      #CYCLE;
    end
    for (i = 0; i < 10; i = i + 1) begin
      UART_RX = a1[i];
      #CYCLE;
    end
    for (i = 0; i < 10; i = i + 1) begin
      UART_RX = a2[i];
      #CYCLE;
    end
    for (i = 0; i < 10; i = i + 1) begin
      UART_RX = a3[i];
      #CYCLE;
    end
    for (i = 0; i < 10; i = i + 1) begin
      UART_RX = a4[i];
      #CYCLE;
    end
    for (i = 0; i < 10; i = i + 1) begin
      UART_RX = a1[i];
      #CYCLE;
    end
    for (i = 0; i < 10; i = i + 1) begin
      UART_RX = a2[i];
      #CYCLE;
    end
    for (i = 0; i < 10; i = i + 1) begin
      UART_RX = a3[i];
      #CYCLE;
    end
    for (i = 0; i < 10; i = i + 1) begin
      UART_RX = a4[i];
      #CYCLE;
    end
    for (i = 0; i < 10; i = i + 1) begin
      UART_RX = a1[i];
      #CYCLE;
    end
    for (i = 0; i < 10; i = i + 1) begin
      UART_RX = a2[i];
      #CYCLE;
    end
    for (i = 0; i < 10; i = i + 1) begin
      UART_RX = a3[i];
      #CYCLE;
    end
    for (i = 0; i < 10; i = i + 1) begin
      UART_RX = a4[i];
      #CYCLE;
    end
    for (i = 0; i < 10; i = i + 1) begin
      UART_RX = a1[i];
      #CYCLE;
    end
    for (i = 0; i < 10; i = i + 1) begin
      UART_RX = a2[i];
      #CYCLE;
    end
    for (i = 0; i < 10; i = i + 1) begin
      UART_RX = a3[i];
      #CYCLE;
    end
    for (i = 0; i < 10; i = i + 1) begin
      UART_RX = a4[i];
      #CYCLE;
    end
  end
  always #1 CLK_UART_50M = ~CLK_UART_50M;

  uart_top_module #(
      .CLK_FRE  (CLK_FRE),
      .REG_WIDTH(64)
  ) uart0 (
      .clk        (CLK_UART_50M),
      .rst_n      (RST_N),
      .uart_rx    (UART_RX),
      .uart_tx    (UART_TX),
      .uart_rx_reg(UART_REG),
      .uart_rx_ack(uart_ready_flag),
      .uart_tx_reg(UART_REG),
      .uart_tx_req(uart_ready_flag)
  );
endmodule
