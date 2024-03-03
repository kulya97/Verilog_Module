timeunit 1ns;
timeprecision 1ps;

module dot_prod_tb;
  parameter AW = 9;
  parameter BW = 9;
  parameter shortreal PERIOD = 5;
  parameter NUM = 16;

  bit clk;
  logic signed [AW - 1 : 0] a0, a1, a2;
  logic signed [BW - 1 : 0] b0, b1, b2;
  logic signed [AW + BW + 1 : 0] p;

  dot_prod #(.AW(AW), .BW(BW))
  i_dot_prod (.*);

  initial begin
    clk = '0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  default clocking cb @(posedge clk);
    default input #1step output #0;
    output a0, a1, a2, b0, b1, b2;
    input p;
  endclocking

  initial begin
    a0 <= '0;
    a1 <= '0;
    a2 <= '0;
    b0 <= '0;
    b1 <= '0;
    b2 <= '0;
    for (int i = 0; i < NUM; i++) begin
      ##1 cb.a0 <= $urandom_range(-10, 10);
          cb.a1 <= $urandom_range(-10, 10);
          cb.a2 <= $urandom_range(-10, 10);
          cb.b0 <= $urandom_range(-10, 10);
          cb.b1 <= $urandom_range(-10, 10);
          cb.b2 <= $urandom_range(-10, 10);
    end
    repeat (4) @cb;
    $stop;
  end
endmodule


