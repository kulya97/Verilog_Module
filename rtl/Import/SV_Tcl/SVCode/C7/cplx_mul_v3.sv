//File: cplx_mul_v3.sv
module cplx_mul_v3
#(
  parameter AW = 27,
  parameter BW = 18,
  parameter MW = AW + BW
)
(
  input logic clk,
  input logic signed [AW - 1 : 0] ar,
  input logic signed [AW - 1 : 0] ai,
  input logic signed [BW - 1 : 0] br,
  input logic signed [BW - 1 : 0] bi,
  output logic signed [MW  : 0] pr,
  output logic signed [MW  : 0] pi
);
  logic signed [AW - 1 : 0] ar_d1, ai_d1, ai_d2;
  logic signed [BW - 1 : 0] br_d1, br_d2, bi_d1, bi_d2;
  logic signed [MW - 1 : 0] ar_br, ai_bi, ar_bi, ai_br;
  logic signed [MW - 1 : 0] ar_br_d1, ar_bi_d1;

  always_ff @(posedge clk) begin
    ar_d1 <= ar;
    br_d1 <= br;
    ar_br <= ar_d1 * br_d1;
    ar_br_d1 <= ar_br;
  end

  always_ff @(posedge clk) begin
    ai_d1 <= ai;
    ai_d2 <= ai_d1;
    bi_d1 <= bi;
    bi_d2 <= bi_d1;
    ai_bi <= ai_d2 * bi_d2;
    pr    <= ar_br_d1 - ai_bi;
  end

  always_ff @(posedge clk) begin
    ar_bi <= ar_d1 * bi_d1;
    ar_bi_d1 <= ar_bi;
  end

  always_ff @(posedge clk) begin
    br_d2 <= br_d1;
    ai_br <= ai_d2 * br_d2;
    pi    <= ar_bi_d1 + ai_br;
  end

endmodule
