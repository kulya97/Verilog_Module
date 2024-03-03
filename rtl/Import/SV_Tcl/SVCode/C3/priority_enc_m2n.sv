//File: priority_enc_m2n.sv
module priority_enc_m2n
#(
  parameter M = 16,
  parameter N = $clog2(M)
)
(
  input logic [M - 1 : 0] a,
  output logic valid_in,
  output logic [N - 1 : 0] y
);
  always_comb begin
    valid_in = |a;
    y = 0;
    for (int i = 0; i < M; i++) begin
      if (a[i])  y = i;
    end
  end
endmodule

