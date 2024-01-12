`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/11 22:15:28
// Design Name: 
// Module Name: uart_reg_tx_tb
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


module uart_reg_tx_tb;
  // Parameters
  localparam CLK_FRE = 1;
  localparam BPS = 100000;
  localparam REG_WIDTH = 64;

  //Ports
  reg                  clk = 1;
  reg                  rst_n = 0;
  wire                 uart_tx_port;
  reg  [REG_WIDTH-1:0] uart_tx_reg;
  reg                  uart_tx_valid;
  wire                 uart_tx_ready;

  initial begin
    #20 rst_n = 1;
    #20 uart_tx_valid = 1;
    uart_tx_reg = 64'd1;
  end

  uart_reg_tx_module #(
      .CLK_FRE(CLK_FRE),
      .BPS(BPS),
      .REG_WIDTH(REG_WIDTH)
  ) uart_reg_tx_module_inst (
      .clk          (clk),
      .rst_n        (rst_n),
      .uart_tx_port (uart_tx_port),
      .uart_tx_reg  (uart_tx_reg),
      .uart_tx_valid(uart_tx_valid),
      .uart_tx_ready(uart_tx_ready)
  );

  always #5 clk = !clk;




endmodule
