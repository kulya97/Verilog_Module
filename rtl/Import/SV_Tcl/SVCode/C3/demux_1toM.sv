//File: demux_1toM.sv
module demux_1toM
#(
  parameter W = 8, // data width
  parameter M = 4, // #N of output
  parameter K = $clog2(M) // select width
)
(
  input logic [K - 1 : 0] sel,
  input logic [W - 1 : 0] din,
  output logic [M - 1 : 0] [W - 1 : 0] y
);

  always_comb begin
    for (int i = 0; i < M; i++) begin
      if (sel == i) y[i] = din; else y[i] = '0;
    end
  end
endmodule
  
