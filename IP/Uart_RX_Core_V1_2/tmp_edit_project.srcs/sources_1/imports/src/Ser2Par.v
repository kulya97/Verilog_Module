`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NJUST
// Engineer: huangwenjie
// 
// Create Date: 2023/06/15 09:49:05
// Design Name: 
// Module Name: Ser2Par
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


module Ser2Par #(
    parameter SERWIDTH = 8,
    parameter PARWIDTH = 32
) (
    input                     clk,
    input                     rst_n,
    input                     wr_en,
    input      [SERWIDTH-1:0] din,
    output reg                dack,
    output reg [PARWIDTH-1:0] dout
);
  /**************************************************************/
  //接收数据
  reg [PARWIDTH-1:0] r_din;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      r_din <= 'd0;
    end else if (wr_en) begin
      r_din <= {r_din, din};
    end else begin
      r_din <= r_din;
    end
  end
  /**************************************************************/
  //计数
  reg [15:0] data_cnt;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      data_cnt <= 'd0;
    end else if (wr_en) begin
      data_cnt <= data_cnt + SERWIDTH;
    end else if (data_cnt == PARWIDTH) begin
      data_cnt <= 'd0;
    end else data_cnt <= data_cnt;
  end
  /**************************************************************/
  //生成信号
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      dout <= 'd0;
      dack <= 'd0;
    end else if (data_cnt == PARWIDTH) begin
      dout <= r_din;
      dack <= 'd1;
    end else begin
      dout <= dout;
      dack <= 'd0;
    end
  end
endmodule
