timeunit 1ns;
timeprecision 1ps;

module dynamic_square_tb;

  parameter W = 17;
  parameter shortreal PERIOD = 5.0;
  parameter NUM = 8;
  
  bit clk;
  logic subadd;
  logic signed [W - 1 : 0] ain, bin;
  logic signed [2 * W + 1 : 0] pout;

  dynamic_square #(.W(W)) i_dynamic_square (.*);

  initial begin
    clk = '0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  default clocking cb @(posedge clk);
    default input #1step output #0;
    output subadd, ain, bin;
    input pout;
  endclocking

  initial begin
    subadd <= '0;
    ain <= '0;
    bin <= '0;
    for (int i = 0; i < NUM / 2; i++) begin
      ##1 cb.subadd <= '0;
          cb.ain <= $urandom_range(-10, 10);
          cb.bin <= $urandom_range(-20, 20);
    end
    for (int i = 0; i < NUM / 2; i++) begin
      ##1 cb.subadd <= '1;
          cb.ain <= $urandom_range(-10, 10);
          cb.bin <= $urandom_range(-20, 20);
    end
    repeat (4) @cb;
    $stop;
  end
endmodule
