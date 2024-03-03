timeunit 1ns;
timeprecision 1ps;

module multi_bit_sreg_tb;
  parameter DEPTH = 4;
  parameter DW = 4;
  parameter NUM   = 16;
  parameter shortreal PERIOD = 5;


  int i;
  bit clk;
  logic ce;
  logic [DW - 1 : 0] din;
  logic [DW - 1 : 0] dout;

  multi_bit_sreg #(.DEPTH(DEPTH), .DW(DW))
  i_multi_bit_sreg (.*);

  initial begin
    clk = '0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  default clocking cb @(posedge clk);
    default input #1step output #0;
    output ce, din;
    input dout;
  endclocking

  initial begin
    ce <= '0;
    din <= '0;
    repeat (2) @cb;
    for (i = 0; i < NUM; i++) begin
      ##3 cb.ce <= '1;
      ##1 cb.ce <= '0;
      cb.din <= $urandom_range(1, 2 ** DW - 1);
    end
  end
endmodule



