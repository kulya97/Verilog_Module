//File: mux_opt_tb.sv
timeunit 1ns;
timeprecision 1ps;

class rand_data;
  rand bit [15 : 0] dina;
  rand bit [15 : 0] dinb;
endclass

module mux_opt_tb;

  parameter shortreal PERIOD = 5;
  parameter NUM = 512;

  bit clk;
  logic en;
  logic [15 : 0] dina, dinb;
  logic [15 : 0] dout;

  rand_data i_rand_data;
  mux_opt_before i_mux_opt_before (.*);
//  mux_opt_after  i_mux_opt_after (.*);
  
  initial begin
    clk = 0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  default clocking cb @(posedge clk);
    default input #1step output #0;
    output en, dina, dinb;
    input dout;
  endclocking

  initial begin
    en <= '0;
    dina <= '0;
    dinb <= '0;
    i_rand_data = new();
    for (int i = 0; i < NUM; i++) begin
      i_rand_data.randomize();
      ##1 cb.en <= '1;
          cb.dina <= i_rand_data.dina;
          cb.dinb <= i_rand_data.dinb;
    end
    repeat (4) @cb;
    cb.en <= '0;
    $stop;
  end
endmodule


