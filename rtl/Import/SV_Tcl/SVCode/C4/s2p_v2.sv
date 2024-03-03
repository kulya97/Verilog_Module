//File: s2p_v2.sv
module s2p_v2
#(
  parameter W = 4
)
(
  input logic clk,
  input logic start,
  input logic sin,
  output logic [W - 1 : 0] pout,
  output logic done
);

  logic [W - 1 : 0] sreg = '0;
  logic [W - 1 : 0] cnt = '0;

  always_ff @(posedge clk) begin
    sreg <= {sreg[W - 2 : 0], sin};
  end

  always_ff @(posedge clk) begin
    if (start) 
      cnt <= { {(W - 1) {1'b0}}, 1'b1};
    else
      cnt <= cnt << 1;
  end

  always_ff @(posedge clk) begin
    if (cnt[W - 1])
      pout <= sreg;
  end

  assign done = cnt[W - 1];
endmodule

