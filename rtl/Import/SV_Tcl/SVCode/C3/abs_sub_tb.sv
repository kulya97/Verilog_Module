timeunit 1ns;
timeprecision 1ps;

module abs_sub_tb;

  parameter NUM = 16;
  parameter W   = 4;
  
  logic signed [W - 1 : 0] a, b;
  logic signed [W : 0] y; 

  abs_sub_v2 #(.W(W)) i_abs_sub_v2(.*);

  initial begin
    for (int i = 0; i < NUM; i++) begin
      a <= 0;
      b <= i;
      #5;
    end
    $stop;
  end
endmodule

