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
//////////////////////////////////////////////////////////////////////////////////
module uart_reg_tx_module #(
    parameter CLK_FRE   = 50,      //Mhz
    parameter BPS       = 115200,  //uart bps
    parameter REG_WIDTH = 32
) (
    input                  clk,          //system clock 50Mhz on board
    input                  rst_n,        //reset ,low active
    output                 uart_tx,
    input  [REG_WIDTH-1:0] uart_tx_reg,
    input                  uart_tx_req
);

  /*******************************************************************/
  wire [REG_WIDTH-1:0] din;  // input wire [31 : 0] din
  wire                 wr_en;  // input wire wr_en
  wire                 rd_en;  // input wire rd_en
  wire [          7:0] dout;  // output wire [7 : 0] dout
  wire                 full;  // output wire full
  wire                 empty;  // output wire empty
  wire                 valid;

  //写tx fifo数据
  assign wr_en = uart_tx_req;
  assign din   = uart_tx_reg;
  /*********************/
  uart_tx_fifo fifo_tx_inst (
      .clk  (clk),    // input wire clk
      .din  (din),    // input wire [31 : 0] din
      .wr_en(wr_en),  // input wire wr_en
      .rd_en(rd_en),  // input wire rd_en
      .dout (dout),   // output wire [7 : 0] dout
      .full (full),   // output wire full
      .empty(empty)   // output wire empty
  );

  /*******************************************************************/
  wire       tx_data_valid;
  wire       tx_data_ready;
  wire       tx_ack;
  wire [7:0] tx_data;

  assign tx_data       = dout;
  assign tx_data_valid = rd_en;
  assign rd_en         = !empty && tx_data_ready;
  /*********************/
  uart_bit_tx_module #(
      .CLK_FRE  (CLK_FRE),
      .BAUD_RATE(BPS)
  ) u_uart_bit_tx_module (
      .clk          (clk),
      .rst_n        (rst_n),
      .tx_data      (tx_data),
      .tx_data_valid(tx_data_valid),
      .tx_data_ready(tx_data_ready),
      .tx_ack       (tx_ack),
      .tx_pin       (uart_tx)
  );
endmodule
