timeunit 1ns;
timeprecision 1ns;

module tdp_ram_rf_tb;
  parameter AW = 4;
  parameter DW = 4;
  parameter PERIOD_CLKA = 5.0;
  parameter PERIOD_CLKB = 4.0;
  parameter NUM = 16;

  logic [3 : 0] i;
  logic [3 : 0] k;
  bit clka;
  logic wea;
  logic [AW - 1 : 0] addra;
  logic [DW - 1 : 0] dina;
  logic [DW - 1 : 0] douta;
  bit clkb;
  logic web;
  logic [AW - 1 : 0] addrb;
  logic [DW - 1 : 0] dinb;
  logic [DW - 1 : 0] doutb;

  tdp_ram_rf #(.AW(AW), .DW(DW))
  i_tdp_ram_rf (.*);

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
    for (i = 0; i < NUM; i++) begin
      ##1 cba.wea <= ~i[2];
          cba.addra <= {2'b00, i[1 : 0]};
          cba.dina  <= $urandom_range(1, 2 ** DW - 1) + i;
    end
  end

  initial begin
    k = 0;
    web   <= '0;
    addrb <= '0;
    dinb  <= '0;
    repeat (NUM+1) @cbb begin
      cbb.web   <= ~k[2];
      cbb.addrb <= {2'b01, k[1 : 0]};
      cbb.dinb  <= $urandom_range(1, 2 ** DW - 1) + k;
      k++;
    end
    cbb.web <= '0;
    $stop;
  end
endmodule

      
  

