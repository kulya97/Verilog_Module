timeunit 1ns;
timeprecision 1ps;

module rom_case_tb;
  parameter AW = 4;
  parameter DW = 16;
  parameter shortreal PERIOD = 5.0;
  parameter NUM = 2 ** AW;

  bit clk;
  logic en;
  logic [AW - 1 : 0] addr;
  logic [DW - 1 : 0] dout;

  rom_case #(.AW(AW), .DW(DW))
  i_rom_case (.*);
  initial begin
    clk = '0;
    forever #(PERIOD / 2) clk = ~clk;
  end
  
  default clocking cb @(posedge clk);
    default input #1step output #0;
    output en, addr;
    input dout;
  endclocking

  initial begin
    en <= '0;
    addr <= '0;
    for (int i = 0; i < NUM; i++) begin
      ##1 cb.en <= '1;
          cb.addr <= i;
    end
    repeat (2) @cb;
    cb.en <= '0;
    repeat (2) @cb;
    $stop;
  end
endmodule
