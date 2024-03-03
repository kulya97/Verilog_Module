//File: array_counter_v1_opt.sv
module array_counter_v1_opt
#(
  parameter W = 12, // counter width
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
      if (inc_int)
        cnt[inc_id] <= cnt[inc_id] + 1'b1;
      if (dec_int)
        cnt[dec_id] <= cnt[dec_id] - 1'b1;
    end
  end
endmodule
