timeunit 1ns;
timeprecision 1ps;

module counter4_tb;

  bit clk;
  logic rst;
  logic [3 : 0] cnt;

  counter4 i_counter4 (.*);

  initial begin
    clk = '0;
    forever #2.5 clk = ~clk;
  end

  initial begin
    rst = '0;
    #53 rst = '1;
    #58 rst = '0;
  end
endmodule
