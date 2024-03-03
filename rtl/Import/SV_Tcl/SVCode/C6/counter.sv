//File: counter.sv
module counter
#(
  parameter WIDTH  = 8,
  parameter CMAX   = 2
)
(
  input logic clk,
  input logic rst,
  input logic ce,
  output logic [WIDTH - 1 : 0] cnt
);

  always_ff @(posedge clk) begin
    if (rst) begin
      cnt <= '0;
    end
    else if (ce) begin
      if (cnt == CMAX) begin
        cnt <= '0;
      end
      else begin
        cnt <= cnt + 1;
      end
    end
  end
endmodule
