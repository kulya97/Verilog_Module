`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/30 16:56:59
// Design Name: 
// Module Name: Sync_Gen_module
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


module Sync_Gen_module (
    input  I_clk,
    input  I_rstn,
    input  I_bitslip_done,
    output O_bitslip_error,

    input I_data_valid,
    input [11:0] I_data,

    output O_cmos_clk,
    output O_cmos_frame_valid,
    output O_cmos_line_valid,
    output O_cmos_data_valid,
    output [11:0] O_cmos_data
);
  reg [11:0] r_data_d0;
  reg [11:0] r_data_d1;
  reg [11:0] r_data_d2;
  reg [11:0] r_data_d3;
  reg [11:0] r_data_d4;

  reg r_cmos_frame_valid;
  reg r_cmos_line_valid;
  reg [4:0] r_cmos_data_valid;

  always @(posedge I_clk, negedge I_rstn) begin
    if (!I_rstn) begin
      r_data_d0[11:0] <= 12'd0;
      r_data_d1[11:0] <= 12'd0;
      r_data_d2[11:0] <= 12'd0;
      r_data_d3[11:0] <= 12'd0;
      r_data_d4[11:0] <= 12'd0;
    end else begin
      r_data_d0[11:0] <= I_data[11:0];
      r_data_d1[11:0] <= r_data_d0[11:0];
      r_data_d2[11:0] <= r_data_d1[11:0];
      r_data_d3[11:0] <= r_data_d2[11:0];
      r_data_d4[11:0] <= r_data_d3[11:0];
    end
  end

  //r_cmos_frame_valid
  always @(posedge I_clk, negedge I_rstn) begin
    if (!I_rstn) r_cmos_frame_valid <= 1'b0;
    else if (r_data_d3[11:0]==12'hfff&&r_data_d2[11:0]==12'h000&&r_data_d1[11:0]==12'h000&&r_data_d0[11:0]==12'hab0)
      r_cmos_frame_valid <= 1'b0;
    else if (r_data_d3[11:0]==12'hfff&&r_data_d2[11:0]==12'h000&&r_data_d1[11:0]==12'h000&&r_data_d0[11:0]==12'hb60)
      r_cmos_frame_valid <= 1'b1;
    else r_cmos_frame_valid <= r_cmos_frame_valid;
  end

  //r_cmos_line_valid
  always @(posedge I_clk, negedge I_rstn) begin
    if (!I_rstn) r_cmos_line_valid <= 1'b0;
    else if (r_data_d3[11:0]==12'hfff&&r_data_d2[11:0]==12'h000&&r_data_d1[11:0]==12'h000&&r_data_d0[11:0]==12'h800)
      r_cmos_line_valid <= 1'b1;
    else if (r_data_d3[11:0]==12'hfff&&r_data_d2[11:0]==12'h000&&r_data_d1[11:0]==12'h000&&r_data_d0[11:0]==12'h9d0)
      r_cmos_line_valid <= 1'b0;
    else r_cmos_line_valid <= r_cmos_line_valid;
  end

  always @(posedge I_clk, negedge I_rstn) begin
    if (!I_rstn) r_cmos_data_valid <= 4'd0;
    else r_cmos_data_valid[4:0] = {r_cmos_data_valid[3:0], r_cmos_line_valid};
  end

  assign O_cmos_clk = I_clk;
  assign O_cmos_frame_valid = !r_cmos_frame_valid;
  assign O_cmos_line_valid = r_cmos_line_valid;
  assign O_cmos_data_valid = r_cmos_data_valid[3] && r_cmos_data_valid[0];
  assign O_cmos_data = r_data_d4;



endmodule
