`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/07 08:56:07
// Design Name: 
// Module Name: warning_module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 产生报警信号
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module warning_module (
    input             clk,         //50mhz
    input             rst_n,
    input             ALM_N_IN,
    output reg        uart_tx_en,
    output     [31:0] uart_data
);
  assign uart_data = 32'hffff_ffff;
  parameter waring_time_ms = 500;
  localparam time_cnt = 50 * 1000 * waring_time_ms;
  /**********************************/
  reg alm_d0, alm_d1;
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      alm_d0 <= 1'b0;
      alm_d1 <= 1'b0;
    end else begin
      alm_d0 <= ALM_N_IN;
      alm_d1 <= alm_d0;
    end
  end
  wire alm_in;
  assign alm_in = alm_d1;
  /**********************************/
  reg [31:0] alm_cnt;
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) alm_cnt <= 32'd0;
    else if (alm_in && alm_cnt <= time_cnt) alm_cnt <= alm_cnt + 1'd1;
    else alm_cnt <= 32'd0;
  end
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) uart_tx_en <= 1'b0;
    else if (alm_in && alm_cnt == time_cnt - 1) uart_tx_en <= 1'b1;
    else uart_tx_en <= 1'b0;
  end
endmodule
