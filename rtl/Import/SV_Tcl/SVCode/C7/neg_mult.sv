//File: neg_mult.sv
module neg_mult
#(
  parameter AW = 27,
  parameter BW = 24,
  parameter MW = AW + BW
)
(
  input logic clk,
  input logic signed [AW - 1 : 0] ain,
  input logic signed [BW - 1 : 0] bin,
  output logic signed [MW - 1 : 0] prod
);

  logic signed [AW - 1 : 0] ain_d1;
  logic signed [BW - 1 : 0] bin_d1;
  logic signed [MW - 1 : 0] mreg;

  always_ff @(posedge clk) begin
    ain_d1 <= ain;
    bin_d1 <= bin;
    mreg   <= -(ain_d1 * bin_d1);
    prod   <= mreg;
  end
endmodule

