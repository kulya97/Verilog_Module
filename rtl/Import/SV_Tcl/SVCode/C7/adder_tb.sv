timeunit 1ns;
timeprecision 1ps;

module adder_tb;

  parameter DIW = 4;
  parameter DOW = DIW + 1;
  parameter type DTYPE = logic signed;
  parameter shortreal PERIOD = 5.0;
  parameter NUM = 16;

  bit clk;
  DTYPE [DIW - 1 : 0] ain;
  DTYPE [DIW - 1 : 0] bin;
  DTYPE [DOW - 1 : 0] sum;

  adder #(.DIW(DIW), .DTYPE(DTYPE)) i_adder (.*);

  initial begin
    clk = 0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  default clocking cb @(posedge clk);
    default input #1step output #0;
    output ain, bin;
    input sum;
  endclocking

  initial begin
    ain <= '0;
    bin <= '0;
    for (int i = 0; i < NUM; i++) begin
      ##1 cb.ain <= $urandom_range(-8, 7);
          cb.bin <= $urandom_range(-8, 7);
    end
    repeat (4) @cb;
    $stop;
  end
endmodule
 
