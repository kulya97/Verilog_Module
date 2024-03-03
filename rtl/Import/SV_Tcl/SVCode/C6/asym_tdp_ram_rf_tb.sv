timeunit 1ns;
timeprecision 1ps;

module asym_tdp_ram_rf_tb;
  parameter PORTA_DW = 16;
  parameter PORTA_AW = 8;
  parameter PORTB_DW = 4;
  parameter PORTB_AW = 10;
  parameter shortreal PERIOD_CLKA = 5;
  parameter shortreal PERIOD_CLKB = 4;
  parameter NUM                   = 16;
  
  bit                      clka;
  logic                    wea;
  logic [PORTA_AW - 1 : 0] addra;
  logic [PORTA_DW - 1 : 0] dina;
  logic [PORTA_DW - 1 : 0] douta;
  bit                      clkb;
  logic                    web;
  logic [PORTB_AW - 1 : 0] addrb;
  logic [PORTB_DW - 1 : 0] dinb;
  logic [PORTB_DW - 1 : 0] doutb;

  asym_tdp_ram_rf 
  #(
    .PORTA_DW (PORTA_DW),
    .PORTA_AW (PORTA_AW),
    .PORTB_DW (PORTB_DW),
    .PORTB_AW (PORTB_AW)
   )
   i_asym_tdp_ram_rf 
   (.*);


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
    for (int i = 0; i < NUM; i = i + 2) begin
      ##1 cba.wea   <= '1;
          cba.addra <= i;
          cba.dina  <= 16'hAABB + $urandom_range(1, 10);
      ##1 cba.wea   <= '1;
          cba.addra <= i + 1;
          cba.dina  <= 16'hCCDD + $urandom_range(1, 10);
      ##1 cba.wea   <= '0;
          cba.addra <= i;
    end
  end

  initial begin
    int  k   = 0;
    web   <= '0;
    addrb <= '0;
    dinb  <= '0;
    ##2
    repeat (4) @cbb begin
      cbb.addrb <= k;
      k = k + 1;
    end
    for (k = 4 * NUM; k < 5 * NUM; k++) begin
      @cbb
      cbb.web <= 1;
      cbb.addrb <= k;
      cbb.dinb  <= $urandom_range(1, 15);
      @cbb
      cbb.web <= '0;
      cbb.addrb <= k;
    end
  end
endmodule
