`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/15 09:59:37
// Design Name: 
// Module Name: Par2Ser
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


module Par2Ser #(
    parameter SERWIDTH   = 8,
    parameter PARWIDTH   = 32,
    parameter Data_Order = 1    //数据方向

) (
    input                     clk,
    input                     rst_n,
    input                     par_valid,
    output reg                par_ready,
    input      [PARWIDTH-1:0] par_din,

    output reg                ser_valid,
    input                     ser_ready,
    output     [SERWIDTH-1:0] ser_dout
);

  reg [  SERWIDTH:0] r_dout;
  reg [PARWIDTH-1:0] r_din;
  reg [        15:0] data_cnt;

  /**************************************************************/
  //接收数据
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) par_ready <= 1'b0;
    else if (!par_ready & par_valid && data_cnt == PARWIDTH) par_ready <= 1'b1;  //请求一次数据
    else par_ready <= 1'b0;
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      r_din <= 'd0;
    end else if (par_ready && par_valid) begin  //锁存一次数据
      r_din <= par_din;
    end else if (ser_valid && ser_ready && Data_Order) begin  // 传输一次后，更新数据
      r_din <= r_din >> SERWIDTH;
    end else if (ser_valid && ser_ready && !Data_Order) begin  // 传输一次后，更新数据
      r_din <= r_din << SERWIDTH;
    end else begin
      r_din <= r_din;
    end
  end
  /**************************************************************/
  //发送数据
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) ser_valid <= 1'b0;
    else if (data_cnt == PARWIDTH) ser_valid <= 1'b0;
    else ser_valid <= 1'b1;
  end
  //计数
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) data_cnt <= PARWIDTH;
    else if (ser_valid && ser_ready)  //传输完成后，计数+1
      data_cnt <= data_cnt + SERWIDTH;
    else if (par_ready && par_valid) data_cnt <= 'd0;  //请求数据之后清零
    else data_cnt <= data_cnt;
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      r_dout <= 'd0;
    end else if (Data_Order) begin  //发送一次数据
      r_dout <= r_din[SERWIDTH-1:0];
    end else begin  //发送一次数据
      r_dout <= r_din[PARWIDTH-1:PARWIDTH-SERWIDTH];
    end
  end
  assign ser_dout = r_dout;
endmodule
