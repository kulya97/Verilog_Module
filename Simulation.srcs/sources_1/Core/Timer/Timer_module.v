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
// Description: 用于定时提供一个触发信号;
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 

// Timer_module #(
//     .CLK_FRE ( CLK_FRE ))
//  u_Timer_module (
//     .clk                     ( clk                   ),
//     .rst_n                   ( rst_n                 ),
//     .I_app_timer_us           ( I_app_timer_us  [31:0] ),
//     .I_app_req               ( I_app_req             ),

//     .O_app_busy              ( O_app_busy            ),
//     .O_app_ack               ( O_app_ack             )
// );
//////////////////////////////////////////////////////////////////////////////////


module Timer_module (
    input             clk,
    input             rst_n,
    input      [31:0] I_app_timer_us,
    input             I_app_req,
    output reg        O_app_busy,
    output reg        O_app_ack
);
  parameter CLK_FRE = 50;
  localparam US_CNT = CLK_FRE;  //50


  /**************************同步状态****************************/
  reg [1:0] STATE_CURRENT;
  reg [1:0] STATE_NEXT;
  localparam S_IDLE = 2'd0;  //
  localparam S_WAIT = 2'd1;  //
  localparam S_ACK = 2'd2;
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) STATE_CURRENT <= S_IDLE;
    else STATE_CURRENT <= STATE_NEXT;
  end
  reg [7:0] state_clk_cnt;
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) state_clk_cnt <= 8'd0;
    else if (STATE_NEXT != STATE_CURRENT || state_clk_cnt == US_CNT - 1) state_clk_cnt <= 8'd0;
    else state_clk_cnt <= state_clk_cnt + 1'd1;
  end
  reg [31:0] state_us;
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) state_us <= 'd0;
    else if (STATE_NEXT != STATE_CURRENT) state_us <= 'd0;
    else if (state_clk_cnt == US_CNT - 1) state_us <= state_us + 1'd1;
    else state_us <= state_us;
  end
  /**************************转移状态****************************/
  wire W_ACK;
  assign W_ACK = (state_us == I_app_timer_us - 1 && state_clk_cnt == US_CNT - 2);
  always @(*) begin
    case (STATE_CURRENT)
      S_IDLE: begin
        if (I_app_req) STATE_NEXT = S_WAIT;
        else STATE_NEXT = S_IDLE;
      end
      S_WAIT: begin
        if (W_ACK) STATE_NEXT = S_IDLE;
        else STATE_NEXT = S_WAIT;
      end
      S_ACK: begin
        STATE_NEXT = S_IDLE;
      end
      default: STATE_NEXT = S_IDLE;
    endcase
  end

  /**************************状态输出****************************/
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) O_app_ack <= 1'd0;
    else if (W_ACK) O_app_ack <= 1'd1;
    else O_app_ack <= 1'd0;
  end

  /**************************状态输出****************************/
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) O_app_busy <= 1'd0;
    else if (STATE_CURRENT == S_WAIT) O_app_busy <= 1'd1;
    else O_app_busy <= 1'd0;
  end
endmodule
