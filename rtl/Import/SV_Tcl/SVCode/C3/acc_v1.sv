//File: acc_v1.sv
(* use_dsp = "yes" *)
module acc_v1
#(
  parameter DW   = 16, // input data width
  parameter ACCW = 10 // accumulator width 
)
(
  input logic clk,
  input logic rst,
  input logic ce,
  input logic signed [DW - 1 : 0] acc_in,
  output logic signed [ACCW - 1 : 0] acc_out
);

  always_ff @(posedge clk) begin
    if (rst)
      acc_out <= '0;
    else if (ce)
      acc_out <= acc_out + acc_in;
  end
endmodule

