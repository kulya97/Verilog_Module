#File: gated_clk.sv
module gated_clk
(
  input logic clk,
  input logic din,
  output logic dout
);

  logic clk_div = '0;
  logic din_d1 = '0;
  logic din_d2 = '0;
  logic din_d3 = '0;

  always_ff @(posedge clk) begin
    clk_div <= ~clk_div;
  end

  always_ff @(posedge clk_div) begin
    din_d1 <= din;
    din_d2 <= din_d1;
    din_d3 <= din_d2;
    dout   <= din_d3;
  end

endmodule
