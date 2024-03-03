//File: one_hot_mux.sv
module one_hot_mux
#(
  parameter W = 1,
  parameter N = 64
)
(
  input logic [N - 1 : 0] s,
  input logic [W - 1 : 0] a [N],
  output logic [W - 1 : 0] y
);

  always_comb begin
    y = 0;
    for (int i = 0; i < N; i++) begin
      if (s[i]) y = a[i];
    end
  end
endmodule
