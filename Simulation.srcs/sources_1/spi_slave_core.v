//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/23 10:08:17
// Design Name: 
// Module Name: spi_slave_core
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 常用模式CPOL：CPHA
//(常用)mode 0:00:sclk场低，第一个边沿采样，第二个边沿发送，下降沿发送，上升沿采样
//(不常)mode 1:01:sclk场低，第一个边沿发送，第二个边沿采样，下降沿采样，上升沿发送
//(不常)mode 2:10:sclk常高，第一个边沿采样，第二个边沿发送，下降沿采样，上升沿发送
//(常用)mode 3:11:sclk常高，第一个边沿发送，第二个边沿采样，下降沿发送，上升沿采样
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module spi_slave_core #(
    parameter REG_WIDTH = 16,
    parameter CPOL = 1,  // 时钟极性 ，H idle时为高
    parameter CPHA = 1  //时钟相位 H sck第二个跳变沿采样，L sck第一个跳变沿采样
) (
    input clk,
    input rst_n,

    input  CS,    //chip select (SPI mode)
    input  DCLK,  //spi clock
    input  MOSI,  //spi data input
    output MISO,  //spi output 

    input      [7:0] app_data_in,   //data in
    output     [7:0] app_data_out,  //data out
    input            app_ready,
    output reg       app_valid      //响应
);

  /***************************/
  localparam BITCNT = REG_WIDTH * 2;
  /***************************/
  reg [7:0] MOSI_shift;
  reg [7:0] MISO_shift;
  reg [7:0] r_data_out;

  reg [7:0] r_rising_cnt;
  reg [7:0] r_falling_cnt;
  reg [7:0] r_edge_cnt;
  reg r_dclk_d0, r_dclk_d1;
  wire r_sampling_r;
  wire r_sampling_f;
  wire r_sampling;
  /***************************/
  assign MISO         = MISO_shift[7];
  assign app_data_out = r_data_out;
  /***************************/
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      r_dclk_d0 <= 1'b0;
      r_dclk_d1 <= 1'b0;
    end else begin
      r_dclk_d0 <= DCLK;
      r_dclk_d1 <= r_dclk_d0;
    end
  end
  assign r_sampling_r = r_dclk_d0 & !r_dclk_d1;  //上升沿
  assign r_sampling_f = !r_dclk_d0 & r_dclk_d1;  //下降沿
  assign r_sampling   = (r_dclk_d0 != r_dclk_d1);  //跳变沿
  /**************************同步状态****************************/
  reg [4:0] STATE_CURRENT;
  reg [4:0] STATE_NEXT;
  localparam S_IDLE = 5'd0;  //空闲
  localparam S_INIT = 5'd1;  //空闲
  localparam S_DCLK_IDLE = 5'd2;  //空闲
  localparam S_ACK = 5'd3;  //空闲

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) STATE_CURRENT <= S_IDLE;
    else STATE_CURRENT <= STATE_NEXT;
  end
  reg [31:0] state_clk_cnt;
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) state_clk_cnt <= 32'd0;
    else if (STATE_NEXT != STATE_CURRENT) state_clk_cnt <= 32'd0;
    else state_clk_cnt <= state_clk_cnt + 1'd1;
  end
  /**************************转移状态****************************/
  always @(*) begin
    case (STATE_CURRENT)
      S_IDLE: begin
        if (!CS) STATE_NEXT = S_INIT;
        else STATE_NEXT = S_IDLE;
      end
      S_INIT: begin
        if (CS) STATE_NEXT = S_IDLE;
        else STATE_NEXT = S_DCLK_IDLE;
      end
      S_DCLK_IDLE: begin
        if (CS) STATE_NEXT = S_IDLE;
        else if (r_edge_cnt == BITCNT) STATE_NEXT = S_ACK;
        else STATE_NEXT = S_DCLK_IDLE;
      end
      S_ACK: begin
        STATE_NEXT = S_IDLE;
      end
      default: STATE_NEXT = S_IDLE;
    endcase
  end

  /**************************边沿计数****************************/
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) r_rising_cnt <= 'd0;
    else if (STATE_CURRENT == S_INIT) r_rising_cnt <= 'd0;
    else if (STATE_CURRENT == S_DCLK_IDLE && r_sampling_r) r_rising_cnt <= r_rising_cnt + 1'd1;
    else r_rising_cnt <= r_rising_cnt;
  end
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) r_falling_cnt <= 'd0;
    else if (STATE_CURRENT == S_INIT) r_falling_cnt <= 'd0;
    else if (STATE_CURRENT == S_DCLK_IDLE && r_sampling_f) r_falling_cnt <= r_falling_cnt + 1'd1;
    else r_falling_cnt <= r_falling_cnt;
  end
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) r_edge_cnt <= 'd0;
    else if (STATE_CURRENT == S_INIT) r_edge_cnt <= 'd0;
    else if (STATE_CURRENT == S_DCLK_IDLE && r_sampling) r_edge_cnt <= r_edge_cnt + 1'd1;
    else r_edge_cnt <= r_edge_cnt;
  end
  /**************************输入****************************/
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) MOSI_shift <= 'd0;
    else if (STATE_CURRENT == S_INIT) MOSI_shift <= 'd0;
    else if (STATE_CURRENT == S_DCLK_IDLE && CPHA == CPOL && r_sampling_r) MOSI_shift <= {MOSI_shift[6:0], MOSI};  //上升沿采样
    else if (STATE_CURRENT == S_DCLK_IDLE && CPHA != CPOL && r_sampling_f) MOSI_shift <= {MOSI_shift[6:0], MOSI};  //下降沿采样
    else MOSI_shift <= MOSI_shift;
  end
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) r_data_out <= 'd0;
    else if (STATE_CURRENT == S_ACK) r_data_out <= MOSI_shift;
    else r_data_out <= r_data_out;
  end
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) app_valid <= 1'd0;
    else if (STATE_CURRENT == S_ACK) app_valid <= 1'b1;
    else if (app_valid && app_ready) app_valid <= 1'd0;
    else app_valid <= app_valid;
  end
  /*************************输出****************************/
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) MISO_shift <= 'd0;
    else if (STATE_CURRENT == S_INIT) MISO_shift <= app_data_in;
    else if (STATE_CURRENT == S_DCLK_IDLE && CPHA && CPOL && r_sampling_r && r_edge_cnt != 'd0) MISO_shift <= {MISO_shift[6:0], 1'b0};  //上升沿传输
    else if (STATE_CURRENT == S_DCLK_IDLE && !CPHA && !CPOL && r_sampling_r) MISO_shift <= {MISO_shift[6:0], 1'b0};  //上升沿传输
    else if (STATE_CURRENT == S_DCLK_IDLE && !CPHA && CPOL && r_sampling_f) MISO_shift <= {MISO_shift[6:0], 1'b0};  //下降沿传输
    else if (STATE_CURRENT == S_DCLK_IDLE && CPHA && !CPOL && r_sampling_f && r_edge_cnt != 'd0) MISO_shift <= {MISO_shift[6:0], 1'b0};  //下降沿传输
    else MISO_shift <= MISO_shift;
  end
endmodule
