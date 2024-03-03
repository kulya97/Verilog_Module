//File: cmp_v2.sv
module cmp_v2
#(
  parameter W = 4
)
(
  input logic [W - 1 : 0] a,
  output logic res
);
  
  localparam logic [W - 1 : 0] PATTERN = 4'b1x01;
  always_comb begin
    res = (a ==? PATTERN);
  end
endmodule

