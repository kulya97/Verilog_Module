timeunit 1ns;
timeprecision 1ps;

module dynamic_sreg_tb;
  parameter AW            = 2;
  parameter DW            = 4;
  parameter IS_SYNC       = "false";
  parameter SRL_STYLE_VAL = "srl";

  parameter shortreal PERIOD = 5;
  parameter NUM              = 32;
  parameter CE_CYCLE         = 2 ** AW;
  parameter MAX_VAL          = 2 ** DW - 1;

  logic [AW - 1 : 0] i;
  bit clk;
  logic ce;
  logic [DW - 1 : 0] si;
  logic [DW - 1 : 0] so;
  logic [AW - 1 : 0] addr;

  dynamic_sreg #(.AW(AW), .DW(DW), .IS_SYNC(IS_SYNC), .SRL_STYLE_VAL(SRL_STYLE_VAL))
  i_dynamic_sreg (.*);

  initial begin
    clk = '0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  default clocking cb @(posedge clk);
    default input #1step output #0;
    output ce, addr, si;
    input so;
  endclocking

  initial begin
    i    = '0;
    ce   <= '0;
    si   <= '0;
    addr <= '0;
    repeat (2) @cb;
    repeat (NUM) @cb begin
      cb.addr <= i;
      //cb.si   <= $urandom_range(MAX_VAL, 1);
      cb.ce   <= &i;
      if (i == 0) begin
        cb.si   <= $urandom_range(MAX_VAL, 1);
      end
      i = i + 1;
    end
    repeat (CE_CYCLE) @cb;
    $stop;
  end
endmodule


