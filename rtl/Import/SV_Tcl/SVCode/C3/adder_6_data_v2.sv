//File: adder_6_data_v2.sv
module adder_6_data_v2
#(
  parameter DIW = 8,
  parameter DOW = DIW + 3
)
(
  input logic signed [DIW - 1 : 0] a0, a1, a2,
  input logic signed [DIW - 1 : 0] a3, a4, a5,
  output logic signed [DOW - 1 : 0] sum
);

  logic signed [DIW + 1 : 0] s0, s1;

  always_comb begin
    s0 = a0 + a1 + a2;
    s1 = a3 + a4 + a5;
    sum = s0 + s1;
  end
endmodule
