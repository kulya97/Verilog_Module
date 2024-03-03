//File: static_single_bit_sreg_v1.sv
module static_single_bit_sreg_v1
#(
  parameter DEPTH = 8,
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
      sreg <= {sreg[DEPTH - 2 : 0], si};
    end
  end

  always_comb begin
    so = sreg[DEPTH - 1];
  end
endmodule
