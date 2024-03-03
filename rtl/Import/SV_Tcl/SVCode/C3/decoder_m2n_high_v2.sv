//File: decoder_m2n_high_v2.sv
module decoder_m2n_high_v2
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
    if (!en) begin 
      y = '0;
    end
    else begin
      y = '0;
      y[a] = 1'b1;
    end
  end
endmodule
