timeunit 1ns;
timeprecision 1ps;

class rand_data 
#(
  parameter DW = 4
);

  rand bit signed [DW - 1 : 0] acc_in;
endclass

module acc_v2_tb;

  parameter shortreal PERIOD = 5.0;
  parameter DW = 4;
  parameter N  = 4;
  parameter ACCW = DW + $clog2(N);

  bit clk;
  logic ce, bypass;
  logic signed [DW - 1 : 0] acc_in;
  logic signed [ACCW - 1 : 0] acc_out;

  rand_data #(.DW(DW)) i_rand_data;
  acc_v2 #(.DW(DW), .ACCW(ACCW)) i_acc_v2 (.*);

  default clocking cb @(posedge clk);
    default input #1step output #0;
    output ce, bypass, acc_in;
    input acc_out;
  endclocking

  initial begin
    clk = 0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  initial begin
    i_rand_data = new;
    ce  <= '0;
    bypass <= '0;
    acc_in <= '0;
    for (int i = 0; i < 4 * N; i++) begin
      i_rand_data.randomize();
      ##1 cb.acc_in <= i_rand_data.acc_in;
          if (i % 8 == 0)
            cb.ce <= '0;
          else
            cb.ce <= '1;
          if (i % 4 == 0)
            cb.bypass <= '1;
          else
            cb.bypass <= '0;
    end
    repeat (2) @cb;
    $stop;
  end
endmodule


