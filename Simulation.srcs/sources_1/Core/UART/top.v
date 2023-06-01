`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/30 20:12:05
// Design Name: 
// Module Name: top
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


module top (
    input  sys_clk,   // 系统时钟输入
    input  sys_rstn,  // 系统复位，低电平有效
    output O_led0,
    output O_led1,
    output O_led2,
    output O_led3,
    input  UART_RX,
    output UART_TX

);
  /*****************************************/
  wire clk_uart_50m;
  wire RST_N;
  wire locked;
  /*****************************************/
  sys_pll u_sys_pll (
      .areset(!sys_rstn),
      .inclk0(sys_clk),

      .c0    (clk_uart_50m),
      .locked(locked)
  );

  assign RST_N = sys_rstn && locked;
  /*****************************************/
  parameter CLK_FRE = 50;  //Mhz
  parameter BPS = 115200;  //uart bps
  parameter IDLE_CYCLE = 20;  //idle time
  parameter REG_WIDTH = 32;

  wire [REG_WIDTH-1:0] UART_REG;
  wire                 UART_REG_ACK;
  /*****************************************/
  uart_top_module #(
      .CLK_FRE   (CLK_FRE),
      .BPS       (BPS),
      .IDLE_CYCLE(IDLE_CYCLE),
      .REG_WIDTH (REG_WIDTH)
  ) u_uart_top_module (
      .clk        (clk_uart_50m),
      .rst_n      (RST_N),
      .uart_rx    (UART_RX),
      .uart_tx_reg(UART_REG[REG_WIDTH-1:0]),
      .uart_tx_req(UART_REG_ACK),

      .uart_tx    (UART_TX),
      .uart_rx_reg(UART_REG[REG_WIDTH-1:0]),
      .uart_rx_ack(UART_REG_ACK)
  );
  /*****************************************/

endmodule
