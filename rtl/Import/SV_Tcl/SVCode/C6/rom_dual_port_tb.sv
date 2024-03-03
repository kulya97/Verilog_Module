timeunit 1ns;
timeprecision 1ps;

module rom_dual_port_tb;
  parameter AW = 4;
  parameter DW = 16;
  parameter shortreal PERIOD_CLKA = 5.0;
  parameter shortreal PERIOD_CLKB = 2.5;
  parameter NUM = 2 ** AW;

  bit clka;
  logic ena;
  logic [AW - 1 : 0] addra;
  logic [DW - 1 : 0] douta;
  bit clkb;
  logic enb;
  logic [AW - 1 : 0] addrb;
  logic [DW - 1 : 0] doutb;

  rom_dual_port #(.AW(AW), .DW(DW))
  i_rom_dual_port (.*);
  
  initial begin
    clka = '0;
    forever #(PERIOD_CLKA / 2) clka = ~clka;
  end
  
  initial begin
    clkb = '0;
    forever #(PERIOD_CLKB / 2) clkb = ~clkb;
  end
  
  default clocking cba @(posedge clka);
    default input #1step output #0;
    output ena, addra;
    input douta;
  endclocking

  clocking cbb @(posedge clkb);
    default input #1step output #0;
    output enb, addrb;
    input doutb;
  endclocking

  initial begin
    ena <= '0;
    addra <= '0;
    for (int i = 0; i < NUM; i++) begin
      ##1 cba.ena <= '1;
          cba.addra <= i;
    end
  end

  initial begin
    enb <= '0;
    addrb <= '0;
    for (int k = 0; k < NUM; k++) begin
      @cbb
      cbb.enb <= '1;
      cbb.addrb <= k;
    end
  end
endmodule

