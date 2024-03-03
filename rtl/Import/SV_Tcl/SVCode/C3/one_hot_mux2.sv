//File: one_hot_mux2.sv
module one_hot_mux2
#(
  parameter W = 4
)
(
  input logic [1 : 0] s,
  input logic [W - 1 : 0] a0, a1,
  output logic [W - 1 : 0] y
);

  always_comb begin
    y = ({W{s[1]}} & a1) | ({W{s[0]}} & a0);
  end
endmodule
