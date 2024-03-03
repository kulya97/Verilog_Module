timeunit 1ns;
timeprecision 1ps;

module array_counter_tb;

  parameter shortreal PERIOD = 2.5;
  parameter W = 6;
  parameter N = 2;
  parameter IDW = $clog2(N);
  parameter NUMA = 4;
  parameter NUMB = 4;
  parameter NUMC = 4;

  bit clk;
  logic rst, inc, dec;
  logic [IDW - 1 : 0] inc_id, dec_id;
  logic [W - 1 : 0] cnt [N];

  array_counter_v3 #(.W(W), .N(N)) i_array_counter_v3 (.*);

  default clocking cb @(posedge clk);
    default input #1step output #0;
    input cnt;
    output rst, inc, dec, inc_id, dec_id;
  endclocking

  initial begin
    clk = '0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  initial begin
    rst <= '1;
    inc <= '0;
    dec <= '0;
    inc_id <= '0;
    dec_id <= '1;
    ##1 cb.rst <= '0;
    for (int i = 0; i < NUMA; i++) begin
      ##1 cb.inc <= i[0];
          cb.inc_id <= '0;
          cb.dec <= '1;
          cb.dec_id <= '1;
    end
    for (int i = 0; i < NUMB; i++) begin
      ##1 cb.inc <= '1;
          cb.inc_id <= '0;
          cb.dec <= '0;
          cb.dec_id <= '0;
    end
    for (int i = 0; i < NUMC; i++) begin
      ##1 cb.inc <= '0;
          cb.inc_id <= '1;
          cb.dec <= '1;
          cb.dec_id <= '1;
    end
    for (int i = 0; i < NUMC; i++) begin
      ##1 cb.inc <= '1;
          cb.inc_id <= '1;
          cb.dec <= '1;
          cb.dec_id <= '1;
    end
    for (int i = 0; i < NUMC; i++) begin
      ##1 cb.inc <= '1;
          cb.inc_id <= '0;
          cb.dec <= '1;
          cb.dec_id <= '1;
    end
    ##1 $stop;
  end
endmodule
