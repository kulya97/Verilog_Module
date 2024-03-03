timeunit 1ns;
timeprecision 1ps;

module abs_tb;

  parameter NUM = 16;
  parameter W   = 4;
  
  logic signed [W - 1 : 0] a;
  logic signed [W : 0] y; 

  abs_v2 #(.W(W)) i_abs_v2(.*);

  initial begin
    for (int i = 0; i < NUM; i++) begin
      a <= i;
      #5;
    end
    $stop;
  end
endmodule

