(* USE_DSP = "yes" *)
module dynamic_adder
#( 
  parameter DIW = 32,
  parameter DOW = DIW + 1,
  parameter type DTYPE = logic signed
 )
(
  input logic clk,
  input logic addsub,
  input DTYPE [DIW - 1 : 0] ain,
  input DTYPE [DIW - 1 : 0] bin,
  output DTYPE [DOW - 1 : 0] sum
);

  logic addsub_d1;
  DTYPE [DIW - 1 : 0] ain_d1;
  DTYPE [DIW - 1 : 0] bin_d1;

  always_ff @(posedge clk) begin
    ain_d1    <= ain;
    bin_d1    <= bin;
    addsub_d1 <= addsub;
    sum       <= addsub_d1 ? ain_d1 - bin_d1 : ain_d1 + bin_d1;
  end

endmodule


