//File: dynamic_neg_mult_add.sv
module dynamic_neg_mult_add
#(
  parameter AW = 27,
  parameter BW = 24,
  parameter CW = 58,
  parameter PW = 58
)
(
  input logic clk,
  input logic neg,
  input logic signed [AW - 1 : 0] ain,
  input logic signed [BW - 1 : 0] bin,
  input logic signed [CW - 1 : 0] cin,
  output logic signed [PW - 1 : 0] pout
);
  
  localparam MW = AW + BW;
  logic neg_d1, neg_d2;
  logic signed [AW - 1 : 0] ain_d1;
  logic signed [BW - 1 : 0] bin_d1;
  logic signed [MW - 1 : 0] mreg;
  logic signed [CW - 1 : 0] cin_d1, cin_d2;

  always_ff @(posedge clk) begin
    neg_d1 <= neg;
    neg_d2 <= neg_d1;
    ain_d1 <= ain;
    bin_d1 <= bin;
    cin_d1 <= cin; 
    cin_d2 <= cin_d1;
    mreg   <= ain_d1 * bin_d1;
    pout   <= cin_d2 + (neg_d2 ? -mreg : mreg);
  end
endmodule
        

