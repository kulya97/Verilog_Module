timeunit 1ns;
timeprecision 1ps;

module asym_tdp_ram_rf_tb;
  parameter PORTA_WRITE_DW = 16;
  parameter PORTA_READ_DW  = 32;
  parameter PORTA_MAX_AW   = 10;
  parameter PORTB_WRITE_DW = 32;
  parameter PORTB_READ_DW  = 16;
  parameter PORTB_MAX_AW   = 10;
  parameter shortreal PERIOD_CLKA = 5;
  parameter shortreal PERIOD_CLKB = 4;
  parameter NUM                   = 16;
  
  int k = 16;
  bit                            clka;
  logic                          wea;
  logic [PORTA_MAX_AW   - 1 : 0] addra;
  logic [PORTA_WRITE_DW - 1 : 0] dina;
  logic [PORTA_READ_DW - 1 : 0]  douta;
  bit                            clkb;
  logic                          web;
  logic [PORTB_MAX_AW   - 1 : 0] addrb;
  logic [PORTB_WRITE_DW - 1 : 0] dinb;
  logic [PORTB_READ_DW - 1 : 0]  doutb;

  asym_tdp_ram_rf 
  #(
    .PORTA_WRITE_DW (PORTA_WRITE_DW),
    .PORTA_READ_DW  (PORTA_READ_DW),
    .PORTA_MAX_AW   (PORTA_MAX_AW),
    .PORTB_WRITE_DW (PORTB_WRITE_DW),
    .PORTB_READ_DA  (PORTB_READ_DW),
    .PORTB_MAX_AW   (PORTB_MAX_AW)
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
    web   <= '0;
    addrb <= '0;
    dinb  <= '0;
    for (int k = 16; k < 2 * NUM; k = k + 2) begin
      @(posedge cbb);
      cbb.web   <= '1;
      cbb.addrb <= k; 
      cbb.dinb  <= 32'hAABBCCDD + $urandom_range(1, 10);
      @(posedge cbb);
      cbb.web   <= '0;
      cbb.addrb <= k; 
      @(posedge cbb);
      cbb.web   <= '0;
      cbb.addrb <= k + 1;
    end
  end
endmodule



