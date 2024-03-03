//File: cmp_v1.sv
module cmp_v1
#(
  parameter W = 18
)
( 
  input logic [W - 1 : 0] a, b,
  output logic cgt // clt, ceq
);

  always_comb begin
    cgt = (a > b);
    //clt = (a < b);
    //ceq = (a == b);
  end
endmodule
