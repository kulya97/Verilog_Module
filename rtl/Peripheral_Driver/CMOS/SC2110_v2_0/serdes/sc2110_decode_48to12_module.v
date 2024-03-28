`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NJUST
// Engineer: huangwenjie
// 
// Create Date: 2023/12/12 09:02:11
// Design Name: 
// Module Name: sc2110_decode_48to12_module
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


module sc2110_decode_48to12_module (
    input         i_clk,
    input         i_rstn,
    input         i_dvld,
    input  [47:0] i_data,
    output [11:0] o_data,
    output        o_dvld

);
  reg [11:0] r_channel_data0;
  reg [11:0] r_channel_data1;
  reg [11:0] r_channel_data2;
  reg [11:0] r_channel_data3;
  reg [ 3:0] r_clk_cnt;

  reg [11:0] r_data_out;
  reg        r_data_valid;

  assign o_data[11:0] = r_data_out[11:0];
  assign o_dvld       = r_data_valid;
  /***************************************************************************/
  always @(posedge i_clk, negedge i_rstn) begin
    if (!i_rstn) r_channel_data0[11:0] <= 12'd0;
    else r_channel_data0[11:0] <= {i_data[7], i_data[3], i_data[15], i_data[11], i_data[23], i_data[19], i_data[31], i_data[27], i_data[39], i_data[35], i_data[47], i_data[43]};
  end
  always @(posedge i_clk, negedge i_rstn) begin
    if (!i_rstn) r_channel_data1[11:0] <= 12'd0;
    else r_channel_data1[11:0] <= {i_data[6], i_data[2], i_data[14], i_data[10], i_data[22], i_data[18], i_data[30], i_data[26], i_data[38], i_data[34], i_data[46], i_data[42]};
  end
  always @(posedge i_clk, negedge i_rstn) begin
    if (!i_rstn) r_channel_data2[11:0] <= 12'd0;
    else r_channel_data2[11:0] <= {i_data[5], i_data[1], i_data[13], i_data[9], i_data[21], i_data[17], i_data[29], i_data[25], i_data[37], i_data[33], i_data[45], i_data[41]};
  end
  always @(posedge i_clk, negedge i_rstn) begin
    if (!i_rstn) r_channel_data3[11:0] <= 12'd0;
    else r_channel_data3[11:0] <= {i_data[4], i_data[0], i_data[12], i_data[8], i_data[20], i_data[16], i_data[28], i_data[24], i_data[36], i_data[32], i_data[44], i_data[40]};
  end
  /***************************************************************************/
  always @(posedge i_clk, negedge i_rstn) begin
    if (!i_rstn) r_clk_cnt <= 'd0;
    else if (i_dvld) r_clk_cnt <= 'd0;
    else r_clk_cnt <= r_clk_cnt + 1'd1;
  end

  always @(posedge i_clk, negedge i_rstn) begin
    if (!i_rstn) r_data_valid <= 1'b0;
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

  always @(posedge i_clk, negedge i_rstn) begin
    if (!i_rstn) r_data_out <= 12'b0;
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
