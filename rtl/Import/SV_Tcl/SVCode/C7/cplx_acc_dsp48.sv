//File: cplx_acc_dsp48.sv
module cplx_acc_dsp48 
#(
  parameter AW = 16, //width of 1st input
  parameter BW = 18, //width of 2nd input
  parameter PW = 40  //output width
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
                
  logic signed [AW - 1  : 0] ai_d1, ai_d2, ai_d3, ai_d4;
  logic signed [AW - 1  : 0] ar_d1, ar_d2, ar_d3, ar_d4;
  logic signed [BW - 1  : 0] bi_d1, bi_d2, bi_d3, br_d1, br_d2, br_d3;
  logic signed [AW      : 0] addcommon;
  logic signed [BW      : 0] addr, addi;
  logic signed [AW + BW : 0] mult0, multr, multi;	 
  logic signed [PW - 1  : 0] pr_int, pi_int, old_res_real, old_res_im;
  logic signed [AW + BW : 0] common, commonr1, commonr2;

  logic sload_d1;   
 
  always_ff @(posedge clk) begin
    ar_d1    <= ar;
    ar_d2    <= ar_d1;
    ai_d1    <= ai;
    ai_d2    <= ai_d1;
    br_d1    <= br;
    br_d2    <= br_d1;
    br_d3    <= br_d2;
    bi_d1    <= bi;
    bi_d2    <= bi_d1;
    bi_d3    <= bi_d2;
    sload_d1 <= sload;
  end
 
  //Common factor (ar-ai) x bi 
  always_ff @(posedge clk) begin
    addcommon <= ar_d1 - ai_d1;
    mult0     <= addcommon * bi_d2;
    common    <= mult0;
  end

  //Accumulation loop (combinatorial) for *Real*
  always_comb begin
    old_res_real = sload_d1 ? '0 : pr_int;
    pr           = pr_int;
  end

  //Real product
  always_ff @(posedge clk) begin
    ar_d3    <= ar_d2;
    ar_d4    <= ar_d3;
    addr     <= br_d3 - bi_d3;
    multr    <= addr * ar_d4;
    commonr1 <= common;
    pr_int   <= multr + commonr1 + old_res_real;
  end

  //Accumulation loop (combinatorial) for *Imaginary*
  always_comb begin
    old_res_im = sload_d1 ? '0 : pi_int;
    pi         = pi_int;
  end

  //Imaginary product
  always_ff @(posedge clk) begin
    ai_d3    <= ai_d2;
    ai_d4    <= ai_d3;
    addi     <= br_d3 + bi_d3;	 
    multi    <= addi * ai_d4;
    commonr2 <= common;
    pi_int   <= multi + commonr2 + old_res_im;
  end

endmodule
