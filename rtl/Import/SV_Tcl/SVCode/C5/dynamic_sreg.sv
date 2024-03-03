//File: dynamic_sreg.sv
module dynamic_sreg
#(
  parameter AW            = 2,
  parameter DW            = 1,
  parameter IS_SYNC       = "true",
  parameter SRL_STYLE_VAL = "srl"
)
(
  input logic clk,
  input logic ce,
  input logic [DW - 1 : 0] si,
  input logic [AW - 1 : 0] addr,
  output logic [DW - 1 : 0] so
);
  
  localparam DEPTH = 2 ** AW;

 
  //(* srl_style = SRL_STYLE_VAL *)
   (* shreg_extract = "no" *)
  logic [DW - 1 : 0] sreg [DEPTH] = '{default: '0};

  always_ff @(posedge clk) begin
    if (ce) begin
      sreg[0] <= si;
      for (int i = 1; i < DEPTH; i++) begin
        sreg[i] <= sreg[i - 1];
      end
    end
  end

  if (IS_SYNC == "true") begin: sync_out
    always_ff @(posedge clk) begin
      so <= sreg[addr];
    end
  end
  else begin: async_out
    always_comb begin
      so = sreg[addr];
    end
  end

endmodule

