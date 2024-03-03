timeunit 1ns;
timeprecision 1ps;

class rand_data;
  rand bit [1 : 0] id;
  //constraint c_id { id dist {0 :/10, [1 : 2] :/75, 3 :/15};}
endclass

module array_cmp_tb;

  parameter shortreal PERIOD = 2.5;
  parameter W = 6;
  parameter NUM = 16;

  bit clk;
  logic rst, ce;
  logic [1 : 0] id, min_id;

  array_cmp_v3 #(.W(W)) i_array_cmp_v3 (.*);
  rand_data i_rand_data;

  default clocking cb @(posedge clk);
    default input #1step output #0;
    input min_id;
    output rst, ce, id;
  endclocking

  initial begin
    clk = '0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  initial begin
    i_rand_data = new();
    rst <= '1;
    ce  <= '0;
    id  <= '0;
    ##1 cb.rst <= '0;
        cb.ce  <= '1;
        cb.id  <= '1;
    for (int i = 0; i < NUM; i++) begin
      i_rand_data.randomize();
      ##1 cb.id <= i_rand_data.id;
    end
    ##1 cb.ce <= '0;
    ##1 $stop;
  end
endmodule


