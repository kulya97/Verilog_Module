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


module Cameralink_36bit_Medium_Module (  //base
    input  [11:0] Data_R,
    input  [11:0] Data_G,
    input  [11:0] Data_B,
    //out
    output [27:0] X_FPGA_DATA,
    output [27:0] Y_FPGA_DATA,
    output [27:0] Z_FPGA_DATA
);


  wire [7:0] Port_A;
  wire [7:0] Port_B;
  wire [7:0] Port_C;
  wire [7:0] Port_D;
  wire [7:0] Port_E;
  wire [7:0] Port_F;
  wire [7:0] Port_G;
  wire [7:0] Port_H;

  assign Port_A[7:0] = Data_R[7:0];
  assign Port_B[7:0] = {Data_B[11:8], Data_R[11:8]};
  assign Port_C[7:0] = Data_B[7:0];
  assign Port_D[7:0] = 8'd0;
  assign Port_E[7:0] = Data_G[7:0];
  assign Port_F[7:0] = {4'd0, Data_G[7:0]};
  assign Port_G[7:0] = 8'd0;
  assign Port_H[7:0] = 8'd0;



  Cameralink_Route_Module u_Cameralink_Route_Module (
      .Port_A(Port_A[7:0]),
      .Port_B(Port_B[7:0]),
      .Port_C(Port_C[7:0]),
      .Port_D(Port_D[7:0]),
      .Port_E(Port_E[7:0]),
      .Port_F(Port_F[7:0]),
      .Port_G(Port_G[7:0]),
      .Port_H(Port_H[7:0]),

      .X_FPGA_DATA(X_FPGA_DATA[27:0]),
      .Y_FPGA_DATA(Y_FPGA_DATA[27:0]),
      .Z_FPGA_DATA(Z_FPGA_DATA[27:0])
  );
endmodule
