timeunit 1ns;
timeprecision 1ps;

module get_device_dna_tb;

  parameter SIM_DNA_VALUE = 66;
  parameter shortreal PERIOD = 2.5;
  parameter DNA_LEN = 96;
  parameter NUM = DNA_LEN + 10;

  bit clk;
  logic rst;
  logic [95 : 0] dna;

  get_device_dna #(.SIM_DNA_VALUE(SIM_DNA_VALUE)) i_get_device_dna (.*);

  default clocking cb @(posedge clk);
    default input #1step output #0;
    input dna;
    output rst;
  endclocking

  initial begin
    clk = '0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  initial begin
    rst <= '1;
    ##2 
    cb.rst <= '0;
    ##(NUM)
    $stop;
  end
endmodule
