timeunit 1ns;
timeprecision 1ps;

class rand_array #(parameter W = 4, 
                   parameter N = 6
                  );
  rand bit [W - 1 : 0] a [N];
  randc bit [N - 1 : 0] s;
  constraint c_s { s inside {1, 2, 4, 8}; }
endclass

module one_hot_mux_tb;
  
  parameter W = 4;
  parameter N = 4;
  parameter NUM = 16;

  logic [N - 1 : 0] s;
  logic [W - 1 : 0] a [N];
  logic [W - 1 : 0] y;

  rand_array #(.W(W), .N(N)) i_rand_array;   
  one_hot_mux #(.W(W), .N(N)) i_one_hot_mux (.*);

  initial begin
    s <= '0;
    a <= '{default : '0};
    i_rand_array = new();
    for (int i = 0; i < NUM; i++) begin
      i_rand_array.randomize();
      #5 s <= i_rand_array.s; 
         a <= i_rand_array.a;
    end
    $stop;
  end
endmodule
  

