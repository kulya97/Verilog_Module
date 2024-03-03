//File: comb_loop_v2.sv
module comb_loop_v2
(
  input logic clk,
  input logic a,
  output logic q
);

  logic rst;

  always_comb begin
    rst = q;
  end

  always_ff @(posedge clk, posedge rst) begin
    if (rst) 
      q <= '0;
    else 
      q <= a;
  end

endmodule
