`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/29 16:27:05
// Design Name: 
// Module Name: tb_Timer_module
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


module tb_Timer_module;

  // Timer_module Parameters
  parameter PERIOD = 10;

  parameter CLK_FRE = 50;
  parameter LOOP = 0;

  // Timer_module Inputs
  reg         clk = 1;
  reg         rst_n = 0;
  reg  [31:0] I_app_wait_us = 10;
  reg         I_app_req = 0;

  // Timer_module Outputs
  wire        O_app_busy;
  wire        O_app_ack;

  wire        O_app_done;
  initial begin
    forever #(PERIOD / 2) clk = ~clk;
  end

  initial begin
    #(PERIOD * 2) rst_n = 1;
    I_app_req = 1;
  end

  Timer_module #(
      .CLK_FRE(CLK_FRE),
      .LOOP   (LOOP)
  ) u_Timer_module (
      .I_Clk         (clk),
      .I_rst_n       (rst_n),
      .I_app_timer_us(I_app_wait_us),
      .I_app_req     (I_app_req),

      .O_app_busy(O_app_busy),
      .O_app_ack (O_app_ack),
      .O_app_done(O_app_done)
  );



endmodule
