//File: dynamic_neg_mult.sv
//P = (D±B)xA => D = 0 => P = (±B)xA
//subadd 1 : A-D; 0 : A+D
module dynamic_neg_mult
#(
  parameter AW = 27,
  parameter BW = 18,
  parameter MW = AW + BW
)
(
  input logic clk,
  input logic subadd,
  input logic signed [AW - 1 : 0] ain,
  input logic signed [BW - 1 : 0] bin,
  output logic signed [MW - 1 : 0] pout
);

  logic subadd_d1;
  logic signed [AW - 1 : 0] ain_d1, ain_d2;
  logic signed [BW - 1 : 0] bin_d1;
  logic signed [AW     : 0] add_reg;
  logic signed [MW - 1 : 0] mreg;

  always_ff @(posedge clk) begin
    subadd_d1 <= subadd;
    ain_d1    <= ain;
    ain_d2    <= ain_d1;
    bin_d1    <= bin;
    add_reg   <= subadd_d1 ? (0 + bin_d1) : (0 - bin_d1);
    mreg      <= add_reg * ain_d2;
    pout      <= mreg;
  end
endmodule
