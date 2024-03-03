//File: decoder_m2n_high_v1.sv
module decoder_m2n_high_v1
#(
  parameter M = 3,
  parameter N = 2 ** M
)
(
  input logic [M - 1 : 0] a,
  input logic en,
  output logic [N - 1 : 0] y
);

  always_comb begin
    if (!en) 
      y = '0;
    else 
      y = {{N-1{1'b0}}, 1'b1} << a;
  end
endmodule
