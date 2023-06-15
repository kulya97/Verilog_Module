`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/05 17:17:08
// Design Name: 
// Module Name: Cameralink_36bit_Medium_Module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 36bit的cameralink数据
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
// Cameralink_36bit_Medium_Module  u_Cameralink_36bit_Medium_Module (
//     .I_Pixel_R                  ( I_Pixel_R       [11:0] ),
//     .I_Pixel_G                  ( I_Pixel_G       [11:0] ),
//     .I_Pixel_B                  ( I_Pixel_B       [11:0] ),

//     .X_FPGA_DATA             ( X_FPGA_DATA  [27:0] ),
//     .Y_FPGA_DATA             ( Y_FPGA_DATA  [27:0] ),
//     .Z_FPGA_DATA             ( Z_FPGA_DATA  [27:0] )
// );


module Cameralink_36bit_Medium_Module (  //base
    input         I_Pixel_clk,
    input  [11:0] I_Pixel_R,
    input  [11:0] I_Pixel_G,
    input  [11:0] I_Pixel_B,
    input         I_Pixel_Fval,
    input         I_Pixel_Lval,
    input         I_Pixel_Dval,
    //out
    output [27:0] O_X_FPGA_DATA,
    output        O_X_FPGA_PWD_N,
    output        O_X_FPGA_TX_CLK,
    output [27:0] O_Y_FPGA_DATA,
    output        O_Y_FPGA_PWD_N,
    output        O_Y_FPGA_TX_CLK,
    output [27:0] O_Z_FPGA_DATA,
    output        O_Z_FPGA_PWD_N,
    output        O_Z_FPGA_TX_CLK
);
  wire [7:0] W_Port_A;
  wire [7:0] W_Port_B;
  wire [7:0] W_Port_C;
  wire [7:0] W_Port_D;
  wire [7:0] W_Port_E;
  wire [7:0] W_Port_F;
  wire [7:0] W_Port_G;
  wire [7:0] W_Port_H;

  assign W_Port_A[7:0] = I_Pixel_R[7:0];
  assign W_Port_B[7:0] = {I_Pixel_B[11:8], I_Pixel_R[11:8]};
  assign W_Port_C[7:0] = I_Pixel_B[7:0];
  assign W_Port_D[7:0] = 8'd0;
  assign W_Port_E[7:0] = I_Pixel_G[7:0];
  assign W_Port_F[7:0] = {4'd0, I_Pixel_G[11:8]};
  assign W_Port_G[7:0] = 8'd0;
  assign W_Port_H[7:0] = 8'd0;

  assign O_X_FPGA_PWD_N  = 1'b1;
  assign O_X_FPGA_TX_CLK = I_Pixel_clk;
  assign O_Y_FPGA_PWD_N  = 1'b1;
  assign O_Y_FPGA_TX_CLK = I_Pixel_clk;
  assign O_Z_FPGA_PWD_N  = 1'b1;
  assign O_Z_FPGA_TX_CLK = I_Pixel_clk;


  Cameralink_Route_Module u_Cameralink_Route_Module (
      .Port_A(W_Port_A[7:0]),
      .Port_B(W_Port_B[7:0]),
      .Port_C(W_Port_C[7:0]),
      .X_Fval(I_Pixel_Fval),
      .X_Lval(I_Pixel_Lval),
      .X_Dval(I_Pixel_Dval),
      .Port_D(W_Port_D[7:0]),
      .Port_E(W_Port_E[7:0]),
      .Port_F(W_Port_F[7:0]),
      .Y_Fval(I_Pixel_Fval),
      .Y_Lval(I_Pixel_Lval),
      .Y_Dval(I_Pixel_Dval),
      .Port_G(W_Port_G[7:0]),
      .Port_H(W_Port_H[7:0]),
      .Z_Fval(I_Pixel_Fval),
      .Z_Lval(I_Pixel_Lval),
      .Z_Dval(I_Pixel_Dval),

      .X_FPGA_DATA(O_X_FPGA_DATA[27:0]),
      .Y_FPGA_DATA(O_Y_FPGA_DATA[27:0]),
      .Z_FPGA_DATA(O_Z_FPGA_DATA[27:0])
  );
endmodule
