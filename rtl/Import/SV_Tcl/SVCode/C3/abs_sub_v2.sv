//File: abs_sub_v2.sv
module abs_sub_v2
#(
  parameter W = 16
)
(
  input logic signed [W - 1 : 0] a, b,
  output logic signed [W : 0] y
);

  logic signed [W : 0] sub, sub_sign, sub_not;
  always_comb begin
    sub = a - b;
    sub_sign = {(W + 1) {sub[W]}};
    sub_not  = sub ^ sub_sign;
    y = sub_not - sub_sign;
  end
endmodule

