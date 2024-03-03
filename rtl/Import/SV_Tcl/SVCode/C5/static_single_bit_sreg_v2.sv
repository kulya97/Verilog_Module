//File: static_single_bit_sreg_v2.sv
module static_single_bit_sreg_v2
#(
  parameter DEPTH         = 512,
  parameter SRL_STYLE_VAL = "srl"
)
(
  input logic clk,
  input logic ce,
  input logic si,
  output logic so
);

  (* SRL_STYLE = SRL_STYLE_VAL *)
  logic [DEPTH - 1 : 0] sreg = '0;

  always_ff @(posedge clk) begin
    if (ce) begin
      sreg[0] <= si;
      for (int i = 0; i < DEPTH - 1; i++) begin
        sreg[i + 1] <= sreg[i];
      end
    end
  end

  always_comb begin
    so = sreg[DEPTH - 1];
  end
endmodule

