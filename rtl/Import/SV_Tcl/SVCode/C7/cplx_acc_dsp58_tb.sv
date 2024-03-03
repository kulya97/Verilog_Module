timeunit 1ns;
timeprecision 1ps;

module cplx_acc_dsp58_tb;

  parameter AW = 18;
  parameter BW = 18;
  parameter PW = 58;
  parameter shortreal PERIOD = 5.0;
  parameter NUM = 16;

  bit clk;
  logic sload;
  logic signed [AW - 1 : 0] ar, ai;
  logic signed [BW - 1 : 0] br, bi;
  logic signed [PW - 1 : 0] pr, pi;

  cplx_acc_dsp58 #(.AW(AW), .BW(BW), .PW(PW)) 
  i_cplx_acc_dsp58 (.*);

  initial begin
    clk = '0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  default clocking cb @(posedge clk);
    default input #1step output #0.2;
    output sload, ar, ai, br, bi;
    input pr, pi;
  endclocking

  initial begin
    sload <= '0;
    ar <= '0;
    ai <= '0;
    br <= '0;
    bi <= '0;
    for (int i = 0; i < NUM; i++) begin
      if (i % 2 == 0) begin
        ##1 cb.sload <= '1;
            cb.ar <= $urandom_range(-10, 10);
            cb.ai <= $urandom_range(-9, 10);
            cb.br <= $urandom_range(-10, 10);
            cb.bi <= $urandom_range(-10, 10);
      end
      else begin
        ##1 cb.sload <= '0;
            cb.ar <= $urandom_range(-10, 10);
            cb.ai <= $urandom_range(-9, 10);
            cb.br <= $urandom_range(-10, 10);
            cb.bi <= $urandom_range(-10, 10);
      end
    end
    repeat (4) @cb;
    $stop;
  end
endmodule






  
