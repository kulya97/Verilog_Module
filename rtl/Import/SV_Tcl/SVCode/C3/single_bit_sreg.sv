//File: single_bit_sreg.sv
module single_bit_sreg
#(
  parameter DEPTH = 4
)
(
  input logic clk,
  input logic ce,
  input logic sin,
  output logic sout
);

  logic [DEPTH - 1 : 0] sin_dly;

  always_ff @(posedge clk) begin
    if (ce) begin
      sin_dly <= (sin_dly << 1);
      sin_dly[0] <= sin;
    end
  end
  always_comb begin
    sout = sin_dly[DEPTH - 1];
  end
endmodule
