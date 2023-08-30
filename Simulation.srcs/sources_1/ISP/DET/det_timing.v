`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/29 11:43:04
// Design Name: 
// Module Name: det_timing
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


module det_timing (
    input         I_pclk,
    input         I_vsync,
    input         I_hsync,
    input         I_dvalid,
    output [11:0] O_line_cnt,
    output [11:0] O_pixel_cnt
);
  reg  [11:0] R_line_cnt;
  reg  [11:0] R_pixel_cnt;

  reg         R_vsync_d;
  reg         R_hsync_d;
  reg         R_dvalid_d;
  wire        W_vsync_r;
  wire        W_vsync_f;
  wire        W_hsync_r;
  wire        W_hsync_f;
  wire        W_dvalid_r;
  wire        W_dvalid_f;
  /*****************************************/
  //！abc
  always @(posedge I_pclk) begin
    R_vsync_d  <= I_vsync;
    R_hsync_d  <= I_hsync;
    R_dvalid_d <= I_dvalid;
  end
  assign W_vsync_r  = !R_vsync_d && I_vsync;
  assign W_vsync_f  = R_vsync_d && !I_vsync;
  assign W_hsync_r  = !R_hsync_d && I_hsync;
  assign W_hsync_f  = R_hsync_d && !I_hsync;
  assign W_dvalid_r = !R_dvalid_d && I_dvalid;
  assign W_dvalid_f = R_dvalid_d && !I_dvalid;
  /*****************************************/
  always @(posedge I_pclk) begin
    if (W_vsync_f) R_line_cnt <= 'd0;
    else if (W_dvalid_f) R_line_cnt <= R_line_cnt + 1'd1;
    else R_line_cnt <= R_line_cnt;
  end
  /*****************************************/
  always @(posedge I_pclk) begin
    if (W_hsync_r) R_pixel_cnt <= 'd0;
    else if (I_dvalid) R_pixel_cnt <= R_pixel_cnt + 1'd1;
    else R_pixel_cnt <= R_pixel_cnt;
  end
  assign O_line_cnt  = R_line_cnt;
  assign O_pixel_cnt = R_pixel_cnt;
  /*****************************************/
endmodule
