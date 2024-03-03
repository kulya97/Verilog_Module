//File: myfdre.sv
module myfdre
(
  input logic clk,
  input logic rst,
  input logic ce,
  input logic d,
  output logic q
);

  always_ff @(posedge clk) begin
    if (rst) begin
      q <= '0;
    end else if (ce) begin
      q <= d;
    end
  end
endmodule
