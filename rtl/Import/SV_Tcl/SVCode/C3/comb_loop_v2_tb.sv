timeunit 1ns;
timeprecision 1ps;

module comb_loop_v2_tb;

  parameter shortreal PERIOD = 2.5;

  bit clk;
  logic a;
  logic q;

  comb_loop_v2 icomb_loop_v2 (.*);

  default clocking cb @(posedge clk);
    default input #1step output #0.5;
    input q;
    output a;
  endclocking

  initial begin
    clk = '0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  initial begin
    a <= '0;
    ##1 cb.a <= '1;
    ##2 cb.a <= '0;
    ##3 cb.a <= '1;
    ##1 $stop;
  end
endmodule

