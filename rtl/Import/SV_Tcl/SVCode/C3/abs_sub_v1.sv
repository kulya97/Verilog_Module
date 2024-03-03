//File: abs_sub_v1.sv
module abs_sub_v1
#(
  parameter W = 16
)
(
  input logic signed [W - 1 : 0] a, b,
  output logic signed [W : 0] y
);

  always_comb begin
    y = (a > b) ? (a - b) : (b - a);
  end
endmodule
