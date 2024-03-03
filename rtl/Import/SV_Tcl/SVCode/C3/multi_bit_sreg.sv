//File: multi_bit_sreg.sv
module multi_bit_sreg
#(
  parameter DEPTH = 32,
  parameter DW    = 8
)
(
  input logic clk,
  input logic ce,
  input logic [DW - 1 : 0] din,
  output logic [DW - 1 : 0] dout
);

  for (genvar i = 0; i < DW; i++) begin
    single_bit_sreg #(.DEPTH(DEPTH))
    i_single_bit_sreg
    (.clk(clk), .ce(ce), .sin(din[i]), .sout(dout[i]));
  end
endmodule
