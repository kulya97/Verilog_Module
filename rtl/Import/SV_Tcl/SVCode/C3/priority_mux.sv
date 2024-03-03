//File: priority_mux.sv
module priority_mux
#(
  parameter W = 8
)
(
  input logic [W - 1 : 0] din,
  input logic [W - 1 : 0] sel,
  output logic q
);

  always_comb begin
    q = '0;
    for (int i = 0; i < W; i++) begin
      if (sel[i]) q = din[i];
    end
  end
endmodule
