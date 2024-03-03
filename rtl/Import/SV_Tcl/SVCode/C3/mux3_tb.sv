timeunit 1ns;
timeprecision 1ps;

module mux3_tb;
 
  parameter NUM = 8;

  logic [1 : 0] a, b, c;
  logic [1 : 0] sel;
  logic [1 : 0] y;

  mux3b i_mux3b (.*);

  initial begin
    for (int i = 0; i < NUM; i++) begin
      sel <= i;
      a   <= i;
      b   <= i + 1;
      c   <= i - 1;
      #5;
    end
    $stop;
  end
endmodule
