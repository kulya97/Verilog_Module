timeunit 1ns;
timeprecision 1ps;
module addition_length_tb;

  logic [3 : 0] a;
  logic [3 : 0] b;
  logic [2 : 0] c;
  logic [4 : 0] sum0;
  logic [5 : 0] sum1;
  logic [5 : 0] sum2;
  logic signed [3 : 0] s0;
  logic signed [3 : 0] s1;
  logic signed [5 : 0] sum3;

  initial begin
    a = 4'b1001; //9
    b = 4'b1100; //12
    c = 3'b111;
    s0 = 4'b1001; //-7
    s1 = 4'b1100; //-4
    $display("#1: a + b = %b", a+b);
    sum0 = {a+b};
    $display("#2: a + b = %b", sum0);
    sum0 = a + b;
    $display("#3: a + b = %b", sum0);
    sum1 = a + b;
    $display("#4: a + b = %b", sum1);
    $display("#5: a + c = %b", a+c);
    sum2 = a + c;
    $display("#6: a + c = %b", sum2);
    sum3 = s0 + s1;
    $display("#7: s0 + s1 = %b", sum3);
  end
endmodule
