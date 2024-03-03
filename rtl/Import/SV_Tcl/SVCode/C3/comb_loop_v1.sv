//File: comb_loop_v1.sv
module comb_loop_v1
(
  input logic b,
  output logic a, q
);

  always_comb begin
    q = a & b;
    a = ~q;
  end
endmodule
