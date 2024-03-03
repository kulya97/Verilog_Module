//File: advanced_mult.sv
//Author: Gao Yajun
module advanced_mult
#(
  parameter AW = 27,
  parameter BW = 18,
  parameter AREG = 0,
  parameter PREG = 0,
  parameter MW = AW + BW
)
(
  input logic clk,
  input logic signed [AW - 1 : 0] ain,
  input logic signed [BW - 1 : 0] bin,
  output logic signed [MW - 1 : 0] prod
);
  
  logic signed [MW - 1 : 0] prod_i;
  
  if (AREG) begin
    logic signed [AW - 1 : 0] ain_d1;
    logic signed [BW - 1 : 0] bin_d1;
    always_ff @(posedge clk) begin
      ain_d1 <= ain;
      bin_d1 <= bin;
      prod_i <= ain_d1 * bin_d1;
    end
  end
  else begin 
    always_ff @(posedge clk) begin
      prod_i <= ain * bin;
    end
  end

  if (PREG) begin
    always_ff @(posedge clk) begin
      prod <= prod_i;
    end
  end
  else begin
    always_comb prod = prod_i;
  end
endmodule
      

