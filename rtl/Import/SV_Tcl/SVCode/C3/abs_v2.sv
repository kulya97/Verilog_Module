//File: abs_v2.sv
module abs_v2
#(
  parameter W = 16
)
(
  input logic signed [W - 1 : 0] a,
  output logic signed [W : 0] y
);

  logic signed [W - 1 : 0] a_sign;
  logic signed [W - 1 : 0] a_not;
  always_comb begin
 //   a_sign = a >>> (W - 1);
    a_sign = {(W){a[W - 1]}};
    a_not  = a ^ a_sign;
    y      = a_not - a_sign;
  end
endmodule

  
