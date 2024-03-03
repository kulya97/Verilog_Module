timeunit 1ns;
timeprecision 1ps;

module moore_detector_tb;

  parameter shortreal PERIOD = 2.5;
  parameter NUM = 8;

  bit clk;
  logic rst, sin, done;

  //moore_detector_v1 i_moore_detector (.*);
  //moore_detector_v2 i_moore_detector (.*);
  //moore_detector_v3 i_moore_detector (.*);
  mealy_detector_v4 i_mealy_detector (.*);

  default clocking cb @(posedge clk);
    default input #1step output #0;
    input done;
    output rst, sin;
  endclocking

  initial begin
    clk = '0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  initial begin
    rst <= '1;
    sin <= '0;
    ##2
    cb.rst <= '0;
    for (int i = 0; i < NUM; i++) begin
      ##1 cb.sin <= '1;
      ##1 cb.sin <= '1;
      ##1 cb.sin <= '0;
      ##1 cb.sin <= '1;
      ##1 cb.sin <= '0;
      ##1 cb.sin <= '1;
      ##1 cb.sin <= '1;
      ##1 cb.sin <= '0;
      ##1 cb.sin <= '0;
    end
    ##1 $stop;
  end
endmodule

