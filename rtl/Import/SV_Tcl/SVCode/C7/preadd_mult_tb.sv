timeunit 1ns;
timeprecision 1ps;

module preadd_mult_tb;

  parameter AW = 16;
  parameter BW = 16;
  parameter shortreal PERIOD = 5.0;
  parameter NUM = 8;
  parameter MW = AW + 1 + BW;

  bit clk;
  logic rst;
  logic ce;

  logic signed [AW - 1 : 0] ain;
  logic signed [AW - 1 : 0] din;
  logic signed [BW - 1 : 0] bin;
  logic signed [MW - 1 : 0] pout;

  preadd_mult #(.AW(AW), .BW(BW)) i_preadd_mult (.*);

  initial begin
    clk = '0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  default clocking cb @(posedge clk);
    default input #1step output #0;
    output rst, ce, ain, bin, din;
    input pout;
  endclocking

  initial begin
    rst <= '0;
    ce  <= '0;
    ain <= '0;
    bin <= '0;
    din <= '0;
    ##1 cb.rst <= '1;
    ##1 cb.rst <= '0;
    for (int i = 0; i < NUM; i++) begin
      ##1 cb.ce <= '1;
          cb.ain <= $urandom_range(-10, 10);
          cb.bin <= $urandom_range(-10, 10);
          cb.din <= $urandom_range(-10, 10);
    end
    repeat (4) @cb;
    $stop;
  end
endmodule

