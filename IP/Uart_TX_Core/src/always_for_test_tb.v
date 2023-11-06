`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/18 15:01:34
// Design Name: 
// Module Name: always_for_test_tb
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


module always_for_test_tb;
  reg        sys_clk = 0;
  reg        sys_rst_n = 0;
  reg  [7:0] indata_a;
  wire [7:0] outdata_b;


  initial begin
    indata_a  = 8'b1001_0110;
    #10;
    sys_rst_n = 1'b1;
  end

  always #(6) sys_clk = !sys_clk;

  always_for_test always_for_test_inst (
      .sys_clk  (sys_clk),
      .sys_rst_n(sys_rst_n),
      .indata_a (indata_a),
      .outdata_b(outdata_b)
  );
endmodule

