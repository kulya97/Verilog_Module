`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NJUST
// Engineer: huangwenjie
// 
// Create Date: 2023/12/01 14:24:38
// Design Name: 
// Module Name: sc2110_selectio_module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.02 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sc2110_selectio_module (
    input         i_rstn,
    input         i_lvds_clk,
    input  [ 7:0] i_lvds_data,
    input  [ 3:0] i_bitslip,
    output        o_data_valid,
    output [47:0] o_data
);



  reg [95:0] r_lvds_data_96bit_tmp;
  reg [47:0] r_lvds_data_48bit;
  reg [47:0] r_lvds_data_48bit_tmp;

  reg [ 3:0] r_data_clk_cnt;
  reg        r_data_valid;
  reg [47:0] r_data_out;
  reg [ 3:0] r_slip_cnt;
  /*****************************************************/
  assign o_data_valid = r_data_valid;
  assign o_data[47:0] = r_data_out[47:0];



  /****************************************************/
  always @(posedge i_lvds_clk, negedge i_rstn) begin
    if (!i_rstn) r_lvds_data_96bit_tmp <= 48'd0;
    else r_lvds_data_96bit_tmp[95:0] <= {r_lvds_data_96bit_tmp[87:0], i_lvds_data[7:0]};
  end

  /****************************************************/

  always @(posedge i_lvds_clk, negedge i_rstn) begin
    if (!i_rstn) r_slip_cnt <= 1'd0;
    else if (i_bitslip == 4'hf && r_slip_cnt < 4'd5) r_slip_cnt <= r_slip_cnt + 1'd1;
    else if (i_bitslip == 4'hf && r_slip_cnt == 4'd5) r_slip_cnt <= 1'd0;
    else r_slip_cnt <= r_slip_cnt;
  end

  always @(posedge i_lvds_clk, negedge i_rstn) begin
    if (!i_rstn) begin
      r_lvds_data_48bit <= 'd0;
    end else
      case (r_slip_cnt)
        4'd0: r_lvds_data_48bit <= {r_lvds_data_96bit_tmp[47:0]};
        4'd1: r_lvds_data_48bit <= {r_lvds_data_96bit_tmp[55:8]};
        4'd2: r_lvds_data_48bit <= {r_lvds_data_96bit_tmp[63:16]};
        4'd3: r_lvds_data_48bit <= {r_lvds_data_96bit_tmp[71:24]};
        4'd4: r_lvds_data_48bit <= {r_lvds_data_96bit_tmp[79:32]};
        4'd5: r_lvds_data_48bit <= {r_lvds_data_96bit_tmp[87:40]};
        default: r_lvds_data_48bit <= r_lvds_data_96bit_tmp[47:0];
      endcase
  end
  /****************************************************/
  always @(posedge i_lvds_clk, negedge i_rstn) begin
    if (!i_rstn) r_data_clk_cnt <= 1'd0;
    else if (r_data_clk_cnt >= 4'd5) r_data_clk_cnt <= 1'd0;
    else r_data_clk_cnt <= r_data_clk_cnt + 1'd1;
  end

  //
  always @(posedge i_lvds_clk, negedge i_rstn) begin
    if (!i_rstn) r_data_out[47:0] <= 48'd0;
    else if (r_data_clk_cnt == 4'd1) r_data_out[47:0] <= r_lvds_data_48bit[47:0];
    else r_data_out[47:0] <= r_data_out[47:0];
  end
  //
  always @(posedge i_lvds_clk, negedge i_rstn) begin
    if (!i_rstn) r_data_valid <= 1'b0;
    else if (r_data_clk_cnt == 4'd1) r_data_valid <= 1'b1;
    else r_data_valid <= 1'b0;
  end
  /****************************************************/
endmodule
