timeunit 1ns;
timeprecision 1ps;

module mult_27x19_tb;

  parameter AW = 27;
  parameter BW = 19;
  parameter MW = AW + BW;
  parameter shortreal PERIOD = 5.0;
  parameter NUM = 16;

  bit clk;
  logic signed [AW - 1 : 0] ain;
  logic signed [BW - 1 : 0] bin;
  logic signed [MW - 1 : 0] pout;

  mult_27x19 i_mult_27x19 (.*);

  initial begin
    clk = '0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  default clocking cb @(posedge clk);
    default input #1step output #0;
    output ain, bin;
    input pout;
  endclocking

  initial begin
    ain <= '0;
    bin <= '0;
    for (int i = 0; i < NUM; i++) begin
      ##1 cb.ain <= $urandom_range(-10, 10);
          cb.bin <= $urandom_range(-10, 10);
    end
    repeat (4) @cb;
    $stop;
  end
endmodule






  
