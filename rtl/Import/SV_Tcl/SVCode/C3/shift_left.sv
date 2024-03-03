//File: shift_left.sv
module shift_left
#(
  parameter DIW = 8,  // input data width
  parameter SW  = $clog2(DIW),  // shift width
  parameter DOW = 2 * DIW - 1 // output data width
)
(
  input logic [DIW - 1 : 0] a,
  input logic [SW  - 1 : 0] n,
  output logic [DOW - 1 : 0] y
);

 logic [DOW - 1 : 0] a_ex;

 always_comb begin
   a_ex[DOW - 1 : DIW] = '0;
   a_ex[DIW - 1 :   0] = a;
   y = a_ex << n;
 end
endmodule
