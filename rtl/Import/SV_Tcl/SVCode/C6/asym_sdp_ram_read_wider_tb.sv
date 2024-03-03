timeunit 1ns;
timeprecision 1ns;

module asym_sdp_ram_read_wider_tb;

  parameter AWA = 10;
  parameter DWA = 4;
  parameter AWB = 8;
  parameter DWB = 16;
  parameter shortreal PERIOD_CLKA = 2.5;
  parameter NUMA = 16;

  localparam RATIO = DWB / DWA;
  localparam shortreal PERIOD_CLKB = PERIOD_CLKA * RATIO;
  localparam NUMB  = NUMA / RATIO;

  bit clka;
  logic wea;
  logic [AWA - 1 : 0] addra;
  logic [DWA - 1 : 0] dina;
  int k;
  bit clkb;
  logic reb;
  logic [AWB - 1 : 0] addrb;
  logic [DWB - 1 : 0] doutb;

  asym_sdp_ram_read_wider #(.AWA(AWA), .DWA(DWA), .AWB(AWB), .DWB(DWB))
  i_asym_sdp_ram_read_wider (.*);

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
  endclocking

  clocking cbb @(posedge clkb);
    default input #1step output #0;
    output reb, addrb;
    input doutb;
  endclocking

  initial begin
    wea   <= '0;
    addra <= '0;
    dina  <= '0;
    for (int i = 0; i < NUMA; i++) begin
      ##1 cba.wea   <= '1;
          cba.addra <= i;
          cba.dina  <= $urandom_range(1, 2 ** DWA - 1);
    end
    ##1 cba.wea <= '0;
  end

  initial begin
    k = 0;
    reb <= '0;
    addrb <= '0;
    //repeat (1) @cbb;
    #(PERIOD_CLKB);
    repeat (NUMB+1) @cbb begin
      cbb.reb <= '1;
      cbb.addrb <= k;
      k = k + 1;
    end
    cbb.reb <= '0;
    repeat (3) @cbb;
    $stop;
  end
endmodule
  
  



