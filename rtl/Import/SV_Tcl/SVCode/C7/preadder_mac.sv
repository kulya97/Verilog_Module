//File: preadder_mac.sv
module preadder_mac
#(
  parameter AW = 26,
  parameter BW = 18,
  parameter PW = 48
)
(
  input logic clk,
  input logic signed [AW - 1 : 0] ain,
  input logic signed [AW - 1 : 0] din,
  input logic signed [BW - 1 : 0] bin,
  input logic signed [PW - 1 : 0] cin,
  output logic signed [AW - 1 : 0] acout,
  output logic signed [PW - 1 : 0] pout
);

  localparam MW = AW + 1 + BW;
  logic signed [AW - 1 : 0] ain_d1 = '0;
  logic signed [AW - 1 : 0] ain_d2 = '0;
  logic signed [AW - 1 : 0] din_d1 = '0;
  logic signed [AW     : 0] addreg = '0;
  logic signed [BW - 1 : 0] bin_d1 = '0;
  logic signed [MW - 1 : 0] mreg   = '0;
  logic signed [PW - 1 : 0] preg   = '0;

  always_comb begin
    acout = ain_d2;
    pout  = preg;
  end

  always_ff @(posedge clk) begin
    ain_d1 <= ain;
    ain_d2 <= ain_d1;
    din_d1 <= din;
    bin_d1 <= bin;
    addreg <= ain_d2 + din_d1;
    mreg   <= addreg * bin_d1;
    preg   <= mreg + cin;
  end
endmodule



