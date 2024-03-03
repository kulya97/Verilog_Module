timeunit 1ns;
timeprecision 1ps;

module average_v2_tb;

  parameter IS_CEIL = 0;
  parameter NUM = 16;
  parameter W = 4;
  
  logic signed [W - 1 : 0] a0, a1;
  logic signed [W - 1 : 0] avg;

  average_v2 #(.IS_CEIL(IS_CEIL), .W(W)) i_average_v2 (.*);

  initial begin
    for (int i = 0; i < NUM; i++) begin
      a0 <= i;
      a1 <= i + 1;
      #5;
    end
  end
endmodule
