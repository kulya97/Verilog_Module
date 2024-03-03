`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/02/12 14:18:45
// Design Name: 
// Module Name: intel_8080
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


module intel_8080 (
    input         sys_clk,    //50M
    input         rst_n,
    /**************************/
    input         app_valid,
    input  [16:0] app_din,
    /**************************/
    output        bus_DC,
    output        bus_WR,
    output [15:0] bus_DATA
);
  reg        valid;
  reg [16:0] din;
  /**************************/
  always @(posedge sys_clk, negedge rst_n) begin
    if (!rst_n) begin
      valid <= 1'd0;
      din   <= 17'd0;
    end else begin
      valid <= app_valid;
      din   <= app_din;
    end
  end
  assign bus_WR   = valid ? (!sys_clk) : 1'b1;
  assign bus_DC   = din[16];
  assign bus_DATA = din[15:0];
endmodule
