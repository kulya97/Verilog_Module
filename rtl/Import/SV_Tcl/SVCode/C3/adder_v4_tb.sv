timeunit 1ns;
timeprecision 1ps;

module adder_v4_tb;

  parameter NUM = 16;
  parameter W   = 4;
  
  logic [W - 1 : 0] a0, a1;
  logic ci;
  logic [W - 1 : 0] sum;
  logic co;

  adder_v4 #(.W(W)) i_adder_v4 (.*);

  initial begin
    a0 <= 4'b0101;
    a1 <= 4'b1100;
    ci <= '1;
    for (int i = 1; i < NUM; i++) begin
      #5
      a0 <= i;
      a1 <= i;
      ci <= '0;
    end
  end
endmodule
