timeunit 1ns;
timeprecision 1ps;

module mult_add_v2_tb;

  parameter AW = 16;
  parameter BW = 16;
  parameter CW = 32;
  parameter PW = 48;
  parameter shortreal PERIOD = 5.0;
  parameter NUM = 16;

  bit clk;
  logic rst, ce;
  logic signed [AW - 1 : 0] ain;
  logic signed [BW - 1 : 0] bin;
  logic signed [CW - 1 : 0] cin;
  logic signed [PW - 1 : 0] pout;

  mult_add_v2 #(.AW(AW), .BW(BW), .CW(CW), .PW(PW))
  i_mult_add_v2 (.*);

  initial begin
    clk = '0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  default clocking cb @(posedge clk);
    default input #1step output #0;
    output rst, ce, ain, bin, cin;
    input pout;
  endclocking

  initial begin
    rst <= '0;
    ce  <= '0;
    ain <= '0;
    bin <= '0;
    cin <= '0;
    ##1 cb.rst <= '1;
    ##1 cb.rst <= '0;
    for (int i = 0; i < 2; i++) begin
      ##1 cb.ce <= '1;
          cb.ain <= $urandom_range(-10, 10);
          cb.bin <= $urandom_range(-10, 10);
          cb.cin <= $urandom_range(-10, 10);
      ##1 cb.ce <= '0;
          cb.ain <= $urandom_range(-10, 10);
          cb.bin <= $urandom_range(-10, 10);
          cb.cin <= $urandom_range(-10, 10);
    end
    for (int i = 0; i < 4; i++) begin
      ##1 cb.ce <= '1;
          cb.ain <= $urandom_range(-10, 10);
          cb.bin <= $urandom_range(-10, 10);
          cb.cin <= $urandom_range(-20, 20) + i;
    end
    repeat (4) @cb;
    $stop;
  end
endmodule


