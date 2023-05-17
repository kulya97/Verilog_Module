`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/22 10:36:30
// Design Name: 
// Module Name: uart_delay_tb
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


module uart_delay_tb;
  // uart_reg_delay_module Parameters
  parameter PERIOD = 10;
  parameter MS_CNT = 5;

  // uart_reg_delay_module Inputs
  reg         clk = 0;
  reg         rst_n = 0;
  reg  [15:0] app_delay_ms = 10;
  reg  [15:0] app_wait_ms = 1;
  reg  [31:0] reg_in = 0;
  reg         reg_valid = 0;

  // uart_reg_delay_module Outputs
  wire [31:0] reg_out;
  wire        reg_ready;


  initial begin
    forever #(PERIOD / 2) clk = ~clk;
  end

  initial begin
    #(PERIOD * 2) rst_n = 1;
    #(PERIOD * 100) reg_valid = 1;
    reg_in = 32'habcd_0001;
    #(PERIOD * 1) reg_in = 32'habc1_0002;
    #(PERIOD * 1) reg_in = 32'habc2_0003;
    #(PERIOD * 1) reg_in = 32'habc1_0004;
    #(PERIOD * 1) reg_in = 32'habc2_0005;
    #(PERIOD * 1) reg_in = 32'habcd_0006;
    #(PERIOD * 1) reg_in = 32'habcd_0007;
    #(PERIOD * 1) reg_in = 32'habcd_0008;
    #(PERIOD * 1) reg_in = 32'habc1_0009;
    #(PERIOD * 1) reg_in = 32'habc2_000a;
    #(PERIOD * 1) reg_valid = 0;
  end

  uart_reg_delay_module #(
      .MS_CNT(MS_CNT)
  ) u_uart_reg_delay_module (
      .clk      (clk),
      .rst_n    (rst_n),
      .reg_in   (reg_in[31:0]),
      .reg_valid(reg_valid),
      .reg_out  (reg_out[31:0]),
      .reg_ready(reg_ready)
  );



endmodule
