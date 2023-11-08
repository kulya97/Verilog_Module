`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/06 15:03:13
// Design Name: 
// Module Name: Cam_regmap
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


module Cam_regmap  (
    input      [ 7:0] I_index,
    output reg [95:0] O_data
);

  /******************************************************/
  //初始化寄存器表
  always @(*) begin
    case (I_index)
      8'd00:   O_data[95:0] = {96'd1};
      8'd01:   O_data[95:0] = {96'd2};
      8'd02:   O_data[95:0] = {96'd3};
      8'd03:   O_data[95:0] = {96'd4};
      8'd04:   O_data[95:0] = {96'd5};
      8'd05:   O_data[95:0] = {96'd6};
      8'd06:   O_data[95:0] = {96'd7};
      8'd07:   O_data[95:0] = {96'd8};
      8'd07:   O_data[95:0] = {96'd9};
      8'd08:   O_data[95:0] = {96'd0};
      8'd09:   O_data[95:0] = {96'd0};
      8'd10:   O_data[95:0] = {96'd0};
      8'd11:   O_data[95:0] = {96'd0};
      8'd12:   O_data[95:0] = {96'd0};
      8'd13:   O_data[95:0] = {96'd0};
      8'd14:   O_data[95:0] = {96'd0};
      8'd15:   O_data[95:0] = {96'd0};
      8'd16:   O_data[95:0] = {96'd0};
      8'd17:   O_data[95:0] = {96'd0};
      8'd18:   O_data[95:0] = {96'd0};
      8'd19:   O_data[95:0] = {96'd0};
      8'd20:   O_data[95:0] = {96'd0};
      8'd21:   O_data[95:0] = {96'd0};
      8'd22:   O_data[95:0] = {96'd0};
      8'd23:   O_data[95:0] = {96'd0};
      8'd24:   O_data[95:0] = {96'd0};
      8'd25:   O_data[95:0] = {96'd0};
      8'd26:   O_data[95:0] = {96'd0};
      8'd27:   O_data[95:0] = {96'd0};
      default: O_data[95:0] = {96'd0};
    endcase
  end
  /******************************************************/
endmodule
