timeunit 1ns;
timeprecision 1ps;

module late_signal_v1_tb;

  logic a, b, c, d;
  logic [3 : 0] sel;
  logic q;

  priority_mux_v2 i_late_signal_v1 (.*);

  initial begin
    a <= '0;
    b <= '0;
    c <= '0;
    d <= '0;
    #5 sel <= 4'b1111;
          d <= '1;
    #5 sel <= 4'b0111;
          c <= '0;
          a <= '1;
          b <= '1;
    #5 sel <= 4'b0011;
          d <= '0;
          a <= '0;
    #5 sel <= 4'b0001;
          a <= '1;
          b <= '0;
    $stop;
  end
endmodule
