//File: cplx_acc_dsp58.sv
module cplx_acc_dsp58 
#(
  parameter AW = 18, //width of 1st input
  parameter BW = 18, //width of 2nd input
  parameter PW = 58  //output width
)
(
  input logic clk,
  input logic sload,
  input logic signed [AW - 1 : 0] ar, //1st input of multiplier - real part
  input logic signed [AW - 1 : 0] ai, //1st input of multiplier - imaginary part
  input logic signed [BW - 1 : 0] br, //2nd input of multiplier - real part
  input logic signed [BW - 1 : 0] bi, //2nd input of multiplier - imaginary part
  output logic signed [PW - 1 : 0] pr, //output  - Real part
  output logic signed [PW - 1 : 0] pi  //output - Imaginary part
);

  logic sload_d1;
  logic signed [AW - 1  : 0] ar_d1, ar_d2, ai_d1, ai_d2;
  logic signed [BW - 1  : 0] br_d1, br_d2, bi_d1, bi_d2;
  logic signed [AW      : 0] addcommon;
  logic signed [BW      : 0] addr, addi;
  logic signed [AW + BW : 0] multcommon, multr, multi;
  logic signed [AW + BW : 0] multcommon_d;
  logic signed [AW + BW : 0] multr_d;
  logic signed [AW + BW : 0] multi_d;
  logic signed [PW - 1  : 0] pr_int, pr_old; 
  logic signed [PW - 1  : 0] pi_int, pi_old; 

  //Inputs are registered AREG=BREG=2
  always_ff @(posedge clk) begin
    ar_d1    <= ar;
    ar_d2    <= ar_d1;
    ai_d1    <= ai;
    ai_d2    <= ai_d1;
    bi_d1    <= bi;
    bi_d2    <= bi_d1;
    br_d1    <= br;
    sload_d1 <= sload;
  end
  
  //Pre-adders are registered ADREG=1
  always_ff @(posedge clk) begin
    addcommon <= ar_d1 - ai_d1;
    addr      <= br_d1 - bi_d1;
    addi      <= br_d1 + bi_d1;
  end
  
  //Common factor (ar-ai)*bi
  always_ff @(posedge clk) begin
    multcommon <= bi_d2 * addcommon;
    multr      <= ar_d2 * addr;
    multi      <= ai_d2 * addi;
  end

  always_comb begin
    pr_old = sload_d1 ? '0 : pr_int;
    pi_old = sload_d1 ? '0 : pi_int;
    pr     = pr_int;
    pi     = pi_int;
  end

  //Complex output is registered PREG=1
  always_ff @(posedge clk) begin
    pr_int <=  multcommon + multr + pr_old;
    pi_int <=  multcommon + multi + pi_old;
  end

endmodule
