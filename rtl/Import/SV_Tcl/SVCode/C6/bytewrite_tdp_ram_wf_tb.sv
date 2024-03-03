timeunit 1ns;
timeprecision 1ps;

module bytewrite_tdp_ram_wf_tb;

  parameter AW = 5;
  parameter NB = 4;
  parameter DW = NB * 8;
  parameter shortreal PERIOD_CLKA = 5;
  parameter shortreal PERIOD_CLKB = 2.5;
  parameter NUM = 16;

  bit                 clka;
  logic  [NB - 1 : 0] wea;
  logic  [AW - 1 : 0] addra;
  logic  [DW - 1 : 0] dina;
  logic  [DW - 1 : 0] douta;
  bit                 clkb;
  logic  [NB - 1 : 0] web;
  logic  [AW - 1 : 0] addrb;
  logic  [DW - 1 : 0] dinb;
  logic  [DW - 1 : 0] doutb;

  bytewrite_tdp_ram_wf #(.AW(AW), .NB(NB))
  i_bytewrite_tdp_ram_wf (.*);

  initial begin
    clka = 0;
    forever #(PERIOD_CLKA / 2) clka = ~clka;
  end

  initial begin
    clkb = 0;
    forever #(PERIOD_CLKA / 2) clkb = ~clkb;
  end

  default clocking cba @(posedge clka);
    default input #1step output #0;
    output wea, addra, dina;
    input douta;
  endclocking

  clocking cbb @(posedge clkb);
    default input #1step output #0;
    output web, addrb, dinb;
    input doutb;
  endclocking

  initial begin
    wea   <= '0;
    addra <= '0;
    dina  <= '0;
    for (int i = 0; i < NUM; i++) begin
      ##1 cba.wea   <= i + 1;
          cba.addra <= i;
          cba.dina  <= 32'hAABBCCDD + $urandom_range(1, 10);
      ##1 cba.wea   <= '0;
          if (i == 0) begin
            cba.addra <= i;
          end 
          else begin
            cba.addra <= i - 1;
          end
    end
  end

  initial begin
    web   <= '0;
    addrb <= '0;
    dinb  <= '0;
    for (int k = NUM; k < 2 * NUM; k++) begin
      repeat (1) @cbb begin
        cbb.web   <= k - NUM + 1;
        cbb.addrb <= k;
        cbb.dinb  <= 32'hEEFFAABB + $urandom_range(1, 10) + k;
      end
      repeat (1) @cbb begin
        cbb.web   <= '0;
        cbb.addrb <= k - 1;
      end
    end
  end

endmodule
