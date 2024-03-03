//File: latch_v2.sv
module latch_v2
(
  input logic a,
  input logic sel,
  output logic y
);

  always_comb begin
    if (sel)
      y = a;
    else
      y = y;
  end
endmodule
