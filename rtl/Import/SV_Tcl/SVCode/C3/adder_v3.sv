//File: adder_v3.sv
module adder_v3
#(
  parameter W = 8
)
(
  input logic signed [W - 1 : 0] a0, a1, a2,
  output logic signed [W + 1 : 0] sum
);

  always_comb sum = a0 + a1 + a2;
endmodule

