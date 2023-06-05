`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/05 16:47:27
// Design Name: 
// Module Name: cameralink_full_route
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 用于cameralink数据信号的输出
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Cameralink_Route_Module (
    //base
    input  [ 7:0] Port_A,
    input  [ 7:0] Port_B,
    input  [ 7:0] Port_C,
    //medium
    input  [ 7:0] Port_D,
    input  [ 7:0] Port_E,
    input  [ 7:0] Port_F,
    //full
    input  [ 7:0] Port_G,
    input  [ 7:0] Port_H,
    //out
    output [27:0] X_FPGA_DATA,
    output [27:0] Y_FPGA_DATA,
    output [27:0] Z_FPGA_DATA

);
  assign X_FPGA_DATA[0]  = Port_A[0];
  assign X_FPGA_DATA[1]  = Port_A[1];
  assign X_FPGA_DATA[2]  = Port_A[2];
  assign X_FPGA_DATA[3]  = Port_A[3];
  assign X_FPGA_DATA[4]  = Port_A[4];
  assign X_FPGA_DATA[6]  = Port_A[5];
  assign X_FPGA_DATA[27] = Port_A[6];
  assign X_FPGA_DATA[5]  = Port_A[7];
  assign X_FPGA_DATA[7]  = Port_B[0];
  assign X_FPGA_DATA[8]  = Port_B[1];
  assign X_FPGA_DATA[9]  = Port_B[2];
  assign X_FPGA_DATA[12] = Port_B[3];
  assign X_FPGA_DATA[13] = Port_B[4];
  assign X_FPGA_DATA[14] = Port_B[5];
  assign X_FPGA_DATA[10] = Port_B[6];
  assign X_FPGA_DATA[11] = Port_B[7];
  assign X_FPGA_DATA[15] = Port_C[0];
  assign X_FPGA_DATA[18] = Port_C[1];
  assign X_FPGA_DATA[19] = Port_C[2];
  assign X_FPGA_DATA[20] = Port_C[3];
  assign X_FPGA_DATA[21] = Port_C[4];
  assign X_FPGA_DATA[22] = Port_C[5];
  assign X_FPGA_DATA[16] = Port_C[6];
  assign X_FPGA_DATA[17] = Port_C[7];

  assign Y_FPGA_DATA[0]  = Port_D[0];
  assign Y_FPGA_DATA[1]  = Port_D[1];
  assign Y_FPGA_DATA[2]  = Port_D[2];
  assign Y_FPGA_DATA[3]  = Port_D[3];
  assign Y_FPGA_DATA[4]  = Port_D[4];
  assign Y_FPGA_DATA[6]  = Port_D[5];
  assign Y_FPGA_DATA[27] = Port_D[6];
  assign Y_FPGA_DATA[5]  = Port_D[7];
  assign Y_FPGA_DATA[7]  = Port_E[0];
  assign Y_FPGA_DATA[8]  = Port_E[1];
  assign Y_FPGA_DATA[9]  = Port_E[2];
  assign Y_FPGA_DATA[12] = Port_E[3];
  assign Y_FPGA_DATA[13] = Port_E[4];
  assign Y_FPGA_DATA[14] = Port_E[5];
  assign Y_FPGA_DATA[10] = Port_E[6];
  assign Y_FPGA_DATA[11] = Port_E[7];
  assign Y_FPGA_DATA[15] = Port_F[0];
  assign Y_FPGA_DATA[18] = Port_F[1];
  assign Y_FPGA_DATA[19] = Port_F[2];
  assign Y_FPGA_DATA[20] = Port_F[3];
  assign Y_FPGA_DATA[21] = Port_F[4];
  assign Y_FPGA_DATA[22] = Port_F[5];
  assign Y_FPGA_DATA[16] = Port_F[6];
  assign Y_FPGA_DATA[17] = Port_F[7];

  assign Z_FPGA_DATA[0]  = Port_G[0];
  assign Z_FPGA_DATA[1]  = Port_G[1];
  assign Z_FPGA_DATA[2]  = Port_G[2];
  assign Z_FPGA_DATA[3]  = Port_G[3];
  assign Z_FPGA_DATA[4]  = Port_G[4];
  assign Z_FPGA_DATA[6]  = Port_G[5];
  assign Z_FPGA_DATA[27] = Port_G[6];
  assign Z_FPGA_DATA[5]  = Port_G[7];
  assign Z_FPGA_DATA[7]  = Port_H[0];
  assign Z_FPGA_DATA[8]  = Port_H[1];
  assign Z_FPGA_DATA[9]  = Port_H[2];
  assign Z_FPGA_DATA[12] = Port_H[3];
  assign Z_FPGA_DATA[13] = Port_H[4];
  assign Z_FPGA_DATA[14] = Port_H[5];
  assign Z_FPGA_DATA[10] = Port_H[6];
  assign Z_FPGA_DATA[11] = Port_H[7];
  assign Z_FPGA_DATA[15] = 1'b0;
  assign Z_FPGA_DATA[18] = 1'b0;
  assign Z_FPGA_DATA[19] = 1'b0;
  assign Z_FPGA_DATA[20] = 1'b0;
  assign Z_FPGA_DATA[21] = 1'b0;
  assign Z_FPGA_DATA[22] = 1'b0;
  assign Z_FPGA_DATA[16] = 1'b0;
  assign Z_FPGA_DATA[17] = 1'b0;
endmodule
