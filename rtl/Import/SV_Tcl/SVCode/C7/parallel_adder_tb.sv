timeunit 1ns;
timeprecision 1ps;

module parallel_adder_tb;

  parameter N = 4;
  parameter W = 8;
  parameter shortreal PERIOD = 5.0;
  parameter NUM = 16;

  bit clk;
  logic signed [W - 1 : 0] a [N];
  logic signed [W - 1 : 0] b [N];
  logic signed [W - 1 : 0] sum [N];

  parallel_adder #(.N(N), .W(W)) i_parallel_adder (.*);

  initial begin
    clk = 0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  default clocking cb @(posedge clk);
    default input #1step output #0;
    input sum;
    output a, b;
  endclocking

  initial begin
    a <= '{default : '0};
    b <= '{default : '0};
    for (int i = 0; i < NUM; i++) begin
      ##1
        cb.a <= '{$urandom_range(-8, 7), $urandom_range(-4, 4), $urandom_range(-5, 5), $urandom_range(-6, 6)};
        cb.b <= '{$urandom_range(-8, 7), $urandom_range(-4, 4), $urandom_range(-5, 5), $urandom_range(-6, 6)};
    end
    repeat (4) @cb;
    $stop;
  end
endmodule


