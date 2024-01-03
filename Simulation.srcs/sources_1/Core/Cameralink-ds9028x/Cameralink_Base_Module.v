`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/28 17:41:07
// Design Name: 
// Module Name: Cameralink_Base_Module
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

module Cameralink_Base_Module (
    //base
    input         I_Pixel_clk,
    input  [15:0] I_Pixel_R,
    input         I_Pixel_Fval,
    input         I_Pixel_Lval,
    input         I_Pixel_Dval,
    //out
    output [27:0] O_X_FPGA_DATA,
    output        O_X_FPGA_PWD_N,
    output        O_X_FPGA_TX_CLK
);

  wire [7:0] W_Port_A;
  wire [7:0] W_Port_B;
  wire [7:0] W_Port_C;

  assign W_Port_A[7:0]   = I_Pixel_R[7:0];
  assign W_Port_B[7:0]   = I_Pixel_R[15:8];
  assign W_Port_C[7:0]   = 8'd0;


  assign O_X_FPGA_PWD_N  = 1'b1;
  assign O_X_FPGA_TX_CLK = I_Pixel_clk;

  Cameralink_Base_Route u_Cameralink_Base_Route (
      .Port_A(W_Port_A[7:0]),
      .Port_B(W_Port_B[7:0]),
      .Port_C(W_Port_C[7:0]),
      .X_Fval(I_Pixel_Fval),
      .X_Lval(I_Pixel_Lval),
      .X_Dval(I_Pixel_Dval),

      .X_FPGA_DATA(O_X_FPGA_DATA[27:0])
  );
endmodule
