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
// Timing_Gen #(
//     .Integration_T ( Integration_T ))
//  u_Timing_Gen (
//     .I_Pixel_Clk                     ( I_Pixel_Clk                 ),
//     .rst_n                   ( rst_n               ),
//     .I_app_image_h             ( I_app_image_h  [15:0] ),
//     .I_app_image_w             ( I_app_image_w  [15:0] ),
//     .I_app_en                  ( I_app_en              ),

//     .O_Fval             ( O_Fval         ),
//     .O_Lval              ( O_Lval          ),
//     .O_Dval              ( O_Dval          ),
//     .O_Pixel_data                    ( O_Pixel_data         [15:0] ),
//     .O_line_cnt                ( O_line_cnt     [11:0] ),
//     .O_pixel_cnt               ( O_pixel_cnt    [11:0] )
// );


module Timing_Gen (
    input             I_Pixel_Clk,
    input             rst_n,
    input      [15:0] I_app_image_h,
    input      [15:0] I_app_image_w,
    input             I_app_en,
    output reg        O_Fval,
    output reg        O_Lval,
    output reg        O_Dval,
    output reg [15:0] O_Pixel_data,
    output reg [11:0] O_line_cnt,
    output reg [11:0] O_pixel_cnt
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

  always @(posedge I_Pixel_Clk, negedge rst_n) begin
    if (!rst_n) S_STATE_CURRENT <= S_IDLE;
    else S_STATE_CURRENT <= S_STATE_NEXT;
  end
  reg [31:0] state_I_Pixel_Clk_cnt;
  always @(posedge I_Pixel_Clk, negedge rst_n) begin
    if (!rst_n) state_I_Pixel_Clk_cnt <= 32'd0;
    else if (S_STATE_NEXT != S_STATE_CURRENT) state_I_Pixel_Clk_cnt <= 32'd0;
    else state_I_Pixel_Clk_cnt <= state_I_Pixel_Clk_cnt + 1'd1;
  end
  always @(*) begin
    case (S_STATE_CURRENT)
      S_IDLE: begin
        if (I_app_en) S_STATE_NEXT = S_INTERGTAL;
        else S_STATE_NEXT = S_IDLE;
      end
      S_INTERGTAL: begin
        if (state_I_Pixel_Clk_cnt == Integration_T - 1) S_STATE_NEXT = S_WAIT0;
        else S_STATE_NEXT = S_INTERGTAL;
      end
      S_WAIT0: begin
        S_STATE_NEXT = S_READ;
      end
      S_READ: begin
        if (state_I_Pixel_Clk_cnt == I_app_image_w - 1) S_STATE_NEXT = S_WAIT1;
        else S_STATE_NEXT = S_READ;
      end
      S_WAIT1: begin
        if (O_line_cnt == I_app_image_h - 1) S_STATE_NEXT = S_IDLE;
        else S_STATE_NEXT = S_WAIT0;
      end
      default: S_STATE_NEXT = S_IDLE;
    endcase
  end
  /****************************************************/
  always @(posedge I_Pixel_Clk, negedge rst_n) begin
    if (!rst_n) begin
      O_line_cnt  <= 1'd0;
      O_pixel_cnt <= 1'd0;
    end else
      case (S_STATE_CURRENT)
        S_IDLE: begin
          O_line_cnt  <= 1'd0;
          O_pixel_cnt <= 1'd0;
        end
        S_INTERGTAL: begin
          O_line_cnt  <= 1'd0;
          O_pixel_cnt <= 1'd0;
        end
        S_WAIT0: begin
          O_line_cnt  <= O_line_cnt + 1'd1;
          O_pixel_cnt <= 1'd0;
        end
        S_READ: begin
          O_line_cnt  <= O_line_cnt;
          O_pixel_cnt <= O_pixel_cnt + 1'd1;
        end
        S_WAIT1: begin
          O_line_cnt  <= O_line_cnt;
          O_pixel_cnt <= 1'd0;

        end
        default: begin
        end
      endcase
  end
  /******************************************************/
  always @(posedge I_Pixel_Clk, negedge rst_n) begin
    if (!rst_n) O_Fval <= 1'b0;
    else if (S_STATE_CURRENT == S_IDLE || S_STATE_CURRENT == S_INTERGTAL) O_Fval <= 1'b0;
    else O_Fval <= 1'b1;
  end
  always @(posedge I_Pixel_Clk, negedge rst_n) begin
    if (!rst_n) O_Lval <= 1'b0;
    else if (S_STATE_CURRENT == S_READ) O_Lval <= 1'b1;
    else O_Lval <= 1'b0;
  end
  always @(posedge I_Pixel_Clk, negedge rst_n) begin
    if (!rst_n) O_Dval <= 1'b0;
    else if (S_STATE_CURRENT == S_READ) O_Dval <= 1'b1;
    else O_Dval <= 1'b0;
  end
  always @(posedge I_Pixel_Clk, negedge rst_n) begin
    if (!rst_n) O_Pixel_data <= 'b0;
    else if (S_STATE_CURRENT == S_READ) O_Pixel_data <= O_Pixel_data + 1'b1;
    else if (S_STATE_CURRENT == S_IDLE) O_Pixel_data <= 'b0;
    else O_Pixel_data <= O_Pixel_data;
  end
  /******************************************************/

endmodule
