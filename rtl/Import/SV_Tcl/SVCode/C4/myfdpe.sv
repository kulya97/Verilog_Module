//File: myfdpe.sv
module myfdpe
(
  input logic clk,
  input logic pre,
  input logic ce,
  input logic d,
  output logic q
);

  always_ff @(posedge clk, posedge pre) begin
    if (pre) begin
      q <= '1;
    end else if (ce) begin
      q <= d;
    end
  end
endmodule
