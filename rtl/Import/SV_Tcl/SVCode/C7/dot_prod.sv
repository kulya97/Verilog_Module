//File: dot_prod.sv
module dot_prod 
#(
  parameter AW = 9,
  parameter BW = 8
)
(
  input logic clk,
  input logic signed [AW - 1 : 0] a0, a1, a2,
  input logic signed [BW - 1 : 0] b0, b1, b2,
  output logic signed [AW + BW + 1 : 0] p
);

  logic signed [AW - 1 : 0] a0_d1, a1_d1, a2_d1;
  logic signed [BW - 1 : 0] b0_d1, b1_d1, b2_d1;
  logic signed [AW + BW - 1 : 0] mult0, mult1, mult2;
  logic signed [AW + BW + 1 : 0] dotpr, dotpr_d1;

//Inputs registered
  always_ff @(posedge clk) begin
  	a0_d1 <= a0;	
  	a1_d1 <= a1;	
  	a2_d1 <= a2;	
  	b0_d1 <= b0;	
  	b1_d1 <= b1;	
  	b2_d1 <= b2;	
  end

//Multiplier 
  always_comb begin
    mult0 = a0_d1 * b0_d1;
    mult1 = a1_d1 * b1_d1;
    mult2 = a2_d1 * b2_d1;
    //dotpr = mult0 + mult1 + mult2;
    dotpr = -mult0 - mult1 - mult2;
  end

//Registering dot product output MREG=PREG=1 
  always_ff @(posedge clk) begin
    dotpr_d1 <= dotpr;
    p <= dotpr_d1;
  end

endmodule
