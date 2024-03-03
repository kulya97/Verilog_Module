//File: bin_mux4_v1.sv
module bin_mux4_v1
#(
  parameter W = 1 // data width
)
(
  input logic [1 : 0] sel,
  input logic [W - 1 : 0] a0, a1, a2, a3,
  output logic [W - 1 : 0] y
);

  
  logic [3 : 0] one_hot_sel;
  logic [W - 1 : 0] a [4];

  decoder_m2n_high_v1 #(.M(2)) 
  i_decoder_m2n_high_v1 (.a(sel), .en('1), .y(one_hot_sel));

  one_hot_mux4 #(.W(W))
  i_one_hot_mux (.s(one_hot_sel), .a0(a0), .a1(a1), .a2(a2), .a3(a3), .y(y));

endmodule


