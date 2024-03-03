//File: neg_edge_rst.sv
module neg_edge_rst
(
  input logic clk,
  input logic d,
  input logic rst,
  output logic q
);

  always_ff @(negedge clk) begin
    if (!rst)
      q <= '0;
    else
      q <= d;
  end
endmodule
