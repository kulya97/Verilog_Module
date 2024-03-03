timeunit 1ns;
timeprecision 1ps;

class rand_data 
#(
  parameter DW = 4
);

  rand bit signed [DW - 1 : 0] acc_in;
endclass

module acc_v1_tb;

  parameter shortreal PERIOD = 5.0;
  parameter DW = 4;
  parameter N  = 4;
  parameter ACCW = DW + $clog2(N);

  bit clk;
  logic rst, ce;
  logic signed [DW - 1 : 0] acc_in;
  logic signed [ACCW - 1 : 0] acc_out;

  rand_data #(.DW(DW)) i_rand_data;
  acc_v1 #(.DW(DW), .ACCW(ACCW)) i_acc_v1 (.*);

  default clocking cb @(posedge clk);
    default input #1step output #0;
    output rst, ce, acc_in;
    input acc_out;
  endclocking

  initial begin
    clk = 0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  initial begin
    i_rand_data = new;
    rst <= '1;
    ce  <= '0;
    acc_in <= '0;
    ##1
    cb.rst <= '0;
    for (int i = 0; i < 4 * N; i++) begin
      i_rand_data.randomize();
      ##1 cb.acc_in <= i_rand_data.acc_in;
          ce <= '1;
          if (i % 4 == 0)
            cb.rst <= '1;
          else
            cb.rst <= '0;
    end
    repeat (2) @cb;
    $stop;
  end
endmodule


