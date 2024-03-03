//File: preadd_mult.sv
module preadd_mult
#(
  parameter AW = 16,
  parameter BW = 18,
  parameter MW = AW + 1 + BW
)
(
  input logic clk,
  input logic rst,
  input logic ce,
  input logic signed [AW - 1 : 0] ain,
  input logic signed [AW - 1 : 0] din,
  input logic signed [BW - 1 : 0] bin,
  output logic signed [MW - 1 : 0] pout
);

  logic signed [AW - 1 : 0] ain_d1, din_d1;
  logic signed [BW - 1 : 0] bin_d1, bin_d2;
  logic signed [AW     : 0] add_reg;
  logic signed [MW - 1 : 0] mreg;

  always_ff @(posedge clk) begin
    if (rst) begin
      ain_d1  <= '0;
      din_d1  <= '0;
      bin_d1  <= '0;
      bin_d2  <= '0;
      add_reg <= '0;
      mreg    <= '0;
      pout    <= '0;
    end
    else if (ce) begin
      ain_d1  <= ain;
      din_d1  <= din;
      bin_d1  <= bin;
      bin_d2  <= bin_d1;
      add_reg <= ain_d1 + din_d1;
      mreg    <= add_reg * bin_d2;
      pout    <= mreg;
    end
  end
endmodule



