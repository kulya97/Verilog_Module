//File: mux_opt_after.sv
module mux_opt_after
(
  input logic clk,
  input logic en,
  input logic [15 : 0] dina, dinb,
  output logic [15 : 0] dout
);

  logic [15 : 0] dina_d1, dinb_d1;
  logic [255 : 0] cnt = {255'b0, 1'b1};

  always_ff @(posedge clk) begin
    if (en) 
      cnt <= {cnt[254 : 0], cnt[255]};
  end

  always_ff @(posedge clk) begin
    dina_d1 <= dina;
    dinb_d1 <= dinb;
    if (cnt[144])
      dout <= dina_d1 + dinb_d1;
    else
      dout <= dina_d1 - dinb_d1;
  end
endmodule
