//File: mult_acc_v2.sv
module mult_acc_v2
#(
  parameter AW = 27,
  parameter BW = 18,
  parameter PW = 48
)
( 
  input logic clk,
  input logic sload, // synchronous load
  input logic signed [AW - 1 : 0] ain,
  input logic signed [BW - 1 : 0] bin,
  output logic signed [PW - 1 : 0] pout
);

  localparam MW = AW + BW;
  logic sload_d1;
  logic signed [AW - 1 : 0] ain_d1;
  logic signed [BW - 1 : 0] bin_d1;
  logic signed [MW - 1 : 0] mreg;
  logic signed [PW - 1 : 0] adder_out, old_res;

  always_comb begin
    old_res = sload_d1 ? '0 : adder_out;
    pout    = adder_out;
  end

  always_ff @(posedge clk) begin
    sload_d1  <= sload;
    ain_d1    <= ain;
    bin_d1    <= bin;
    mreg      <= ain_d1 * bin_d1;
    adder_out <= old_res + mreg;
    //adder_out <= old_res - mreg;
   // adder_out <= mreg - old_res;
  end
endmodule

