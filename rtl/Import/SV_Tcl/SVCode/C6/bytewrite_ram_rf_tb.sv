timeunit 1ns;
timeprecision 1ns;

module bytewrite_ram_rf_tb;

  parameter AW = 2;
  parameter NB = 2;
  parameter DW = NB * 8;
  parameter shortreal PERIOD = 5;
  parameter NUM = 16;

  bit clk;
  logic [NB - 1 : 0] we;
  logic [AW - 1 : 0] addr;
  logic [NB * 8 - 1 : 0] din;
  logic [NB * 8 - 1 : 0] dout;

  bytewrite_ram_nc #(.AW(AW), .NB(NB))
  i_bytewrite_ram_nc (.*);


  initial begin
    clk = '0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  default clocking cb @(posedge clk);
    default input #1step output #0;
    output we, addr, din;
    input dout;
  endclocking

  initial begin
    we   <= '0;
    addr <= '0;
    din  <= '0;
    for (int i = 0; i < NUM; i++) begin
      ##1 cb.we   <= 2'b10;
          cb.addr <= 2'b00;
          cb.din  <= 16'hABCD;
      ##1 cb.we   <= 2'b01;
          cb.addr <= 2'b00;
          cb.din  <= 16'hABCD;
      ##1 cb.we   <= 2'b10;
          cb.addr <= 2'b01;
          cb.din  <= 16'hEEFF;
      ##1 cb.we   <= 2'b01;
          cb.addr <= 2'b01;
          cb.din  <= 16'hEEFF;
      ##1 cb.we   <= 2'b00;
          cb.addr <= 2'b00;
      ##1 cb.we   <= 2'b00;
          cb.addr <= 2'b01;
    end
    $stop;
  end
endmodule
