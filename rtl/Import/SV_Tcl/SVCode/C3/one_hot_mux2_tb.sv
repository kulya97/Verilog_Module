timeunit 1ns;
timeprecision 1ps;


class rand_data #(parameter W = 4);
  rand bit [W - 1 : 0] a0, a1;
  randc bit [1 : 0] s;
  constraint c_a0 { a0 > 0; a0 < 7;}
  constraint c_a1 { a1 > 7; a1 < 15;}
endclass

module one_hot_mux2_tb;

  parameter NUM = 8;
  parameter W = 4;

  logic [1 : 0] s;
  logic [W - 1 : 0] a0, a1;
  logic [W - 1 : 0] y;

  rand_data #(.W(W)) i_rand_data;
  one_hot_mux2 #(.W(W)) i_one_hot_mux2 (.*);

  initial begin
    a0 <= '0;
    a1 <= '0;
    s  <= '0;
    i_rand_data = new();
    for (int i = 0; i < NUM; i++) begin
      i_rand_data.randomize();
      #5 a0 <= i_rand_data.a0;
         a1 <= i_rand_data.a1;
         s  <= i_rand_data.s;
    end
    $stop;
  end
endmodule
