`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/05 16:02:47
// Design Name: 
// Module Name: 
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


module Timing_Gen (
    input             clk,
    input             rst_n,
    input      [15:0] app_image_h,
    input      [15:0] app_image_w,
    input             sys_en,
    output reg        frame_valid,
    output reg        line_valid,
    output reg        data_valid,
    output reg [15:0] dout,
    output reg [11:0] line_cnt,
    output reg [11:0] pixel_cnt
);
  parameter Integration_T = 24'd50;
  /*******************************************/
  reg [4:0] S_STATE_CURRENT;
  reg [4:0] S_STATE_NEXT;
  localparam S_IDLE = 0;
  localparam S_INTERGTAL = 1;
  localparam S_WAIT0 = 2;
  localparam S_READ = 3;
  localparam S_WAIT1 = 4;

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) S_STATE_CURRENT <= S_IDLE;
    else S_STATE_CURRENT <= S_STATE_NEXT;
  end
  reg [31:0] state_clk_cnt;
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) state_clk_cnt <= 32'd0;
    else if (S_STATE_NEXT != S_STATE_CURRENT) state_clk_cnt <= 32'd0;
    else state_clk_cnt <= state_clk_cnt + 1'd1;
  end
  always @(*) begin
    case (S_STATE_CURRENT)
      S_IDLE: begin
        if (sys_en) S_STATE_NEXT = S_INTERGTAL;
        else S_STATE_NEXT = S_IDLE;
      end
      S_INTERGTAL: begin
        if (state_clk_cnt == Integration_T - 1) S_STATE_NEXT = S_WAIT0;
        else S_STATE_NEXT = S_INTERGTAL;
      end
      S_WAIT0: begin
        S_STATE_NEXT = S_READ;
      end
      S_READ: begin
        if (state_clk_cnt == app_image_w - 1) S_STATE_NEXT = S_WAIT1;
        else S_STATE_NEXT = S_READ;
      end
      S_WAIT1: begin
        if (line_cnt == app_image_h - 1) S_STATE_NEXT = S_IDLE;
        else S_STATE_NEXT = S_WAIT0;
      end
      default: S_STATE_NEXT = S_IDLE;
    endcase
  end
  /****************************************************/
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      line_cnt  <= 1'd0;
      pixel_cnt <= 1'd0;
    end else
      case (S_STATE_CURRENT)
        S_IDLE: begin
          line_cnt  <= 1'd0;
          pixel_cnt <= 1'd0;
        end
        S_INTERGTAL: begin
          line_cnt  <= 1'd0;
          pixel_cnt <= 1'd0;
        end
        S_WAIT0: begin
          line_cnt  <= line_cnt + 1'd1;
          pixel_cnt <= 1'd0;
        end
        S_READ: begin
          line_cnt  <= line_cnt;
          pixel_cnt <= pixel_cnt + 1'd1;
        end
        S_WAIT1: begin
          line_cnt  <= line_cnt;
          pixel_cnt <= 1'd0;

        end
        default: begin
        end
      endcase
  end
  /******************************************************/
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) frame_valid <= 1'b0;
    else if (S_STATE_CURRENT == S_IDLE || S_STATE_CURRENT == S_INTERGTAL) frame_valid <= 1'b0;
    else frame_valid <= 1'b1;
  end
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) line_valid <= 1'b0;
    else if (S_STATE_CURRENT == S_READ) line_valid <= 1'b1;
    else line_valid <= 1'b0;
  end
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) data_valid <= 1'b0;
    else if (S_STATE_CURRENT == S_READ) data_valid <= 1'b1;
    else data_valid <= 1'b0;
  end
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) dout <= 'b0;
    else if (S_STATE_CURRENT == S_READ) dout <= dout + 1'b1;
    else if (S_STATE_CURRENT == S_IDLE) dout <= 'b0;
    else dout <= dout;
  end
  /******************************************************/

endmodule
