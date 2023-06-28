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
// Description: ????CPOL?CPHA
//(??)mode 0:00:sclk??????????????????????????????
//(??)mode 1:01:sclk??????????????????????????????
//(??)mode 2:10:sclk??????????????????????????????
//(??)mode 3:11:sclk??????????????????????????????
//?????????????
//??????????????????????????????????
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
//ad5302  01??
module spi_master_core #(
    parameter CHANNEL = 8,
    parameter REG_WIDTH = 16,
    parameter CPOL = 1,  // ???? ?H idle???
    parameter CPHA = 1,  //???? H sck?????????L sck????????
    parameter CLK_DIV = 5
) (
    input clk,
    input rst_n,

    output [CHANNEL-1:0] SPI_CS,    //spi cs
    output               SPI_SCLK,  //spi clock
    output               SPI_MOSI,  //spi data output
    input                SPI_MISO,  //spi input

    input      [  CHANNEL-1:0] wr_channel,
    input                      wr_valid,    //??
    output                     wr_ready,    //??
    output reg                 rd_ack,
    input      [REG_WIDTH-1:0] data_in,     //data in
    output     [REG_WIDTH-1:0] data_out     //data out
);


  localparam BITCNT = REG_WIDTH * 2;
  /***************************/
  reg                 DCLK_reg;
  reg [  CHANNEL-1:0] r_CS;
  reg [REG_WIDTH-1:0] MOSI_shift;
  reg [REG_WIDTH-1:0] MISO_shift;

  reg [REG_WIDTH-1:0] r_data_out;
  reg                 r_wr_ack;

  reg [         15:0] clk_cnt;
  reg [          7:0] clk_edge_cnt;
  /***************************/
  reg [          3:0] state;
  reg [          3:0] next_state;
  localparam S_IDLE = 0;
  localparam S_INIT = 6;
  localparam S_DCLK_EDGE = 1;  //????
  localparam S_DCLK_IDLE = 2;
  localparam S_ACK = 3;  //????
  localparam S_LAST_HALF_CYCLE = 4;  //????
  localparam S_ACK_WAIT = 5;
  /***************************/
  assign SPI_MOSI = MOSI_shift[REG_WIDTH-1];
  assign SPI_SCLK = DCLK_reg;
  assign data_out = r_data_out;
  assign wr_ready = r_wr_ack;
  assign SPI_CS   = r_CS;
  /******************************************************************/
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) state <= S_IDLE;
    else state <= next_state;
  end
  always @(*) begin
    case (state)
      S_IDLE:
      if (wr_valid && r_wr_ack) next_state <= S_INIT;
      else next_state <= S_IDLE;
      S_INIT: next_state <= S_DCLK_IDLE;
      S_DCLK_IDLE:
      if (clk_cnt == CLK_DIV - 1) next_state <= S_DCLK_EDGE;
      else next_state <= S_DCLK_IDLE;
      S_DCLK_EDGE:  //??
      if (clk_edge_cnt == BITCNT - 1) next_state <= S_LAST_HALF_CYCLE;
      else next_state <= S_DCLK_IDLE;
      S_LAST_HALF_CYCLE:  //??????
      if (clk_cnt == CLK_DIV - 1) next_state <= S_ACK;
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
    if (!rst_n) r_CS <= 16'hffff;
    else if (state == S_IDLE && wr_valid == 1'b1) r_CS <= ~wr_channel;
    else if (state == S_ACK_WAIT) r_CS <= 16'hffff;  //0-1?
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
    else if (state == S_INIT) MOSI_shift <= data_in;  //????
    else if (state == S_DCLK_EDGE)
      if (CPHA == 1'b0 && clk_edge_cnt[0] == 1'b1) MOSI_shift <= {MOSI_shift[REG_WIDTH-2:0], 1'b0};
      else if (CPHA == 1'b1 && (clk_edge_cnt != 5'd0 && clk_edge_cnt[0] == 1'b0)) MOSI_shift <= {MOSI_shift[REG_WIDTH-2:0], 1'b0};
  end
  /******************************************************************/
  //SPI data input
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) MISO_shift <= 8'd0;
    else if (state == S_IDLE && wr_valid) MISO_shift <= 8'h00;
    else if (state == S_DCLK_EDGE)
      if (CPHA == 1'b0 && clk_edge_cnt[0] == 1'b0) MISO_shift <= {MISO_shift[REG_WIDTH-2:0], SPI_MISO};
      else if (CPHA == 1'b1 && (clk_edge_cnt[0] == 1'b1)) MISO_shift <= {MISO_shift[REG_WIDTH-2:0], SPI_MISO};
  end
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) r_data_out <= 'd0;
    else if (state == S_ACK) r_data_out <= MISO_shift;
    else r_data_out <= r_data_out;
  end
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) rd_ack <= 'd0;
    else if (state == S_ACK) rd_ack <= 1'd1;
    else rd_ack <= 'd0;
  end

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) r_wr_ack <= 1'd0;
    else if (!r_wr_ack && wr_valid && state == S_IDLE) r_wr_ack <= 1'b1;
    else r_wr_ack <= 1'd0;
  end

endmodule
