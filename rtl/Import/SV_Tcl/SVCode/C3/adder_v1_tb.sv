timeunit 1ns;
timeprecision 1ps;

module adder_v1_tb;

  parameter NUM = 16;
  parameter W   = 4;
  
  logic [W - 1 : 0] a, b;
  logic cin;
  logic [W - 1 : 0] sum;
  logic cout;

  adder_v1 #(.W(W)) i_adder_v1 (.*);

  initial begin
    a <= 4'b0101;
    b <= 4'b1100;
    cin <= '0;
    for (int i = 1; i < NUM; i++) begin
      #5
      a <= i;
      b <= i;
    end
  end
endmodule

