`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/18 15:01:06
// Design Name: 
// Module Name: always_for_test
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


module always_for_test (
    input            sys_clk,
    input            sys_rst_n,
    input      [7:0] indata_a,
    output reg [7:0] outdata_b
);
  integer       i;
  reg     [3:0] a = 4'd0;
  always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) outdata_b <= 0;
    else begin
      if (a <= 4'd8) begin
        for (i = 0; i < 8; i = i + 1) begin
          outdata_b[i] <= indata_a[i];
        end
        a <= a + 1'b1;
      end
      //outdata_b <= outdata_b;
    end
  end

endmodule
