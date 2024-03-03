//File: cplx_mul_v1.sv
module cplx_mul_v1
#(
  parameter AW = 27,
  parameter BW = 18,
  parameter MW = AW + BW
)
(
  input logic clk,
  input logic signed [AW - 1 : 0] ar,
  input logic signed [AW - 1 : 0] ai,
  input logic signed [BW - 1 : 0] br,
  input logic signed [BW - 1 : 0] bi,
  output logic signed [MW  : 0] pr,
  output logic signed [MW  : 0] pi
);
  logic signed [MW : 0] ar_br;
  logic signed [MW : 0] ar_bi;

  cmac_unit #(.AW(AW), .BW(BW), .AREG(1), .ADDSUB(0))
  i_ar_br_cmac_unit (.clk(clk), .ain(ar), .bin(br), .cin('0), .pout(ar_br));

  cmac_unit #(.AW(AW), .BW(BW), .AREG(2), .ADDSUB(1))
  i_ai_bi_cmac_unit (.clk(clk), .ain(ai), .bin(bi), .cin(ar_br[MW - 1 : 0]), .pout(pr));

  cmac_unit #(.AW(AW), .BW(BW), .AREG(1), .ADDSUB(0))
  i_ar_bi_cmac_unit (.clk(clk), .ain(ar), .bin(bi), .cin('0), .pout(ar_bi));

  cmac_unit #(.AW(AW), .BW(BW), .AREG(2), .ADDSUB(0))
  i_ai_br_cmac_unit (.clk(clk), .ain(ai), .bin(br), .cin(ar_bi[MW - 1 : 0]), .pout(pi));

endmodule
