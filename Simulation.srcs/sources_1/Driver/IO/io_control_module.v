`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/14 10:05:54
// Design Name: 
// Module Name: io_control_module
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


module io_control_module (
    input             clk,
    input             rst_n,
    input      [31:0] app_din,
    input             app_req,
    output reg        app_ack,
    output reg        IO
);
  parameter ADDRESS_IO = 16'hdac3;
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) IO <= 1'b0;
    else if (app_req && app_din[31:16] == ADDRESS_IO && app_din[15:0] == 16'h0000) IO <= 1'b0;
    else if (app_req && app_din[31:16] == ADDRESS_IO) IO <= 1'b1;
    else IO <= IO;
  end
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) app_ack <= 1'd0;
    else app_ack <= app_req;
  end
endmodule
