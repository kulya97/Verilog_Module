//File: sdp_ram_3d_tb.sv
timeunit 1ns;
timeprecision 1ps;

module sdp_ram_3d_tb;
  parameter NUM_RAMS = 2;
  parameter AW       = 4;
  parameter DW       = 4;
  parameter shortreal PERIOD_CLKA = 5;
  parameter shortreal PERIOD_CLKB = 2.5;
  parameter NUM      = 4;

  bit clka;
  logic [NUM_RAMS - 1 : 0] wea;
  logic [AW - 1 : 0] addra [NUM_RAMS];
  logic [DW - 1 : 0] dina  [NUM_RAMS];
  bit clkb;
  logic [NUM_RAMS - 1 : 0] reb;
  logic [NUM_RAMS - 1 : 0] rstb;
  logic [AW - 1 : 0] addrb [NUM_RAMS];
  logic [DW - 1 : 0] doutb [NUM_RAMS];

  sdp_ram_3d #(.NUM_RAMS(NUM_RAMS), .AW(AW), .DW(DW))
  i_sdp_ram_3d (.*);

  initial begin
    clka = '0;
    forever #(PERIOD_CLKA / 2) clka = ~clka;
  end

  initial begin
    clkb = '0;
    forever #(PERIOD_CLKA / 2) clkb = ~clkb;
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
    addra <= '{NUM_RAMS {'{default : '0}}};
    dina  <= '{NUM_RAMS {'{default : '0}}};
    for (int i = 0; i < NUM; i++) begin
      ##1 cbw.wea   <= '1;
          cbw.addra <= '{i, i};
          cbw.dina   <= '{ $urandom_range(1, 2 ** DW - 1)+i,  $urandom_range(1, 2 ** DW - 1)+i};
    end
  end

  initial begin
    reb   <= '0;
    rstb  <= '0;
    addrb <= '{NUM_RAMS {'{default : '0}}};
    repeat (1) @cbr;
    rstb  <= '1;
    repeat (1) @cbr;
    rstb  <= '0;
    for (int k = 0; k < NUM; k++) begin
      ##1 cbr.reb   <= '1;
          cbr.addrb <= '{k, k};
    end
  end
endmodule





