//File: acc_v2.sv
(* use_dsp = "yes" *)
module acc_v2
#(
  parameter DW   = 4, // input data width
  parameter ACCW = 10 // accumulator width 
)
(
  input logic clk,
  input logic ce,
  input logic bypass,
  input logic signed [DW - 1 : 0] acc_in,
  output logic signed [ACCW - 1 : 0] acc_out
);

  always_ff @(posedge clk) begin
    if (ce)
      if (bypass)
        acc_out <= acc_in;
      else
        acc_out <= acc_out + acc_in;
  end
endmodule


