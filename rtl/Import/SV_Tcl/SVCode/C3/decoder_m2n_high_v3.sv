//File: decoder_m2n_high_v3.sv
module decoder_m2n_high_v3
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
    if (en) begin
      for (int i = 0; i < N; i++) begin
        y[i] = (a == i);
      end
    end
    else begin
        y = '0;
    end
  end
endmodule
