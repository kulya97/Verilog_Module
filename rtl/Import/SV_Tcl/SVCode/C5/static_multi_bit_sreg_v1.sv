//File: static_multi_bit_sreg_v1.sv
module static_multi_bit_sreg_v1
#(
  parameter WIDTH         = 4,
  parameter DEPTH         = 8,
  parameter SRL_STYLE_VAL = "srl"
)
(
  input logic clk,
  input logic ce,
  input logic [WIDTH - 1 : 0] si,
  output logic [WIDTH - 1 : 0] so
);

  for (genvar i = 0; i < WIDTH; i++) begin
    static_single_bit_sreg_v1
    #(
      .DEPTH(DEPTH),
      .SRL_STYLE_VAL(SRL_STYLE_VAL)
     )
    i_single_bit_sreg_v1
    (
     .clk (clk),
     .ce  (ce),
     .si  (si[i]),
     .so  (so[i])
    );
  end
endmodule
