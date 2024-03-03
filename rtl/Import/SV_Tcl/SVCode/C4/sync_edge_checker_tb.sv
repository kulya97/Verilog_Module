timeunit 1ns;
timeprecision 1ps;

module sync_edge_checker_tb;

  parameter shortreal PERIOD = 2.5;
  parameter NUM = 16;

  bit clk;
  logic rst;
  logic siga;
  logic siga_rise_edge;
  logic siga_fall_edge;
  logic siga_both_edge;

  sync_edge_checker i_sync_edge_checker (.*);

  default clocking cb @(posedge clk);
    default input #1step output #0.1;
    input siga_rise_edge, siga_fall_edge, siga_both_edge;
    output rst, siga;
  endclocking

  initial begin
    clk = '0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  initial begin
    rst <= '1;
    siga <= '0;
    ##1
    rst <= '0;
    for (int i = 0; i < NUM; i++) begin
      ##1
      if (i == 4 || i == 10)
        cb.siga <= '0;
      else
        cb.siga <= '1;
    end
    ##1 $stop;
  end
endmodule
