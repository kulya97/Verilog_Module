//File: myfdse.sv
module myfdse
(
  input logic clk,
  input logic set,
  input logic ce,
  input logic d,
  output logic q
);

  always_ff @(posedge clk) begin
    if (set) begin
      q <= '1;
    end else if (ce) begin
      q <= d;
    end
  end
endmodule
