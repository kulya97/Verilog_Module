//File: mult_add_v2.sv
module mult_add_v2 
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

  localparam MW = AW + BW;
  logic signed [AW - 1 : 0] ain_d1;
  logic signed [BW - 1 : 0] bin_d1;
  logic signed [CW - 1 : 0] cin_d1, cin_d2;
  logic signed [MW - 1 : 0] mreg; 
  logic signed [PW - 1 : 0] pout_i;

  always_ff @(posedge clk) begin
    if (rst) begin
      ain_d1 <= '0;
      bin_d1 <= '0;
      cin_d1 <= '0;
      cin_d2 <= '0;
      mreg   <= '0;
      pout_i <= '0;
    end
    else if (ce) begin
      ain_d1 <= ain;
      bin_d1 <= bin;
      cin_d1 <= cin;
      cin_d2 <= cin_d1;
      mreg   <= ain_d1 * bin_d1;
      pout_i <= mreg + cin_d2;
    end
  end

  always_comb pout = pout_i;
endmodule
