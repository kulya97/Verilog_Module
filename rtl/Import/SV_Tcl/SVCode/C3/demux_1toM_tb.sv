timeunit 1ns;
timeprecision 1ps;

class rand_data #(parameter W = 8);
  rand bit [W - 1 : 0] din;
endclass

module demux_1toM_tb;

  parameter W = 8;
  parameter M = 4;
  parameter K = $clog2(M);
  parameter NUM = 16;

  logic [K - 1 : 0] sel;
  logic [W - 1 : 0] din;
  logic [M - 1 : 0] [W - 1 : 0] y;
  logic [W - 1 : 0] y0, y1, y2, y3;

 // demux_1to4 #(.W(W)) i_demux_1to4 (.*);
  demux_1toM #(.W(W), .M(M)) i_demux_1toM (.*);

  rand_data #(.W(W)) i_rand_data;

  initial begin
    i_rand_data = new();
    for (int i = 0; i < NUM; i++) begin
      i_rand_data.randomize();
      din <= i_rand_data.din;
      for (int k = 0; k < M; k++) begin
        sel <= k;
        #5;
      end
    end
    $stop;
  end
endmodule

