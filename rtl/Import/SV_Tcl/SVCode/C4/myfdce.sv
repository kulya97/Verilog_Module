//File: myfdce.sv
module myfdce
(
  input logic clk,
  input logic clr,
  input logic ce,
  input logic d,
  output logic q
);

  always_ff @(posedge clk, posedge clr) begin
    if (clr) begin
      q <= '0;
    end else if (ce) begin
      q <= d;
    end
  end
endmodule
