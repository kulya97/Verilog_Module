//File: latch_v1.sv
module latch_v1
(
  input logic a,
  input logic sel,
  output logic y
);

  always_comb begin
    y = sel ? a : y;
  end
endmodule
