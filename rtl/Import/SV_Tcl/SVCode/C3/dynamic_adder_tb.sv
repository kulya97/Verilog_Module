timeunit 1ns;
timeprecision 1ps;

module dynamic_adder_tb;

  parameter NUM = 16;
  parameter W   = 4;
  
  logic add_sub;
  logic signed [W - 1 : 0] a, b;
  logic signed [W : 0] res;

  dynamic_adder #(.W(W)) dynamic_adder (.*);

  initial begin
    add_sub <= '1;
    a <= 4'b0101;
    b <= 4'b1100;
    for (int i = 1; i < NUM; i++) begin
      #5
      add_sub = i[0];
      a <= i;
      b <= i + $urandom_range(0, 15);
    end
    $stop;
  end
endmodule

