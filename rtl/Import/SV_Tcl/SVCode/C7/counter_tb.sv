timeunit 1ns;
timeprecision 1ps;

module counter_tb;
  parameter W = 16;
  parameter CNT_MAX = 16;
  parameter STEP = 2;
  parameter shortreal PERIOD = 5.0;
  parameter NUM = 50;

  bit clk;
  logic rst;
  logic [W - 1 : 0] cnt;

  counter #(.W(W), .STEP(STEP), .CNT_MAX(CNT_MAX)) i_counter (.*);

  initial begin
    clk = 0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  default clocking cb @(posedge clk);
    default input #1step output #0;
    output rst;
    input cnt;
  endclocking

  initial begin
    rst <= '0;
    ##1 cb.rst <= '1;
    ##1 cb.rst <= '0;
    repeat (NUM) @cb;
    $stop;
  end
endmodule
