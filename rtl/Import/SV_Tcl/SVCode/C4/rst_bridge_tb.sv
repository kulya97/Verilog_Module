//File: rst_bridge_tb.sv
timeunit 1ns/1ns;

module rst_bridge_tb;

  parameter N = 4;
  parameter shortreal PERIOD = 5;

  logic clk = '0;
  logic aset;
  logic srst;

  rst_bridge #(.N(N)) i_rst_bridge(.*);

  always #(PERIOD/2) clk = ~clk;

  initial begin
    aset = '0;
    #4 aset = '1;
    #24 aset = '0;
  end
endmodule
