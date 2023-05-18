`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/04 21:15:15
// Design Name: 
// Module Name: 
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
module uart_top_module #(
    parameter CLK_FRE    = 50,      //Mhz
    parameter BPS        = 115200,  //uart bps
    parameter IDLE_CYCLE = 20,      //idle time
    parameter REG_WIDTH  = 32
) (
    input                  clk,          //system clock 50Mhz on board
    input                  rst_n,        //reset ,low active
    input                  uart_rx,
    output                 uart_tx,
    output [REG_WIDTH-1:0] uart_rx_reg,  //uart reg 
    output                 uart_rx_ack,  //if update ready=1
    input  [         31:0] uart_tx_reg,
    input                  uart_tx_req
);

  uart_reg_tx_module #(
      .CLK_FRE   (CLK_FRE),
      .BPS       (BPS),
      .IDLE_CYCLE(IDLE_CYCLE),
      .REG_WIDTH (REG_WIDTH)
  ) u_uart_reg_tx_module (
      .clk        (clk),
      .rst_n      (rst_n),
      .uart_tx_reg(uart_tx_reg[REG_WIDTH-1:0]),
      .uart_tx_req(uart_tx_req),

      .uart_tx(uart_tx)
  );

  uart_reg_rx_module #(
      .CLK_FRE   (CLK_FRE),
      .BPS       (BPS),
      .IDLE_CYCLE(IDLE_CYCLE),
      .REG_WIDTH (REG_WIDTH)
  ) u_uart_reg_rx_module (
      .clk    (clk),
      .rst_n  (rst_n),
      .uart_rx(uart_rx),

      .uart_rx_reg(uart_rx_reg[REG_WIDTH-1:0]),
      .uart_rx_ack(uart_rx_ack)
  );
endmodule
