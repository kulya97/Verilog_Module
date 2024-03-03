`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/28 17:29:17
// Design Name: 
// Module Name: mcp4022_module
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


module mcp4022_module (
    input             clk,
    input             rst_n,
    input      [15:0] step,    //
    input             dir,     //1 增加，2减少
    input             req,     //
    output reg        ack,     //
    output reg        mcp_cs,
    output reg        mcp_udn
);

  parameter DELAY_CNT = 16'd500;
  reg [15:0] r_step;
  reg        r_dir;
  reg        r_req;
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) r_step <= 'd0;
    else if (req && dir) r_step <= {step[14:0], 1'b1} - 'd2;  //尾数为1写入eeprom，尾数为0不写入eeprom
    else if (req && !dir) r_step <= {step[14:0], 1'b1};
    else r_step <= r_step;
  end

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) r_dir <= 'd0;
    else if (req) r_dir <= dir;
    else r_dir <= r_dir;
  end

  /**************************状态定义***************************/

  reg [15:0] r_step_current;
  reg [ 4:0] STATE_CURRENT;
  reg [ 4:0] STATE_NEXT;

  localparam S_IDLE = 5'd0;
  localparam S_INIT = 5'd1;
  localparam S_WAIT = 5'd2;
  localparam S_TOGGLE = 5'd3;
  localparam S_DONE = 5'd4;
  localparam S_WAIT_WRITE = 5'd5;
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

  /**************************状态转移***************************/
  always @(*) begin
    case (STATE_CURRENT)
      S_IDLE: begin
        if (req) STATE_NEXT = S_INIT;
        else STATE_NEXT = S_IDLE;
      end
      S_INIT: begin
        if (state_clk_cnt == DELAY_CNT - 1) STATE_NEXT = S_WAIT;
        else STATE_NEXT = S_INIT;
      end
      S_WAIT: begin
        if (state_clk_cnt == DELAY_CNT - 1 && r_step_current == r_step) STATE_NEXT = S_WAIT_WRITE;
        else if (state_clk_cnt == DELAY_CNT - 1) STATE_NEXT = S_TOGGLE;
        else STATE_NEXT = S_WAIT;
      end
      S_TOGGLE: begin
        STATE_NEXT = S_WAIT;
      end
      S_WAIT_WRITE: begin
        if (state_clk_cnt == DELAY_CNT - 1) STATE_NEXT = S_DONE;
        else STATE_NEXT = S_WAIT_WRITE;
      end
      S_DONE: begin
        STATE_NEXT = S_IDLE;
      end
      default: STATE_NEXT = S_IDLE;
    endcase
  end

  /**************************状态输出****************************/
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) mcp_cs <= 1'b1;
    else if (STATE_CURRENT == S_WAIT || STATE_CURRENT == S_TOGGLE) mcp_cs <= 1'b0;
    else mcp_cs <= 1'b1;
  end
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) mcp_udn <= 1'b1;
    else if (STATE_CURRENT == S_INIT) mcp_udn <= !r_dir;
    else if (STATE_CURRENT == S_TOGGLE) mcp_udn <= !mcp_udn;
    else mcp_udn <= mcp_udn;
  end
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) r_step_current <= 'd0;
    else if (STATE_CURRENT == S_IDLE) r_step_current <= 'd0;
    else if (STATE_CURRENT == S_TOGGLE) r_step_current <= r_step_current + 1'd1;
    else r_step_current <= r_step_current;
  end
  /**************************状态输出****************************/
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) ack <= 1'b0;
    else if (STATE_CURRENT == S_DONE) ack <= 1'b1;
    else ack <= 1'b0;
  end

endmodule
