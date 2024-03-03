//File: array_counter_v1.sv
module array_counter_v1
#(
  parameter W = 6, // counter width
  parameter N = 8, // #N counter
  parameter IDW = $clog2(N) // ID width
)
(
  input logic clk,
  input logic rst, 
  input logic inc, dec,
  input logic [IDW - 1 : 0] inc_id, dec_id,
  output logic [W - 1 : 0] cnt [N]
);

  logic inhibit, inc_int, dec_int;
  always_comb begin
    inhibit = inc & dec & (inc_id == dec_id);
    inc_int = inc & ~inhibit;
    dec_int = dec & ~inhibit;
  end

  always_ff @(posedge clk) begin
    if (rst) begin
      for (int i = 0; i < N; i++) begin
        cnt[i] <= '0;
      end
    end
    else begin
      cnt[inc_id] <= inc_int ? cnt[inc_id] + 1 : cnt[inc_id];
      cnt[dec_id] <= dec_int ? cnt[dec_id] - 1 : cnt[dec_id];
    end
  end
endmodule
