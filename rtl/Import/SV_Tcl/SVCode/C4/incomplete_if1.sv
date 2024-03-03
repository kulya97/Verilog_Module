//File: incomplete_if1.sv
module incomplete_if1
(
  input logic s0,
  input logic s1,
  input logic a,
  output logic q
);
  always_latch begin
    if (s0 == 1'b1)
      q = '1;
    else if (s1 == 1'b1)
      q = a;
  end
endmodule
