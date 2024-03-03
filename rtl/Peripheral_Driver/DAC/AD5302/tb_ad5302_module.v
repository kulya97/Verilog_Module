`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/27 16:41:33
// Design Name: 
// Module Name: tb_ad5302_module
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


module tb_ad5302_module;

  // ad5302_module Parameters
  parameter PERIOD = 10;

  // ad5302_module Inputs
  reg         clk = 0;
  reg         rst_n = 0;
  reg  [31:0] uart_reg = 0;
  reg         uart_ready = 0;
  reg         channel = 0;
  // ad5302_module Outputs
  wire        DSYNC0_N;
  wire        DSYNC1_N;
  wire        DCLK;
  wire        DIN;
  wire        DLDAC_N;


  initial begin
    forever #(PERIOD / 2) clk = ~clk;
  end

  initial begin
    #(PERIOD * 2) rst_n = 1;
    #(PERIOD * 2000) uart_ready = 1;
    uart_reg = 32'hdac0_1234;
    #(PERIOD * 1) uart_ready = 0;
    #(PERIOD * 2000) uart_ready = 1;
    uart_reg = 32'hdac1_1235;
    #(PERIOD * 1) uart_ready = 0;
  end

  ad5302_module u_ad5302_module (
      .clk       (clk),
      .rst_n     (rst_n),
      .uart_reg  (uart_reg[31:0]),
      .uart_ready(uart_ready),
      .DSYNC0_N  (DSYNC0_N),
      .DSYNC1_N  (DSYNC1_N),
      .DCLK      (DCLK),
      .DIN       (DIN),
      .DLDAC_N   (DLDAC_N)
  );

endmodule
