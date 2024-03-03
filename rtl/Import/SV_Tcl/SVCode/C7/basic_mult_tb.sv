timeunit 1ns;
timeprecision 1ps;

module basic_mult_tb;

  parameter AW = 27;
  parameter BW = 18;
  parameter MW = AW + BW;
  parameter shortreal PERIOD = 5.0;
  parameter NUM = 16;

  bit clk;
  logic ce;
  logic signed [AW - 1 : 0] ain;
  logic signed [BW - 1 : 0] bin;
  logic signed [MW - 1 : 0] prod;

  basic_mult #(.AW(AW), .BW(BW)) i_basic_mult (.*);

  initial begin
    clk = '0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  default clocking cb @(posedge clk);
    default input #1step output #0;
    output ce, ain, bin;
    input prod;
  endclocking

  initial begin
    ce <= '0;
    ain <= '0;
    bin <= '0;
    for (int i = 0; i < 2; i++) begin
      ##1 cb.ce <= '1;
          cb.ain <= $urandom_range(-10, 10);
          cb.bin <= $urandom_range(-10, 10);
      ##1 cb.ce <= '0;
          cb.ain <= $urandom_range(-10, 10);
          cb.bin <= $urandom_range(-10, 10);
    end
    for (int i = 0; i < 4; i++) begin
      ##1 cb.ce <= '1;
          cb.ain <= $urandom_range(-10, 10);
          cb.bin <= $urandom_range(-10, 10);
    end
    repeat (4) @cb;
    $stop;
  end
endmodule






  
