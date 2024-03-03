//File: average_v1.sv
module average_v1
#(
  parameter W = 8
)
(
  input logic signed [W - 1 : 0] a0, a1,
  output logic signed [W - 1 : 0] avg
);
  logic signed [W : 0] sum;
  always_comb begin
    sum = a0 + a1;
    avg = sum >>> 1;
//    avg = (a0 + a1) >>> 1;
  end
endmodule
