//File: incomplete_if0.sv
module incomplete_if0
(
  input logic s,
  input logic a,
  output logic q
);

  always_latch begin
    if (s == 1'b1)
      q = a;
  end
endmodule
