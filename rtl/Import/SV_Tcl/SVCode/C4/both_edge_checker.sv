//File: both_edge_checker.sv
module both_edge_checker
(
  input logic clk,
  input logic rst,
  input logic siga,
  output logic siga_both_edge
);
  logic siga_d1;
  always_ff @(posedge clk) begin
    if (rst) begin
      siga_d1 <= '0;
    end
    else begin
      siga_d1 <= siga;
    end
  end

  always_comb begin
    siga_both_edge = siga ^ siga_d1;
  end
endmodule
