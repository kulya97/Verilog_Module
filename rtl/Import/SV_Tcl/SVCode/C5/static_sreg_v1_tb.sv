timeunit 1ns;
timeprecision 1ps;

module static_sreg_v1_tb;
  parameter DEPTH = 4;
  parameter WIDTH = 4;
  parameter NUM   = 16;
  parameter shortreal PERIOD = 5;


  int i;
  bit clk;
  logic ce;
  logic [WIDTH - 1 : 0] si;
  logic [WIDTH - 1 : 0] so;

  static_multi_bit_sreg_v5 #(.DEPTH(DEPTH), .WIDTH(WIDTH))
  i_static_multi_bit_sreg_v5 (.*);

  initial begin
    clk = '0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  default clocking cb @(posedge clk);
    default input #1step output #0;
    output ce, si;
    input so;
  endclocking

  initial begin
    ce <= '0;
    si <= '0;
    for (i = 0; i < NUM; i++) begin
      ##3 cb.ce <= '1;
      ##1 cb.ce <= '0;
      cb.si <= $urandom_range(1, 2 ** WIDTH - 1);
    end
  end
endmodule



