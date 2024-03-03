timeunit 1ns;
timeprecision 1ps;

module adder_v2_tb;

  parameter IS_SIGNED = 0;
  parameter NUM = 16;
  parameter W   = 4;

  
  logic [W - 1 : 0] a, b;
  logic [W  : 0] sum;

  adder_v2 #(.IS_SIGNED(IS_SIGNED), .W(W)) i_adder_v2 (.*);

  initial begin
    a <= 4'b0101;
    b <= 4'b1100;
    for (int i = 1; i < NUM; i++) begin
      #5
      a <= i;
      b <= i;
    end
  end
endmodule
