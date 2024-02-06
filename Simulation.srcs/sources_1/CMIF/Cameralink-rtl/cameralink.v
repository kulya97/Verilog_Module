`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/01 14:52:03
// Design Name: 
// Module Name: cameralink
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


module cameralink (
    input         clk37_125,
    input         clk_259_875,
    input         rst_n,
    input         i_vsync,
    input         i_hsync,
    input  [15:0] i_data_16,
    output [ 4:0] CAM_BUS_p,
    output [ 4:0] CAM_BUS_n
);
  wire [34:0] txdata;
  data_code u4_1_data_code (
      .clk       (clk37_125),
      .rst_n     (rst_n),
      .data      (i_data_16),
      .frame_flag(i_vsync),
      .data_flag (i_hsync),

      .txclkin(),
      .txdata (txdata)
  );
  cameralink_lvds_tx u4_2_cameralink_lvds_tx (
      //input interface
      .I_clk_pix (clk37_125),    //时钟输入
      .I_clk_lvds(clk_259_875),  //cameralink传输时钟	7 x I_clk_pix
      .I_rst_n   (rst_n),        //复位信号
      .I_data    (txdata),       //cameralink信号
      //output interface
      .O_lvds_P  (CAM_BUS_p),    //cameralink差分输出
      .O_lvds_N  (CAM_BUS_n)     //cameralink差分输出
  );
endmodule
