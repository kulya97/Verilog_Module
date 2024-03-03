timeunit 1ns;
timeprecision 1ps;

class rand_data #(parameter W = 4);
  rand bit [W - 1 : 0] a, b;
endclass

module cmp_v1_tb;

  parameter NUM = 16;
  parameter W   = 4;
  logic [W - 1 : 0] a, b;
  logic cgt, clt, ceq;

  rand_data #(.W(W)) i_rand_data;
  cmp_v1 #(.W(W)) i_cmp_v1 (.*);

  initial begin
    i_rand_data = new();
    a <= '0;
    b <= '0;
    repeat (NUM) begin
      i_rand_data.randomize();
      #5 a <= i_rand_data.a;
         b <= i_rand_data.b;
    end
    #5
    $stop;
  end
endmodule

