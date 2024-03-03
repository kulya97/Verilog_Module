//File: dynamic_preadd_mult.sv
//P = (D±A)xB
//subadd 1 : D-A; 0 : D+A
module dynamic_preadd_mult_v3
#(
  parameter AW = 27,
  parameter DW = 27,
  parameter BW = 18,
  parameter MW = AW + BW
)
(
  input logic clk,
  input logic subadd,
  input logic signed [AW - 1 : 0] ain,
  input logic signed [DW - 1 : 0] din,
  input logic signed [BW - 1 : 0] bin,
  output logic signed [MW - 1 : 0] pout
);

  logic subadd_d1;
  logic signed [AW - 1 : 0] ain_d1, din_d1;
  logic signed [BW - 1 : 0] bin_d1, bin_d2;
  logic signed [AW     : 0] add_reg;
  logic signed [MW - 1 : 0] mreg;

  always_ff @(posedge clk) begin
    subadd_d1 <= subadd;
    ain_d1    <= ain;
    din_d1    <= din;
    bin_d1    <= bin;
    bin_d2    <= bin_d1;
    add_reg   <= subadd_d1 ? (din_d1 - ain_d1) : (din_d1 + ain_d1);
    mreg      <= add_reg * bin_d2;
    pout      <= mreg;
  end
endmodule
