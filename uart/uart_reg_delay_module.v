`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/08 16:59:46
// Design Name: 
// Module Name: uart_reg_delay_module
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


module uart_reg_delay_module (
    input         clk,
    input         rst_n,
    input  [31:0] reg_in,
    input         reg_valid,
    input  [15:0] app_wait_ms,
    output [31:0] reg_out,
    output        reg_ready
);
  parameter CLK_FRE = 50;
  parameter MS_CNT = CLK_FRE * 1000;  //50*1000
  wire        fifo_rd_en;
  wire [31:0] fifo_dout;
  wire        fifo_valid;
  wire        fifo_empty;



  /**************************同步状态****************************/
  reg  [ 4:0] STATE_CURRENT;
  reg  [ 4:0] STATE_NEXT;
  localparam S_IDLE = 5'd0;  //空闲，fifo无数据状态
  localparam S_INIT = 5'd1;  //判断命令是否需要延时
  localparam S_READ = 5'd2;  //读出
  localparam S_WAIT = 5'd3;  //正常间隔
  localparam S_DELAY = 5'd4;  //延时指令
  localparam S_STOP = 5'd5;

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) STATE_CURRENT <= S_IDLE;
    else STATE_CURRENT <= STATE_NEXT;
  end
  reg [31:0] state_clk_cnt;
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) state_clk_cnt <= 'd0;
    else if (STATE_NEXT != STATE_CURRENT || state_clk_cnt == MS_CNT - 1) state_clk_cnt <= 'd0;
    else state_clk_cnt <= state_clk_cnt + 1'd1;
  end
  reg [15:0] state_ms;
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) state_ms <= 'd0;
    else if (STATE_NEXT != STATE_CURRENT) state_ms <= 'd0;
    else if (state_clk_cnt == MS_CNT - 1) state_ms <= state_ms + 1'd1;
    else state_ms <= state_ms;
  end
  /**************************转移状态****************************/
  always @(*) begin
    case (STATE_CURRENT)
      S_IDLE: begin
        if (!fifo_empty) STATE_NEXT = S_INIT;
        else STATE_NEXT = S_IDLE;
      end
      S_INIT: begin
        STATE_NEXT = S_WAIT;
      end
      S_READ: begin
        STATE_NEXT = S_STOP;
      end
      S_WAIT: begin
        if (state_ms == app_wait_ms - 1) STATE_NEXT = S_READ;
        else STATE_NEXT = S_WAIT;
      end
      S_STOP: begin
        STATE_NEXT = S_IDLE;
      end
      default: STATE_NEXT = S_IDLE;
    endcase
  end

  /**************************状态输出****************************/
  reg rd_en;
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) rd_en <= 1'd0;
    else if (STATE_CURRENT == S_READ) rd_en <= 1'd1;
    else rd_en <= 1'd0;
  end

  /**************************************************/
  assign reg_ready  = rd_en;
  assign fifo_rd_en = rd_en;
  assign reg_out    = fifo_dout;

  /**************************************************/
  fifo_uart_delay your_instance_name (
      .clk  (clk),         // input wire clk
      .din  (reg_in),      // input wire [31 : 0] din
      .wr_en(reg_valid),   // input wire wr_en
      .rd_en(fifo_rd_en),  // input wire rd_en
      .dout (fifo_dout),   // output wire [31 : 0] dout
      //   .full(full),    // output wire full
      .empty(fifo_empty),  // output wire empty
      .valid(fifo_valid)   // output wire valid
  );
endmodule
