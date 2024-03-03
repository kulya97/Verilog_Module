//File: priority_mux_v1.sv
module priority_mux_v1 
(
  input logic a, b, c, d,
  input logic [3 : 0] sel,
  output logic q
);
  always_comb begin
    q = '0;
    if (sel[0]) q = a;
    if (sel[1]) q = b;
    if (sel[2]) q = c;
    if (sel[3]) q = d;
  end
endmodule
