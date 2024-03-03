//File: cmp_opt_before.sv
module cmp_opt_before
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

  always_comb begin
    case (sel_d1)
      2'b10: cnt_nxt = cnt + 1;
      2'b01: cnt_nxt = cnt - 1;
      default: cnt_nxt = cnt;
    endcase
  end

  always_ff @(posedge clk) begin
    sel_d1 <= sel;
    din_d1 <= din;
    cnt    <= cnt_nxt;
    dout   <= (cnt_nxt >= din_d1);
  end
endmodule
