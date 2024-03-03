//File: array_cmp_v2.sv
module array_cmp_v2
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
  logic c32, c10; //c32 = cnt[3] < cnt[2]
  logic c32_vs_c10;
  logic [W - 1 : 0] cnt32, cnt10;

  always_comb begin
    c32 = cnt[3] < cnt[2];
    c10 = cnt[1] < cnt[0];
    cnt32 = c32 ? cnt[3] : cnt[2];
    cnt10 = c10 ? cnt[1] : cnt[0];
    c32_vs_c10 = cnt32 < cnt10;
  end

  always_ff @(posedge clk) begin
    min_id <= {c32_vs_c10, c32_vs_c10 ? c32 : c10};
  end

  always_ff @(posedge clk) begin
    if (rst) 
      for (int k = 0; k < 4; k++)
        cnt[k] <= '0;
    else if (ce)
      cnt[id] <= cnt[id] + 1'b1;
  end
endmodule

