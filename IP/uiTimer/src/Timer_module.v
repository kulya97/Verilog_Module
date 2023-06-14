`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/17 15:51:08
// Design Name: 
// Module Name: Timer_module
// Project Name: 
// Target Devices: 
// Tool Versions: 2023.05.09 v1.1
//2023.06.09  v1.2
// Description: 用于定时提供一个触发信号;
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 

// Timer_module #(
//     .I_Clk_FRE ( I_Clk_FRE ),
//     .LOOP    ( LOOP    ))
//  u_Timer_module (
//     .I_Clk                     ( I_Clk                    ),
//     .I_rst_n                   ( I_rst_n                  ),
//     .I_app_timer_us          ( I_app_timer_us  [31:0] ),
//     .I_app_req               ( I_app_req              ),

//     .O_app_busy              ( O_app_busy             ),
//     .O_app_ack               ( O_app_ack              ),
//      .O_app_done(O_app_done)
// );

//////////////////////////////////////////////////////////////////////////////////


module Timer_module (
    input      I_Clk,
    input      I_rst_n,
    input      I_app_req,
    output reg O_app_busy,
    output reg O_app_ack,
    output reg O_app_done
);
  parameter CLK_FRE = 50;
  parameter TIMING_US = 32'd100;
  parameter LOOP = 1'b1;
  localparam US_CNT = CLK_FRE;  //50


  /**************************同步状态****************************/
  reg [4:0] STATE_CURRENT;
  reg [4:0] STATE_NEXT;
  localparam S_IDLE = 5'd0;  //
  localparam S_WAIT = 5'd1;  //
  localparam S_ACK = 5'd2;
  localparam S_DONE = 5'd3;
  always @(posedge I_Clk, negedge I_rst_n) begin
    if (!I_rst_n) STATE_CURRENT <= S_IDLE;
    else STATE_CURRENT <= STATE_NEXT;
  end
  reg [7:0] state_clk_cnt;
  always @(posedge I_Clk, negedge I_rst_n) begin
    if (!I_rst_n) state_clk_cnt <= 8'd0;
    else if (STATE_NEXT != STATE_CURRENT || state_clk_cnt == US_CNT - 1) state_clk_cnt <= 8'd0;
    else state_clk_cnt <= state_clk_cnt + 1'd1;
  end
  reg [31:0] state_us;
  always @(posedge I_Clk, negedge I_rst_n) begin
    if (!I_rst_n) state_us <= 'd0;
    else if (STATE_NEXT != STATE_CURRENT) state_us <= 'd0;
    else if (state_clk_cnt == US_CNT - 1) state_us <= state_us + 1'd1;
    else state_us <= state_us;
  end
  /**************************转移状态****************************/
  wire W_ACK;
  assign W_ACK = (state_us == TIMING_US - 1 && state_clk_cnt == US_CNT - 2);
  always @(*) begin
    case (STATE_CURRENT)
      S_IDLE: begin
        if (I_app_req) STATE_NEXT = S_WAIT;
        else STATE_NEXT = S_IDLE;
      end
      S_WAIT: begin
        if (W_ACK && LOOP) STATE_NEXT = S_IDLE;
        else if (W_ACK && !LOOP) STATE_NEXT = S_DONE;
        else STATE_NEXT = S_WAIT;
      end
      S_ACK: begin
        if (LOOP) STATE_NEXT = S_IDLE;
        else STATE_NEXT = S_DONE;
      end
      S_DONE:  STATE_NEXT = S_DONE;
      default: STATE_NEXT = S_IDLE;
    endcase
  end

  /**************************状态输出****************************/
  always @(posedge I_Clk, negedge I_rst_n) begin
    if (!I_rst_n) O_app_ack <= 1'd0;
    else if (W_ACK) O_app_ack <= 1'd1;
    else O_app_ack <= 1'd0;
  end

  /**************************状态输出****************************/
  always @(posedge I_Clk, negedge I_rst_n) begin
    if (!I_rst_n) O_app_busy <= 1'd0;
    else if (STATE_CURRENT == S_WAIT) O_app_busy <= 1'd1;
    else O_app_busy <= 1'd0;
  end
  always @(posedge I_Clk, negedge I_rst_n) begin
    if (!I_rst_n) O_app_done <= 1'd0;
    else if (STATE_CURRENT == S_DONE) O_app_done <= 1'd1;
    else O_app_done <= 1'd0;
  end
endmodule
