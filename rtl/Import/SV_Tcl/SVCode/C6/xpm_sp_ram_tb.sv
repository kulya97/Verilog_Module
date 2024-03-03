timeunit 1ns;
timeprecision 1ps;

module xpm_sp_ram_tb;

  parameter shortreal PERIOD = 5;
  parameter AW = 3;
  parameter DW = 4;
  parameter CASCADE_HEIGHT = 8;
  parameter ECC_MODE = "no_ecc"; 
  parameter MEMORY_INIT_FILE = "sp_ram_8x4.mem";
  parameter MEMORY_PRIMITIVE = "distributed";
  parameter READ_LATENCY_A = 3;
  parameter WRITE_MODE_A = "read_first";

 
  bit clka;
  logic rsta;
  logic [AW-1 : 0] addra;
  logic [DW-1 : 0] dina;
  logic ena;
  logic wea;
  logic regcea;
  logic [DW-1 : 0] douta;

  xpm_sp_ram 
  #(
    .AW(AW),
    .DW(DW),
    .CASCADE_HEIGHT(CASCADE_HEIGHT),
    .ECC_MODE(ECC_MODE),
    .MEMORY_INIT_FILE(MEMORY_INIT_FILE),
    .MEMORY_PRIMITIVE(MEMORY_PRIMITIVE),
    .READ_LATENCY_A(READ_LATENCY_A),
    .WRITE_MODE_A(WRITE_MODE_A)
   )
  i_xpm_sp_ram (.*);

  initial begin
    clka = 0;
    forever begin
      #(PERIOD/2) clka = ~clka;
    end
  end

  default clocking cb @(posedge clka);
    default input #1step output #1;
    output rsta;
    output ena;
    output wea;
    output regcea;
    output addra;
    output dina;
    input douta;
  endclocking

  initial begin
    automatic int i = 0;
    rsta   <= 1;
    ena    <= 0;
    wea    <= 0;
    regcea <= 0;
    addra  <= 0;
    dina   <= 0;
    ##2 
    cb.rsta <= 0;
    repeat (9) @(posedge clka) begin
      cb.ena    <= 1;
      cb.regcea <= 1;
      cb.addra  <= i;
      i++;
    end
    i = 0;
    cb.addra <= 0;
    cb.ena   <= 0;
    repeat (9) @(posedge clka) begin
      cb.ena   <= 1;
      cb.addra <= i;
      cb.dina  <= i;
      cb.wea   <= 1;
      i++;
    end
    i = 0;
    cb.wea <= 0;
    cb.ena <= 0;
    repeat (9) @(posedge clka) begin
      cb.ena    <= 1;
      cb.regcea <= 1;
      cb.addra  <= i;
      i++;
    end
    repeat (5) @(posedge clka);
    $stop;
  end
endmodule
