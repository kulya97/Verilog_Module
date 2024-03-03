//File: comb_loop_v3.sv
module comb_loop_v3
(
  input logic clk,
  input logic a, b,
  output logic q
);

  logic rst;

  always_comb begin
    rst = b & q;
  end

  always_ff @(posedge clk, negedge rst) begin
    if (!rst) 
      q <= '0;
    else 
      q <= a;
  end

endmodule
