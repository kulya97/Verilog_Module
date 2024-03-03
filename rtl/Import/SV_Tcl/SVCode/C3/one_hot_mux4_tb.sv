timeunit 1ns;
timeprecision 1ps;


class rand_data #(parameter W = 4);
  rand bit [W - 1 : 0] a0, a1, a2, a3;
  randc bit [3 : 0] s;
  constraint c_a0 { a0 > 0; a0 < 4;}
  constraint c_a1 { a1 > 4; a1 < 8;}
  constraint c_a2 { a1 > 8; a1 < 12;}
  constraint c_a3 { a1 > 12; a1 < 15;}
endclass

module one_hot_mux4_tb;
 
  parameter NUM = 16;
  parameter W = 4;
  logic [3 : 0] s;
  logic [W - 1 : 0] a0, a1, a2, a3;
  logic [W - 1 : 0] y;

  rand_data #(.W(W)) i_rand_data;
  one_hot_mux4 #(.W(W)) i_one_hot_mux4 (.*);

  initial begin
    a0 <= '0;
    a1 <= '0;
    a2 <= '0;
    a3 <= '0;
    s  <= '0;
    i_rand_data = new();
    for (int i = 0; i < NUM; i++) begin
      i_rand_data.randomize();
      #5 a0 <= i_rand_data.a0;
         a1 <= i_rand_data.a1;
         a2 <= i_rand_data.a2;
         a3 <= i_rand_data.a3;
         s  <= i_rand_data.s;
    end
    $stop;
  end
endmodule  
