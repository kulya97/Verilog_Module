timeunit 1ns;
timeprecision 1ps;

module square_tb;

  parameter W = 17;
  parameter shortreal PERIOD = 5.0;
  parameter NUM = 8;
  
  bit clk;
  logic signed [W - 1 : 0] ain, bin;
  logic signed [2 * W + 1 : 0] pout;

  square #(.W(W)) i_square (.*);

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
          cb.bin <= $urandom_range(-20, 20);
    end
    repeat (4) @cb;
    $stop;
  end
endmodule
