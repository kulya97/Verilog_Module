`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NJUST
// Engineer: 黄文杰
// 
// Create Date: 2023/12/12 09:02:11
// Design Name: 
// Module Name: decode_48to12
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


module decode_48to12 (
    input        I_clk,
    input        I_rstn,
    input        I_slip_done,
    input        I_data_valid,
    input [47:0] I_data,

    output [11:0] O_data,
    output O_data_valid

);
  reg [11:0] r_channel_data0;
  reg [11:0] r_channel_data1;
  reg [11:0] r_channel_data2;
  reg [11:0] r_channel_data3;
  reg [3:0] r_clk_cnt;

  reg [11:0] r_data_out;
  reg r_data_valid;

  assign O_data[11:0] = r_data_out[11:0];
  assign O_data_valid = r_data_valid;
  /***************************************************************************/
  always @(posedge I_clk, negedge I_rstn) begin
    if (!I_rstn) r_channel_data0[11:0] <= 12'd0;
    else
      r_channel_data0[11:0] <= {
        I_data[7],
        I_data[3],
        I_data[15],
        I_data[11],
        I_data[23],
        I_data[19],
        I_data[31],
        I_data[27],
        I_data[39],
        I_data[35],
        I_data[47],
        I_data[43]
      };
  end
  always @(posedge I_clk, negedge I_rstn) begin
    if (!I_rstn) r_channel_data1[11:0] <= 12'd0;
    else
      r_channel_data1[11:0] <= {
        I_data[6],
        I_data[2],
        I_data[14],
        I_data[10],
        I_data[22],
        I_data[18],
        I_data[30],
        I_data[26],
        I_data[38],
        I_data[34],
        I_data[46],
        I_data[42]
      };
  end
  always @(posedge I_clk, negedge I_rstn) begin
    if (!I_rstn) r_channel_data2[11:0] <= 12'd0;
    else
      r_channel_data2[11:0] <= {
        I_data[5],
        I_data[1],
        I_data[13],
        I_data[9],
        I_data[21],
        I_data[17],
        I_data[29],
        I_data[25],
        I_data[37],
        I_data[33],
        I_data[45],
        I_data[41]
      };
  end
  always @(posedge I_clk, negedge I_rstn) begin
    if (!I_rstn) r_channel_data3[11:0] <= 12'd0;
    else
      r_channel_data3[11:0] <= {
        I_data[4],
        I_data[0],
        I_data[12],
        I_data[8],
        I_data[20],
        I_data[16],
        I_data[28],
        I_data[24],
        I_data[36],
        I_data[32],
        I_data[44],
        I_data[40]
      };
  end
  /***************************************************************************/
  always @(posedge I_clk, negedge I_rstn) begin
    if (!I_rstn) r_clk_cnt <= 'd0;
    else if (I_data_valid) r_clk_cnt <= 'd0;
    else r_clk_cnt <= r_clk_cnt + 1'd1;
  end

  always @(posedge I_clk, negedge I_rstn) begin
    if (!I_rstn) r_data_valid <= 1'b0;
    else
      case (r_clk_cnt)
        4'd00:   r_data_valid <= 1'b0;
        4'd01:   r_data_valid <= 1'b1;
        4'd02:   r_data_valid <= 1'b1;
        4'd03:   r_data_valid <= 1'b1;
        4'd04:   r_data_valid <= 1'b1;
        4'd05:   r_data_valid <= 1'b0;
        default: r_data_valid <= 1'b0;
      endcase
  end

  always @(posedge I_clk, negedge I_rstn) begin
    if (!I_rstn) r_data_out <= 12'b0;
    else
      case (r_clk_cnt)
        4'd00:   r_data_out <= 12'b0;
        4'd01:   r_data_out <= r_channel_data3;
        4'd02:   r_data_out <= r_channel_data2;
        4'd03:   r_data_out <= r_channel_data1;
        4'd04:   r_data_out <= r_channel_data0;
        4'd05:   r_data_out <= 12'b0;
        default: r_data_out <= 12'b0;
      endcase
  end
endmodule
