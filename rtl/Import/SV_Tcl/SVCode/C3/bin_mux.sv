//File: bin_mux.sv
module bin_mux
#(
  parameter W = 1, // data width
  parameter N = 64, // data depth
  parameter SW = $clog2(N) // sel width
)
(
  input logic [SW - 1 : 0] sel,
  //input logic [W - 1 : 0] a [N],
  input logic [N - 1 : 0][W - 1 : 0] a,
  output logic [W - 1 : 0] y
);

  always_comb begin
    y = a[sel];
  end
endmodule
