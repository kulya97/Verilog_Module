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
    output [31:0] reg_out,
    output        reg_ready
);
  parameter MS_CNT = 50_000;  //50*1000
  parameter DELAY_HEADER = 16'habcd;
  parameter WAIT_HEADER = 16'habc1;
  wire        fifo_rd_en;
  wire [31:0] fifo_dout;
  wire        fifo_valid;

  reg  [15:0] app_delay_ms;
  reg  [15:0] app_wait_ms;



  /**************************ͬ��״̬****************************/
  reg  [ 4:0] STATE_CURRENT;
  reg  [ 4:0] STATE_NEXT;
  localparam S_IDLE = 5'd0;  //���У�fifo������״̬
  localparam S_INIT = 5'd1;  //�ж������Ƿ���Ҫ��ʱ
  localparam S_READ = 5'd2;  //����
  localparam S_WAIT = 5'd3;  //�������
  localparam S_DELAY = 5'd4;  //��ʱָ��
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
  /**************************ת��״̬****************************/
  always @(*) begin
    case (STATE_CURRENT)
      S_IDLE: begin
        if (fifo_valid) STATE_NEXT = S_INIT;
        else STATE_NEXT = S_IDLE;
      end
      S_INIT: begin
        if (fifo_dout[31:16] == DELAY_HEADER) STATE_NEXT = S_DELAY;
        else STATE_NEXT = S_WAIT;
      end
      S_READ: begin
        STATE_NEXT = S_STOP;
      end
      S_WAIT: begin
        if (state_ms == app_wait_ms - 1) STATE_NEXT = S_READ;
        else STATE_NEXT = S_WAIT;
      end
      S_DELAY: begin
        if (state_ms == app_delay_ms - 1) STATE_NEXT = S_READ;
        else STATE_NEXT = S_DELAY;
      end
      S_STOP: begin
        STATE_NEXT = S_IDLE;
      end
      default: STATE_NEXT = S_IDLE;
    endcase
  end

  /**************************״̬���****************************/
  reg rd_en;
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) rd_en <= 1'd0;
    else if (STATE_CURRENT == S_READ) rd_en <= 1'd1;
    else rd_en <= 1'd0;
  end

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) app_delay_ms <= 16'd100;
    else if (STATE_CURRENT == S_INIT && fifo_dout[31:16] == DELAY_HEADER) app_delay_ms <= fifo_dout[15:0];
    else app_delay_ms <= app_delay_ms;
  end

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) app_wait_ms <= 16'd1;
    else if (STATE_CURRENT == S_INIT && fifo_dout[31:16] == WAIT_HEADER) app_wait_ms <= fifo_dout[15:0];
    else app_wait_ms <= app_wait_ms;
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
      //   .empty(empty),  // output wire empty
      .valid(fifo_valid)   // output wire valid
  );
endmodule
