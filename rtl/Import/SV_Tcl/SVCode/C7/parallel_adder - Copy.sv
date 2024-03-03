(* use_dsp = "simd" *)
module parallel_adder 
#(
  parameter N = 4,   // Number of Adders
  parameter W = 10,  // Width of the Adders
  parameter type DTYPE = logic unsigned
)
(
  input logic clk,
  input DTYPE [W - 1 : 0] a [N],
  input DTYPE [W - 1 : 0] b [N],
  output DTYPE [W - 1 : 0] sum [N]
);
                     
  DTYPE [W - 1 : 0] a_d1 [N];
  DTYPE [W - 1 : 0] b_d1 [N];
  
  always_ff @(posedge clk) begin
    for(int i = 0; i < N; i++) begin
      a_d1[i] <= a[i];
      b_d1[i] <= b[i];
      sum[i]  <= a_d1[i] + b_d1[i];
    end
  end
endmodule
