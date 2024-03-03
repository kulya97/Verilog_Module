//File: dynamic_adder.sv
module dynamic_adder
#(
  parameter W = 8
)
(
  input logic add_sub, // 0: + ; 1: -
  input logic signed [W - 1 : 0] a, b,
  output logic signed [W : 0] res
);

  always_comb begin
    res = add_sub ? (a - b) : (a + b);
  end
endmodule
