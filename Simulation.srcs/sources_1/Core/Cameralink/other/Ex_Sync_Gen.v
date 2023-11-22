`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/07 14:40:53
// Design Name: 
// Module Name: Ex_Sync_Gen
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


module Ex_Sync_Gen (
    input  I_Clk_50m,
    input  I_rstn,
    input  I_en,
    output O_C1_EX,
    output O_C2_EX,
    output O_C3_EX
);
  //parameter CLK_FRE=50;
  localparam CNT_25Hz = 32'd1_000_000;
  reg [31:0] clk_cnt;
  always @(posedge I_Clk_50m, negedge I_rstn) begin
    if (!I_rstn) clk_cnt <= 'd0;
    else if (clk_cnt == CNT_25Hz - 1) clk_cnt <= 'd0;
    else clk_cnt <= clk_cnt + 1'b1;
  end
  reg R_EX;
  always @(posedge I_Clk_50m, negedge I_rstn) begin
    if (!I_rstn) R_EX <= 'd0;
    else if (clk_cnt == CNT_25Hz - 1) R_EX <= !R_EX;
    else R_EX <= R_EX;
  end
  assign O_C1_EX = R_EX;
  assign O_C2_EX = R_EX;
  assign O_C3_EX = R_EX;

endmodule
