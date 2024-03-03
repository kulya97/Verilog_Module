timeunit 1ns;
timeprecision 1ns;

module sdp_two_clk_tb;

  parameter AW = 4;
  parameter DW = 4;
  parameter shortreal PERIOD_CLKA = 5;
  parameter shortreal PERIOD_CLKB = 10;
  parameter NUM = 8;

  int i, k = 0;;
  bit clka;
  logic wea;
  logic [AW - 1 : 0] addra;
  logic [DW - 1 : 0] dina;
  bit clkb;
  logic reb;
  logic [AW - 1 : 0] addrb;
  logic [DW - 1 : 0] doutb;

  sdp_two_clk #(.AW(AW), .DW(DW))
  i_sdp_two_clk (.*);

  initial begin
    clka = '0;
    #PERIOD_CLKA clka = '1;
    forever #(PERIOD_CLKA / 2) clka = ~clka;
  end

  initial begin
    clkb = '0;
    #PERIOD_CLKA clkb = '1;
    forever #(PERIOD_CLKB / 2) clkb = ~clkb;
  end

  default clocking cbw @(posedge clka);
    default input #1step output #0;
    output wea, addra, dina;
  endclocking

  clocking cbr @(posedge clkb);
    default input #1step output #0;
    output reb, addrb;
    input doutb;
  endclocking

  initial begin
    wea   <= '0;
    addra <= '0;
    dina  <= '0;
    for (i = 0; i < NUM; i++) begin
      ##1 cbw.wea   <= '1;
          cbw.addra <= i;
          cbw.dina  <= $urandom_range(1, 2 ** DW - 1);
    end
    ##1 cbw.wea <= '0;
  end

  initial begin
    reb <= '0;
    addrb <= '0;
    repeat (NUM / 4) @cbr;
    repeat (NUM) @(cbr) begin
      cbr.reb <= '1;
      cbr.addrb <= k;
      k = k + 1;
    end
    cbr.reb <= '0;
    repeat (3) @cbr;
    $stop;
  end
endmodule
    
    



  
