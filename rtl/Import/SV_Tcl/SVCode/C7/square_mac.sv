//File: square_mac.sv
module square_mac
#(
  parameter W = 17, //input data width
  parameter PW = 48 //accumulator output width
)
(
  input logic clk,
  input logic sload,
  input logic signed [W - 1 : 0] ain,
  input logic signed [W - 1 : 0] bin,
  output logic signed [PW - 1 : 0] pout
);
 
  logic sload_d1;
  logic signed [W - 1     : 0] ain_d1, bin_d1;
  logic signed [W         : 0] diff;
  logic signed [2 * W + 1 : 0] mreg;
  logic signed [PW - 1    : 0] adder_out, old_res;

  always_comb begin
    old_res = sload_d1 ? '0 : adder_out;
    pout    = adder_out;
  end

  always_ff @(posedge clk) begin
    ain_d1    <= ain;
    bin_d1    <= bin;
    diff      <= ain_d1 - bin_d1;
    mreg      <= diff * diff;
    sload_d1  <= sload;
    adder_out <= old_res + mreg; 
  end
endmodule
