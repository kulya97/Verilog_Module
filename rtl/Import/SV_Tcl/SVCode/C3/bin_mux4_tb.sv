timeunit 1ns;
timeprecision 1ps;


class rand_data #(parameter W = 4);
  rand bit [W - 1 : 0] a0, a1, a2, a3;
  rand bit [1 : 0] sel;
  constraint c_a0 { a0 > 0; a0 < 4;}
  constraint c_a1 { a1 > 4; a1 < 8;}
  constraint c_a2 { a1 > 8; a1 < 12;}
  constraint c_a3 { a1 > 12; a1 < 15;}
  constraint c_sel { sel inside {[0 : 3]};}
endclass

module bin_mux4_tb;
 
  parameter NUM = 16;
  parameter W = 4;
  logic [1 : 0] sel;
  logic [W - 1 : 0] a0, a1, a2, a3;
  logic [W - 1 : 0] y;

  rand_data #(.W(W)) i_rand_data;
  bin_mux4_v2 #(.W(W)) i_bin_mux4 (.*);
  int m = $clog2(6);
  initial begin
    a0 <= '0;
    a1 <= '0;
    a2 <= '0;
    a3 <= '0;
    sel  <= '0;
    i_rand_data = new();
    for (int i = 0; i < NUM; i++) begin
      i_rand_data.randomize();
      #5 a0 <= i_rand_data.a0;
         a1 <= i_rand_data.a1;
         a2 <= i_rand_data.a2;
         a3 <= i_rand_data.a3;
         sel  <= i_rand_data.sel;
    end
    $display ("%0d", m);
    $stop;
  end
endmodule  
