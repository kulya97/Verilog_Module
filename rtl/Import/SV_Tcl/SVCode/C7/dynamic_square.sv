//File: dynamic_square.sv
//input data width: W
//pre-adder output width: W+1
//Mult output width: 2(W+1)
//For DSP48E2: W+1 ≤ 18 => W < 17
//For DSP58: W+1 ≤ 24 => W < 23
module dynamic_square
#(
  parameter W = 17
)
(
  input logic clk,
  input logic subadd,
  input logic signed [W - 1 : 0] ain,
  input logic signed [W - 1 : 0] bin,
  output logic signed [2 * W + 1 : 0] pout
);
  
  logic subadd_d1;
  logic signed [W - 1 : 0] ain_d1, bin_d1;
  logic signed [W : 0] diff;
  logic signed [2 * W + 1 : 0] mreg;

  always_ff @(posedge clk) begin
    subadd_d1 <= subadd;
    ain_d1    <= ain;
    bin_d1    <= bin;
    diff      <= subadd_d1 ? (ain_d1 - bin_d1) : (ain_d1 + bin_d1);
    mreg      <= diff * diff;
    pout      <= mreg;
  end
endmodule
