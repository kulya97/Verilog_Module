//File: static_single_bit_sreg_ff.sv
module static_single_bit_sreg_ff
#(
  parameter DEPTH = 8,
  parameter SRL_STYLE_VAL = "srl"

)
(
  input logic clk,
  input logic rst,
  input logic ce,
  input logic si,
  output logic so
);

  logic [DEPTH - 1 : 0] sreg = '0;

  always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
      sreg <= '0;
    end
    else if (ce) begin 
      sreg <= {sreg[DEPTH - 2 : 0], si};
    end
  end

  always_comb begin
    so = sreg[DEPTH - 1];
  end
endmodule
