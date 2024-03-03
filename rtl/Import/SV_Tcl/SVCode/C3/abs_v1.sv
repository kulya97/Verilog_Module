//File: abs_v1.sv
module abs_v1
#(
  parameter W = 16
)
(
  input logic signed [W - 1 : 0] a,
  output logic signed [W : 0] y
);

  always_comb begin
    y = a[W - 1] ? (-a) : a;
  end
endmodule
