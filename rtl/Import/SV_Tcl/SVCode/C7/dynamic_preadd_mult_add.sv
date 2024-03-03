//File: dynamic_preadd_mult_add.sv
//P = (A+D)xB+C
module dynamic_preadd_mult_add
#(
  parameter AW = 16,
  parameter BW = 18,
  parameter CW = 32,
  parameter PW = 48,
  parameter MW = AW + 1 + BW
)
(
  input logic clk,
  input logic subadd,
  input logic signed [AW - 1 : 0] ain,
  input logic signed [AW - 1 : 0] din,
  input logic signed [BW - 1 : 0] bin,
  input logic signed [CW - 1 : 0] cin,
  output logic signed [PW - 1 : 0] pout
);

  logic subadd_d1;
  logic signed [AW - 1 : 0] ain_d1, din_d1;
  logic signed [BW - 1 : 0] bin_d1, bin_d2;
  logic signed [CW - 1 : 0] cin_d1, cin_d2, cin_d3;
  logic signed [AW     : 0] add_reg;
  logic signed [MW - 1 : 0] mreg;

  always_ff @(posedge clk) begin
    subadd_d1 <= subadd;
    ain_d1    <= ain;
    din_d1    <= din;
    bin_d1    <= bin;
    bin_d2    <= bin_d1;
    cin_d1    <= cin;
    cin_d2    <= cin_d1;
    cin_d3    <= cin_d2;
    add_reg   <= subadd_d1 ? (ain_d1 - din_d1) : (ain_d1 + din_d1);
    mreg      <= add_reg * bin_d2;
    pout      <= mreg + cin_d3;
  end
endmodule
