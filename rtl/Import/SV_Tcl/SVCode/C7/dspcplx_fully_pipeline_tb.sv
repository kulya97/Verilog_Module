timeunit 1ns;
timeprecision 1ps;

module dspcplx_fully_pipeline_tb;

  parameter AW = 18;
  parameter BW = 18;
  parameter MW = AW + BW + 1;
  parameter shortreal PERIOD = 5.0;
  parameter NUM = 16;

  bit clk;
  logic signed [AW - 1 : 0] ar, ai;
  logic signed [BW - 1 : 0] br, bi;
  logic signed [MW     : 0] pr, pi;

  dspcplx_fully_pipeline #(.AW(AW), .BW(BW)) 
  i_dspcplx_fully_pipeline (.*);

  initial begin
    clk = '0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  default clocking cb @(posedge clk);
    default input #1step output #0;
    output ar, ai, br, bi;
    input pr, pi;
  endclocking

  initial begin
    ar <= '0;
    ai <= '0;
    br <= '0;
    bi <= '0;
    for (int i = 0; i < NUM; i++) begin
      ##1 cb.ar <= $urandom_range(-10, 10);
          cb.ai <= $urandom_range(-10, 10);
          cb.br <= $urandom_range(-10, 10);
          cb.bi <= $urandom_range(-10, 10);
    end
    repeat (4) @cb;
    $stop;
  end
endmodule






  
