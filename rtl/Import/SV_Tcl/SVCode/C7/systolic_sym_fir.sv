//File: systolic_sym_fir.sv
`include "systolic_sym_fir_pkg.sv"
import systolic_sym_fir_pkg::*;

module systolic_sym_fir
(
  input logic clk,
  input logic signed [XIN_W - 1 : 0] xin,
  output logic signed [YOUT_W - 1 : 0] yout
);

  logic [XIN_W - 1 : 0] xin_udx;
  logic signed [XIN_W - 1 : 0] xin_sdx;
  logic signed [XIN_W - 1 : 0] acout [HTAP];
  logic signed [ACC_W - 1 : 0] pout  [HTAP];


  static_multi_bit_sreg_v3
  #(.DEPTH(TAP), .WIDTH(XIN_W), .SRL_STYLE_VAL(SRL_STYLE_VAL))
  i_xin_delay_line
  (.clk (clk), .ce('1), .si(xin), .so(xin_udx));

  always_comb begin
    xin_sdx = signed'(xin_udx);
    yout = pout[HTAP - 1][YOUT_W - 1 : 0];
  end

  preadder_mac
  #(.AW(XIN_W), .BW(COE_W), .PW(ACC_W))
  i0_preadder_mac
  (
    .clk   (clk     ),
    .ain   (xin     ),
    .din   (xin_sdx ),
    .bin   (COE[0]  ),
    .cin   ('0      ),
    .acout (acout[0]),
    .pout  (pout[0] )
  );

  for (genvar i = 1; i < HTAP; i++) begin
    preadder_mac
    #(.AW(XIN_W), .BW(COE_W), .PW(ACC_W))
    i_preadder_mac
    (
      .clk   (clk         ),
      .ain   (acout[i - 1]),
      .din   (xin_sdx     ),
      .bin   (COE[i]      ),
      .cin   (pout[i - 1] ),
      .acout (acout[i]    ),
      .pout  (pout[i]     )
    );
  end
endmodule
      
