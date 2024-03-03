(* dont_touch = "true" *)
module dspcplx_fully_pipeline 
#(
  parameter AW = 18,
  parameter BW = 18
)
(
  input logic clk,
  input logic signed [AW - 1 : 0] ar, //Real part of 1st complex input
  input logic signed [AW - 1 : 0] ai, //Imaginary part of 1st complex input
  input logic signed [BW - 1 : 0] br, //Real part of 2nd complex input
  input logic signed [BW - 1 : 0] bi, //Imaginary part of 2nd complex input
  output logic signed [AW + BW + 1 : 0] pr, //Real part of complex output
  output logic signed [AW + BW + 1 : 0] pi  //Imaginary part of complex output
);

  logic signed [AW - 1 : 0] ar_d1, ar_d2, ai_d1, ai_d2;
  logic signed [BW - 1 : 0] br_d1, br_d2, bi_d1, bi_d2;
  logic signed [AW : 0] addcommon;
  logic signed [BW : 0] addr, addi;
  logic signed [AW + BW : 0] multcommon, multr, multi;

  always_ff @(posedge clk) begin
  //Inputs are registered AREG=BREG=2
    ar_d1 <= ar;
    ar_d2 <= ar_d1;
    ai_d1 <= ai;
    ai_d2 <= ai_d1;
    bi_d1 <= bi;
    bi_d2 <= bi_d1;
    br_d1 <= br;
  //Pre-adders are registered ADREG=1
    addcommon <= ar_d1 - ai_d1;
    addr <= br_d1 - bi_d1;
    addi <= br_d1 + bi_d1;
  end

  //Multiplier output is registered MREG=1
  always_ff @(posedge clk) begin
    multcommon <= bi_d2 * addcommon;
    multr      <= ar_d2 * addr;
    multi      <= ai_d2 * addi;
  end
  
  //Complex output is registered PREG=1
  always_ff @(posedge clk) begin
    pr <=  multcommon + multr;
    pi <=  multcommon + multi;
  end

endmodule
