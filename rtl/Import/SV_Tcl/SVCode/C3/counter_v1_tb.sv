timeunit 1ns;
timeprecision 1ps;

module counter_v1_tb;

  parameter W = 4;
  parameter CNT_MAX = 12;
  parameter shortreal PERIOD = 2.5;
  parameter NUM = 32;

  bit clk;
  logic rst, ce;
  logic [W - 1 : 0] cnt;

  counter_v1 #(.W(W), .CNT_MAX(CNT_MAX)) i_counter_v1 (.*);

  default clocking cb @(posedge clk);
    default input #1step output #0.5;
    input cnt;
    output rst, ce;
  endclocking

  initial begin
    clk = '0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  initial begin
    rst <= '1;
    ce  <= '0;
    ##1
    cb.rst <= '0;
    for (int i = 0; i < NUM; i++) begin
      ##1 cb.ce <= i[0];
    end
    ##1 $stop;
  end
endmodule



      
