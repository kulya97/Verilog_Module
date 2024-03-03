//File: cmp_opt_after.sv
module cmp_opt_after
#(
  parameter W = 10
)
(
  input logic clk,
  input logic [1 : 0] sel,
  input logic [W - 1 : 0] din,
  output logic dout
);

  logic [1 : 0] sel_d1 = '0;
  logic [W - 1 : 0] din_d1 = '0;
  logic [W - 1 : 0] cnt = '0;
  logic [W - 1 : 0] cnt_nxt;
  logic [W - 1 : 0] sum, sub;
  logic [W     : 0] dout_nxt;

  always_comb begin
    case (sel_d1)
      2'b10: cnt_nxt = cnt + 1;
      2'b01: cnt_nxt = cnt - 1;
      default: cnt_nxt = cnt;
    endcase
  end

  always_comb begin
    sum = cnt + 1;
    sub = cnt - 1;
  end

  always_comb begin
    case (sel_d1)
      2'b10: dout_nxt = {1'b1, sum} - {1'b0, din_d1};
      2'b01: dout_nxt = {1'b1, sub} - {1'b0, din_d1};
      default: dout_nxt = {1'b1, cnt} - {1'b0, din_d1};
    endcase
  end

  always_ff @(posedge clk) begin
    sel_d1 <= sel;
    din_d1 <= din;
    cnt    <= cnt_nxt;
    dout   <= dout_nxt[W];
  end
endmodule
