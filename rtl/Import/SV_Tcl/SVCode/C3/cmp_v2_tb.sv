timeunit 1ns;
timeprecision 1ps;

class rand_data #(parameter W = 4);
  rand bit [W - 1 : 0] a, b;
endclass

module cmp_v2_tb;

  parameter NUM = 16;
  parameter W   = 4;
  logic [W - 1 : 0] a;
  logic res;

  rand_data #(.W(W)) i_rand_data;
  cmp_v2 #(.W(W)) i_cmp_v2 (.*);
  int i = 0;
  initial begin
    i_rand_data = new();
    a <= '0;
    repeat (NUM) begin
      //i_rand_data.randomize();
      //#5 a <= i_rand_data.a;
      #5 a <= i;
         i++;
    end
    #5
    $stop;
  end
endmodule
