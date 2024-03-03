//File: systolic_fir.sv
`include "systolic_fir_pkg.sv"
import systolic_fir_pkg::*;

module systolic_fir
(
  input logic clk,
  input logic signed [XIN_W - 1 : 0] xin,
  output logic signed [YOUT_W - 1 : 0] yout
);

  logic signed [XIN_W - 1 : 0] acout [TAP];
  logic signed [ACC_W - 1 : 0] pout  [TAP];

  mac #(.AW(XIN_W), .BW(COE_W), .PW(ACC_W))
  i0_mac (
          .clk   (clk     ),
          .ain   (xin     ),
          .bin   (COE[0]  ),
          .cin   ('0      ),
          .acout (acout[0]),
          .pout  (pout[0] )
         );
  for (genvar i = 1; i < TAP; i++) begin
    mac #(.AW(XIN_W), .BW(COE_W), .PW(ACC_W))
    i_mac (
            .clk   (clk         ),
            .ain   (acout[i - 1]),
            .bin   (COE[i]      ),
            .cin   (pout[i - 1] ),
            .acout (acout[i]    ),
            .pout  (pout[i]     )
          );
  end

  always_comb yout = pout[TAP - 1][YOUT_W - 1 : 0];

endmodule
      

