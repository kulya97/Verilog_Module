`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/07 09:57:46
// Design Name: 
// Module Name: uart_atb_tb
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


module uart_atb_tb;


  // uart_arb_module Parameters
  parameter PERIOD = 10;


  // uart_arb_module Inputs
  reg         clk = 0;
  reg         rst_n = 0;
  reg         D0_en = 0;
  reg  [31:0] D0_data = 0;
  reg         D1_en = 0;
  reg  [31:0] D1_data = 0;
  reg         D2_en = 0;
  reg  [31:0] D2_data = 0;
  reg         D3_en = 0;
  reg  [31:0] D3_data = 0;

  // uart_arb_module Outputs
  wire        uart_tx_en;
  wire [31:0] uart_tx_data;


  initial begin
    forever #(PERIOD / 2) clk = ~clk;
  end

  initial begin
    #(PERIOD * 2) rst_n = 1;
    /**********************/
    #(PERIOD * 1) D0_en = 1;
    D0_data = 32'h0000_0001;
    D1_en   = 1;
    D1_data = 32'h0001_0001;
    /**********************/
    #(PERIOD * 1) D0_en = 1;
    D0_data = 32'h0000_0002;
    D1_en   = 1;
    D1_data = 32'h0001_0002;
    /**********************/
    #(PERIOD * 1) D0_en = 0;
    D0_data = 32'h0000_0002;
    D1_en   = 1;
    D1_data = 32'h0001_0003;
    /**********************/
    #(PERIOD * 1) D0_en = 0;
    D0_data = 32'h0000_0002;
    D1_en   = 0;
    D1_data = 32'h0001_0002;
  end

  uart_arb_module u_uart_arb_module (
      .clk    (clk),
      .rst_n  (rst_n),
      .D0_en  (D0_en),
      .D0_data(D0_data[31:0]),
      .D1_en  (D1_en),
      .D1_data(D1_data[31:0]),
      .D2_en  (D2_en),
      .D2_data(D2_data[31:0]),
      .D3_en  (D3_en),
      .D3_data(D3_data[31:0]),

      .uart_tx_en  (uart_tx_en),
      .uart_tx_data(uart_tx_data[31:0])
  );

endmodule
