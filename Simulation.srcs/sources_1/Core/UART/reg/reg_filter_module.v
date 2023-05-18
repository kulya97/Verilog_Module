`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/18 16:06:50
// Design Name: 
// Module Name: reg_filter_module
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


module reg_filter_module #(
    parameter REG_WIDTH = 32
) (
    input                      clk,
    input                      rst_n,
    input      [REG_WIDTH-1:0] app_format,
    input      [REG_WIDTH-1:0] din,
    input                      req,
    output reg [REG_WIDTH-1:0] dout,
    output reg                 ack
);

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      ack  <= 1'b0;
      dout <= 'd0;
    end else if (req && din == app_format) begin
      ack  <= 1'b1;
      dout <= din;
    end else begin
      ack  <= 1'b0;
      dout <= dout;
    end
  end
endmodule
