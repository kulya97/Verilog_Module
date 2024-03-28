`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NJUST
// Engineer: huangwenjie
// 
// Create Date: 2023/11/30 16:56:59
// Design Name: 
// Module Name: sc2110_sync_gen_module
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


module sc2110_sync_gen_module (
    input         i_clk,
    input         i_rstn,
    input         i_dvld,
    input  [11:0] i_data,
    output        o_cmos_fvld,
    output        o_cmos_lvld,
    output        o_cmos_dvld,
    output [11:0] O_cmos_data
);
  reg [11:0] r_data_d0;
  reg [11:0] r_data_d1;
  reg [11:0] r_data_d2;
  reg [11:0] r_data_d3;
  reg [11:0] r_data_d4;

  reg        r_cmos_frame_valid;
  reg        r_cmos_line_valid;
  reg [ 4:0] r_cmos_data_valid;
  reg [ 4:0] r_cmos_data_valid_d;

  always @(posedge i_clk, negedge i_rstn) begin
    if (!i_rstn) begin
      r_data_d0[11:0] <= 12'd0;
      r_data_d1[11:0] <= 12'd0;
      r_data_d2[11:0] <= 12'd0;
      r_data_d3[11:0] <= 12'd0;
      r_data_d4[11:0] <= 12'd0;
    end else if (i_dvld) begin
      r_data_d0[11:0] <= i_data[11:0];
      r_data_d1[11:0] <= r_data_d0[11:0];
      r_data_d2[11:0] <= r_data_d1[11:0];
      r_data_d3[11:0] <= r_data_d2[11:0];
      r_data_d4[11:0] <= r_data_d3[11:0];
    end
  end

  //r_cmos_frame_valid
  always @(posedge i_clk, negedge i_rstn) begin
    if (!i_rstn) r_cmos_frame_valid <= 1'b0;
    else if (r_data_d3[11:0] == 12'hfff && r_data_d2[11:0] == 12'h000 && r_data_d1[11:0] == 12'h000 && r_data_d0[11:0] == 12'hab0) r_cmos_frame_valid <= 1'b1;
    else if (r_data_d3[11:0] == 12'hfff && r_data_d2[11:0] == 12'h000 && r_data_d1[11:0] == 12'h000 && r_data_d0[11:0] == 12'hb60) r_cmos_frame_valid <= 1'b0;
    else r_cmos_frame_valid <= r_cmos_frame_valid;
  end

  //r_cmos_line_valid
  always @(posedge i_clk, negedge i_rstn) begin
    if (!i_rstn) r_cmos_line_valid <= 1'b0;
    else if (r_data_d3[11:0] == 12'hfff && r_data_d2[11:0] == 12'h000 && r_data_d1[11:0] == 12'h000 && r_data_d0[11:0] == 12'h800) r_cmos_line_valid <= 1'b1;
    else if (r_data_d3[11:0] == 12'hfff && r_data_d2[11:0] == 12'h000 && r_data_d1[11:0] == 12'h000 && r_data_d0[11:0] == 12'h9d0) r_cmos_line_valid <= 1'b0;
    else r_cmos_line_valid <= r_cmos_line_valid;
  end

  always @(posedge i_clk, negedge i_rstn) begin
    if (!i_rstn) r_cmos_data_valid <= 5'd0;
    else if (i_dvld) r_cmos_data_valid[4:0] <= {r_cmos_data_valid[3:0], r_cmos_line_valid};
  end

  always @(posedge i_clk, negedge i_rstn) begin
    if (!i_rstn) r_cmos_data_valid_d <= 5'd0;
    else r_cmos_data_valid_d[4:0] <= {r_cmos_data_valid_d[3:0], i_dvld};
  end


  assign o_cmos_fvld = r_cmos_frame_valid;
  assign o_cmos_lvld = r_cmos_data_valid[4] && r_cmos_data_valid[0];
  assign o_cmos_dvld = o_cmos_lvld && r_cmos_data_valid_d[0];
  assign O_cmos_data = r_data_d4;



endmodule
