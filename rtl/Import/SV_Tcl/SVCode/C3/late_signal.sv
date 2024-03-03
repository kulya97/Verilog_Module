//File: late_signal_v1.sv
module late_signal_v1
(
  input logic a, b, c, d,
  input logic [3 : 0] sel,
  output logic q
);
  always_comb begin
    q = '0;
    if (sel[3]) q = d;
    if (sel[0]) q = a;
    if (sel[1]) q = b;
    if (sel[2]) q = c;
   
  end
endmodule
