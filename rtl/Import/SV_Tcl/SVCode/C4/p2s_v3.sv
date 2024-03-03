//File: p2s_v3.sv
module p2s_v3
#(
  parameter W = 4
)
(
  input logic clk,
  input logic load,
  input logic [W - 1 : 0] pin,
  output logic sout,
  output logic done,
  output logic rdy,
  output logic busy
);
  logic [W - 1 : 0] cnt = '0;
  logic [W - 1 : 0] pin_shift = '0;

  always_ff @(posedge clk) begin
    if (load) begin
      pin_shift <= { << {pin}};
      cnt <= {{(W - 1) {1'b0}}, 1'b1};
    end
    else begin
      pin_shift <= pin_shift << 1;
      cnt <= cnt << 1;
    end
  end      

  always_comb begin
    sout = pin_shift[W - 1];
    done = cnt[W - 1];
    busy = | cnt;
    rdy  = ~ busy;
  end
endmodule
