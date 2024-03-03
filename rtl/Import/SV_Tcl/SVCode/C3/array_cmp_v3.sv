//File: array_cmp_v3.sv
module array_cmp_v3
#(
  parameter W = 12
)
(
  input logic clk,
  input logic rst, ce,
  input logic [1 : 0] id,
  output logic [1 : 0] min_id
);

  logic [W - 1 : 0] cnt [4] = '{default : '0};
  logic c32, c31, c30; //c32 = cnt[3] < cnt[2]
  logic c21, c20, c10;

  always_comb begin
    c32 = cnt[3] < cnt[2];
    c31 = cnt[3] < cnt[1];
    c30 = cnt[3] < cnt[0];
    c21 = cnt[2] < cnt[1];
    c20 = cnt[2] < cnt[0];
    c10 = cnt[1] < cnt[0];
  end

  always_ff @(posedge clk) begin
    min_id <= {(c31 & c30) | (c21 & c20), (c32 & c30) | (c10 & ~c21)};
  end

  always_ff @(posedge clk) begin
    if (rst) 
      for (int k = 0; k < 4; k++)
        cnt[k] <= '0;
    else if (ce)
      cnt[id] <= cnt[id] + 1'b1;
  end
endmodule

