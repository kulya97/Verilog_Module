`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/13 10:06:49
// Design Name: 
// Module Name: mcp4022_control_module
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


module mcp4022_control_module (
    input         clk,
    input         rst_n,
    input  [31:0] uart_reg,
    input         uart_ready,
    output        mcp_cs,
    output        mcp_udn
);
  parameter ADDRESS_MCP = 16'hdaca;
  parameter DELAY_CNT = 16'd500;

  // mcp4022_module Inputs
  reg  [15:0] step;
  reg         dir;
  reg         req;

  // mcp4022_module Outputs
  wire        ack;



  /**************************同步状态****************************/
  reg  [ 4:0] STATE_CURRENT;
  reg  [ 4:0] STATE_NEXT;
  localparam S_IDLE = 5'd0;  //空闲
  localparam S_INIT = 5'd1;  //
  localparam S_WRITE = 5'd2;  //
  localparam S_WAIT = 5'd3;  //
  localparam S_STOP = 5'd5;  //
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
        if (uart_ready && uart_reg[31:16] == ADDRESS_MCP) STATE_NEXT = S_WRITE;
        else STATE_NEXT = S_IDLE;
      end
      S_INIT: begin
        STATE_NEXT = S_WRITE;
      end
      S_WRITE: begin
        STATE_NEXT = S_WAIT;
      end
      S_WAIT: begin
        if (ack) STATE_NEXT = S_STOP;
        else STATE_NEXT = S_WAIT;
      end
      S_STOP: begin
        STATE_NEXT = S_IDLE;
      end
      default: STATE_NEXT = S_IDLE;
    endcase
  end

  /**************************状态输出****************************/
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) dir <= 0;
    else if (uart_ready && uart_reg[31:16] == ADDRESS_MCP && uart_reg[15:8] == 8'hff) dir <= 1'b1;
    else if (uart_ready && uart_reg[31:16] == ADDRESS_MCP && uart_reg[15:8] == 8'h00) dir <= 1'b0;
    else dir <= dir;
  end
  //req
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) req <= 1'b0;
    else if (STATE_CURRENT == S_WRITE) req <= 1'b1;
    else req <= 1'b0;
  end
  //r_channel
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) step <= 'b0;
    else if (uart_ready && uart_reg[31:16] == ADDRESS_MCP) step <= {8'b0, uart_reg[7:0]};
    else step <= step;
  end
  //

  mcp4022_module #(
      .DELAY_CNT(DELAY_CNT)
  ) u_mcp4022_module (
      .clk  (clk),
      .rst_n(rst_n),
      .step (step[15:0]),
      .dir  (dir),
      .req  (req),

      .ack    (ack),
      .mcp_cs (mcp_cs),
      .mcp_udn(mcp_udn)
  );

endmodule
