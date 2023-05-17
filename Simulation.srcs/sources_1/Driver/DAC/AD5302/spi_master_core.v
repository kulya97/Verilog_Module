`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/23 10:08:17
// Design Name: 
// Module Name: spi_master_core
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 常用模式CPOL：CPHA
//(常用)mode 0:00:sclk场低，第一个边沿采样，第二个边沿发送，下降沿发送，上升沿采样
//(不常)mode 1:01:sclk场低，第一个边沿发送，第二个边沿采样，下降沿采样，上升沿发送
//(不常)mode 2:10:sclk常高，第一个边沿采样，第二个边沿发送，下降沿采样，上升沿发送
//(常用)mode 3:11:sclk常高，第一个边沿发送，第二个边沿采样，下降沿发送，上升沿采样
//如果需要调整位宽在参数调节
//如果起始位置不同，发送数据可以在前增加无用位，读取数据可以增加位宽。
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
//ad5302  01模式
module spi_master_core (
    input         clk,
    input         rst_n,
    input  [15:0] clk_div,  //确定频率
    input  [ 7:0] channel,
    input         CPOL,     // 时钟极性 ，H idle时为高
    input         CPHA,     //时钟相位 H sck第二个跳变沿采样，L sck第一个跳变沿采样
    output [ 7:0] CS,       //spi cs
    output        DCLK,     //spi clock
    output        MOSI,     //spi data output
    input         MISO,     //spi input

    input         wr_req,   //请求
    output        wr_ack,   //响应
    input  [15:0] data_in,  //data in
    output [15:0] data_out  //data out
);
  parameter BITNUM = 8'd16;
  localparam BITCNT = BITNUM * 2;
  /***************************/
  reg        DCLK_reg;
  reg [ 7:0] r_CS;
  reg [15:0] MOSI_shift;
  reg [15:0] MISO_shift;

  reg [15:0] r_data_out;
  reg        r_wr_ack;

  reg [ 7:0] r_channel;
  reg [15:0] clk_cnt;
  reg [ 7:0] clk_edge_cnt;
  /***************************/
  reg [ 3:0] state;
  reg [ 3:0] next_state;
  localparam S_IDLE = 0;
  localparam S_INIT = 6;
  localparam S_DCLK_EDGE = 1;  //翻转状态
  localparam S_DCLK_IDLE = 2;
  localparam S_ACK = 3;  //响应状态
  localparam S_LAST_HALF_CYCLE = 4;  //电平保持
  localparam S_ACK_WAIT = 5;
  /***************************/
  assign MOSI     = MOSI_shift[15];
  assign DCLK     = DCLK_reg;
  assign data_out = r_data_out;
  assign wr_ack   = r_wr_ack;
  assign CS       = r_CS;
  /******************************************************************/
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) state <= S_IDLE;
    else state <= next_state;
  end
  always @(*) begin
    case (state)
      S_IDLE:
      if (wr_req == 1'b1) next_state <= S_DCLK_IDLE;
      else next_state <= S_IDLE;
      S_DCLK_IDLE:
      if (clk_cnt == clk_div) next_state <= S_DCLK_EDGE;
      else next_state <= S_DCLK_IDLE;
      S_DCLK_EDGE:
      if (clk_edge_cnt == BITCNT - 1) next_state <= S_LAST_HALF_CYCLE;
      else next_state <= S_DCLK_IDLE;
      S_LAST_HALF_CYCLE:
      if (clk_cnt == clk_div) next_state <= S_ACK;
      else next_state <= S_LAST_HALF_CYCLE;
      S_ACK: next_state <= S_ACK_WAIT;
      S_ACK_WAIT: next_state <= S_IDLE;
      default: next_state <= S_IDLE;
    endcase
  end
  /******************************************************************/
  //SPI clock wait counter
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) clk_cnt <= 16'd0;
    else if (state == S_DCLK_IDLE || state == S_LAST_HALF_CYCLE) clk_cnt <= clk_cnt + 16'd1;
    else clk_cnt <= 16'd0;
  end
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) DCLK_reg <= 1'b0;
    else if (state == S_IDLE) DCLK_reg <= CPOL;
    else if (state == S_DCLK_EDGE) DCLK_reg <= ~DCLK_reg;  //SPI clock edge
  end

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) r_CS <= 8'hff;
    else if (state == S_IDLE && wr_req == 1'b1) r_CS <= ~channel;
    else if (state == S_ACK_WAIT) r_CS <= 8'hff;
    else r_CS <= r_CS;
  end

  /******************************************************************/

  //SPI clock edge counter
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) clk_edge_cnt <= 8'd0;
    else if (state == S_DCLK_EDGE) clk_edge_cnt <= clk_edge_cnt + 8'd1;
    else if (state == S_IDLE) clk_edge_cnt <= 8'd0;
  end
  /******************************************************************/
  //SPI data output
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) MOSI_shift <= 8'd0;
    else if (state == S_IDLE && wr_req) MOSI_shift <= data_in;  //锁存数据
    else if (state == S_DCLK_EDGE)
      if (CPHA == 1'b0 && clk_edge_cnt[0] == 1'b1) MOSI_shift <= {MOSI_shift[14:0], 1'b0};
      else if (CPHA == 1'b1 && (clk_edge_cnt != 5'd0 && clk_edge_cnt[0] == 1'b0)) MOSI_shift <= {MOSI_shift[14:0], 1'b0};
  end
  /******************************************************************/
  //SPI data input
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) MISO_shift <= 8'd0;
    else if (state == S_IDLE && wr_req) MISO_shift <= 8'h00;
    else if (state == S_DCLK_EDGE)
      if (CPHA == 1'b0 && clk_edge_cnt[0] == 1'b0) MISO_shift <= {MISO_shift[14:0], MISO};
      else if (CPHA == 1'b1 && (clk_edge_cnt[0] == 1'b1)) MISO_shift <= {MISO_shift[14:0], MISO};
  end
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) r_data_out <= 'd0;
    else if (state == S_ACK) r_data_out <= MISO_shift;
    else r_data_out <= r_data_out;
  end
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) r_wr_ack <= 1'd0;
    else if (state == S_ACK) r_wr_ack <= 1'b1;
    else r_wr_ack <= 1'd0;
  end

endmodule
