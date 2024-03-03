//File: adder_v4.sv
module adder_v4
#(
  parameter W = 4
)
(
  input logic [W - 1 : 0] a0, a1,
  input logic ci,
  output logic [W - 1 : 0] sum,
  output logic co
);

  logic [W : 0] temp;
  always_comb begin
    temp = a0 + a1 + ci;
    sum  = temp[W - 1 : 0];
    co   = temp[W];
  end
endmodule
