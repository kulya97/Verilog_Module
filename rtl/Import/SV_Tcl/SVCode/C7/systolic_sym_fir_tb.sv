`timescale 1ns/1ps
//`include "systolic_sym_fir_pkg.sv"

//import systolic_sym_fir_pkg::*;

module systolic_sym_fir_tb;
  localparam TAP    = 8;  // length of FIR
  localparam HTAP   = TAP / 2;  
  localparam XIN_W  = 16; // width of x(n)
  localparam COE_W  = 16; // width of h(n)
  localparam ACC_W  = 48; // width of accumulator
  localparam YOUT_W = 26; // width of y(n)
  parameter PERIOD = 5.0;
  parameter NUM    = 16;

  bit clk;
  logic signed [XIN_W - 1 : 0] xin;
  logic signed [YOUT_W - 1 : 0] yout;

  systolic_sym_fir i_systolic_sym_fir (.*);

  initial begin
    clk = '0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  default clocking cb @(posedge clk);
    default input #1step output #0;
    output xin;
    input yout;
  endclocking

  initial begin
    xin <= '0;
    repeat (1) @cb;
    for (int i = 0; i < TAP; i++) begin
      if (i == 0) 
        ##1 cb.xin <= 1;
      else 
        ##1 cb.xin <= 0;
    end
    for (int i = 0; i < NUM; i++) begin
      ##1 cb.xin <= $urandom_range(-10, 10);
    end
    repeat (4) @cb;
    $stop;
  end
endmodule
      
