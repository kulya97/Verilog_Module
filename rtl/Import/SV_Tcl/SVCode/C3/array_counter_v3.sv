//File: array_counter_v3.sv
module array_counter_v3
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

  logic [N - 1 : 0] inc_int, dec_int, inc_dec;
  logic [W - 1 : 0] cnt_plus, cnt_minus;

  always_comb begin
    inc_int = inc << inc_id;
    dec_int = dec << dec_id;
    inc_dec = inc_int ^ dec_int;
  end

  always_comb begin
    cnt_plus  = cnt[inc_id] + 1'b1;
    cnt_minus = cnt[dec_id] - 1'b1;
  end

  always_ff @(posedge clk) begin
    if (rst) begin
      for (int i = 0; i < N; i++) begin
        cnt[i] <= '0;
      end
    end
    else begin 
      for (int i = 0; i < N; i++) begin
        cnt[i] <= inc_dec[i] ? (inc_int[i] ? cnt_plus : cnt_minus) : cnt[i];
      end
    end
  end
endmodule
