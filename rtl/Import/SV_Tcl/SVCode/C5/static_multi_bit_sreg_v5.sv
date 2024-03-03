///////////////////////////////////////////////////////////////////////
//File: static_multi_bit_sreg_v5.sv
//Author: Gao Yajun
//Parameters:
//DEPTH: define the clock cycle from input to output. Namely Latency
//WIDTH: data width
//SRL_STYLE_VAL: register, srl, reg_srl, srl_reg, reg_srl_reg
//If DEPTH < 5, then register is optimal
//Otherwise, you can set to srl_reg or reg_srl_reg or reg_srl
//DEPTH must be equal to or greater than 1
///////////////////////////////////////////////////////////////////////
module static_multi_bit_sreg_v5
#(
  parameter DEPTH = 18,
  parameter WIDTH = 2,
  parameter SRL_STYLE_VAL = "srl"
)
(
  input logic clk,
  input logic ce,
  input logic [WIDTH - 1 : 0]si,
  output logic [WIDTH - 1 : 0]so
);

  (* srl_style = SRL_STYLE_VAL *)
  logic [WIDTH - 1 : 0] sreg [DEPTH] = '{default:0};

  always_comb begin
    so = sreg[DEPTH - 1];
  end

  always_ff @(posedge clk) begin
    if (ce) begin 
      sreg[0] <= si;
    end
  end
  
  generate
  for (genvar i = 1; i < DEPTH; i++) begin
    always_ff @(posedge clk) begin
      if (ce)
        sreg[i] <= sreg[i - 1];
    end
  end
  endgenerate
    
endmodule

