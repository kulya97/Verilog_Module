//(* USE_DSP = "yes" *)
module adder
#( 
  parameter DIW = 32,
  parameter DOW = DIW + 1
 )
(
  input logic clk,
  input logic signed [DIW - 1 : 0] ain,
  input logic signed [DIW - 1 : 0] bin,
  output logic signed [DOW - 1 : 0] sum
);

  logic signed [DIW - 1 : 0] ain_d1;
  logic signed [DIW - 1 : 0] bin_d1;

  always_ff @(posedge clk) begin
    ain_d1 <= ain;
    bin_d1 <= bin;
    sum    <= ain_d1 + bin_d1;
  end

endmodule


