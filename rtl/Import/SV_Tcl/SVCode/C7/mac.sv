//File: mac.sv
module mac
#(
  parameter AW = 27,
  parameter BW = 18,
  parameter PW = 48
)
(
  input logic clk,
  input logic signed [AW - 1 : 0] ain,
  input logic signed [BW - 1 : 0] bin,
  input logic signed [PW - 1 : 0] cin,
  output logic signed [AW - 1 : 0] acout,
  output logic signed [PW - 1 : 0] pout
);

  localparam MW = AW + BW;
  logic signed [AW - 1 : 0] ain_d1 = '0;
  logic signed [AW - 1 : 0] ain_d2 = '0;
  logic signed [BW - 1 : 0] bin_d1 = '0;
  logic signed [MW - 1 : 0] mreg   = '0;

  always_comb acout = ain_d2;

  always_ff @(posedge clk) begin
    ain_d1 <= ain;
    ain_d2 <= ain_d1;
    bin_d1 <= bin;
    mreg   <= ain_d2 * bin_d1;
    pout   <= mreg + cin;
  end
endmodule



