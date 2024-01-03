`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/28 17:41:50
// Design Name: 
// Module Name: Cameralink_Base_Route
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


module Cameralink_Base_Route(
    //base
    input  [ 7:0] Port_A,
    input  [ 7:0] Port_B,
    input  [ 7:0] Port_C,
    input         X_Fval,
    input         X_Lval,
    input         X_Dval,
    //out
    output [27:0] X_FPGA_DATA
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

  assign X_FPGA_DATA[23] = 1'b0;
  assign X_FPGA_DATA[24] = X_Lval;
  assign X_FPGA_DATA[25] = X_Fval;
  assign X_FPGA_DATA[26] = X_Dval;

endmodule
