//File: mult_add_v1.sv
module mult_add_v1 
#(
  parameter AW = 27,
  parameter BW = 18,
  parameter CW = 48,
  parameter PW = 48
)
(
  input logic clk,
  input logic rst,
  input logic ce,
  input logic signed [AW - 1 : 0] ain,
  input logic signed [BW - 1 : 0] bin,
  input logic signed [CW - 1 : 0] cin,
  output logic signed [PW - 1 : 0] pout
);

  logic signed [AW - 1 : 0] ain_d1;
  logic signed [BW - 1 : 0] bin_d1;
  logic signed [CW - 1 : 0] cin_d1;
  logic signed [PW - 1 : 0] pout_i;


  always_ff @(posedge clk) begin
    if (rst) begin
      ain_d1 <= '0;
      bin_d1 <= '0;
      cin_d1 <= '0;
      pout_i <= '0;
    end
    else if (ce) begin
      ain_d1 <= ain;
      bin_d1 <= bin;
      cin_d1 <= cin;
      pout_i <= ain_d1 * bin_d1 + cin_d1;
    end
  end

  always_comb pout = pout_i;
endmodule
