//File: cplx_mul_v2.sv
module cplx_mul_v2
#(
  parameter AW = 18,
  parameter BW = 18,
  parameter MW = AW + 1 + BW
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
  logic signed [MW - 1 : 0] multcommon;
  cpreadder_mac_unit #(.AW(AW), .BW(BW), .AREG(1), .BREG(2), .ADDSUB(1))
  middle_cpreadder_mac_unit 
  (
   .clk(clk), .ain(ar), .din(ai), .bin(bi), .cin(0), .pout(multcommon)
  );

  cpreadder_mac_unit #(.AW(AW), .BW(BW), .AREG(2), .BREG(3), .ADDSUB(1))
  top_cpreadder_mac_unit 
  (
   .clk(clk), .ain(br), .din(bi), .bin(ar), .cin(multcommon), .pout(pr) 
  );

  cpreadder_mac_unit #(.AW(AW), .BW(BW), .AREG(2), .BREG(3), .ADDSUB(0))
  bottom_cpreadder_mac_unit 
  (
   .clk(clk), .ain(br), .din(bi), .bin(ai), .cin(multcommon), .pout(pi)
  );
endmodule
