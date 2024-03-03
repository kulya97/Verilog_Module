timeunit 1ns;
timeprecision 1ps;

module adder_v3_tb;

  parameter NUM = 16;
  parameter W = 4;
  
  logic signed [W - 1 : 0] a0, a1, a2;
  logic signed [W + 1 : 0] sum;

  adder_v3 #(.W(W)) i_adder_v3 (.*);

  initial begin
    for (int i = 0; i < NUM; i++) begin
      a0 <= i;
      a1 <= i + 1;
      a2 <= i + 2;
      #5;
    end
  end
endmodule
  

