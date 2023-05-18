`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/04 21:15:15
// Design Name: 
// Module Name: uart_reg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 这是一个接受的发送长度不同的同步fifo模块，会以空闲中断的方式不足一帧的数据
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module bit2reg_module #(
    parameter WIDTH = 32
) (
    input                  clk,
    input                  rst_n,
    input                  wr_en,
    input                  wr_rst,
    input      [      7:0] din,
    output reg             dack,
    output reg [WIDTH-1:0] dout
);
  /**************************************************************/
  //接收数据
  reg [WIDTH-1:0] r_din;
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
      data_cnt <= data_cnt + 'd8;
    end else if (wr_rst || data_cnt == WIDTH) begin
      data_cnt <= 'd0;
    end
  end
  /**************************************************************/
  //生成信号
  reg [WIDTH-1:0] fifo_din;
  reg             fifo_wren;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      dout <= 'd0;
      dack <= 'd0;
    end else if (data_cnt == WIDTH) begin
      dout <= r_din;
      dack <= 'd1;
    end else begin
      dack <= 'd0;
    end
  end
endmodule
