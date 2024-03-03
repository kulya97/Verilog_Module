//File: incomplete_if1_opt.sv
module incomplete_if1_opt
(
  input logic clk,
  input logic s0,
  input logic s1,
  input logic a,
  output logic q
);
  always_ff @(posedge clk) begin
    if (s0 == 1'b1)
      q <= '1;
    else if (s1 == 1'b1)
      q <= a;
  end
endmodule
