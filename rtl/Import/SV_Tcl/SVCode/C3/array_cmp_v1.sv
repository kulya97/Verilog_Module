//File: array_cmp_v1.sv
module array_cmp_v1
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

  function automatic logic [1 : 0] get_min (input logic [W - 1 : 0] cnt [4]);
    logic [1 : 0] sel;
    logic [W - 1 : 0] min_cnt;
    min_cnt = cnt[0];
    sel = 2'd0;
    for (int i = 1; i <= 3; i++) begin
      if (cnt[i] < min_cnt) begin
        min_cnt = cnt[i];
        sel = i;
      end
    end
    return sel;
  endfunction

  always_ff @(posedge clk) begin
    min_id <= get_min(cnt);
  end

  always_ff @(posedge clk) begin
    if (rst) 
      for (int k = 0; k < 4; k++)
        cnt[k] <= '0;
    else if (ce)
      cnt[id] <= cnt[id] + 1'b1;
  end
endmodule
