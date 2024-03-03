timeunit 1ns;
timeprecision 1ps;

class rand_data #(int DW = 4);
  rand bit [DW - 1 : 0] data;
endclass

module async_fifo_tb;
  
  parameter WCLK_PERIOD = 2.5;
  parameter RCLK_WCLK_RATIO = 2; // RATIO = RCLK_PERIOD / WCLK_PERIOD
  parameter RCLK_PERIOD = WCLK_PERIOD * RCLK_WCLK_RATIO;
  parameter DW = 4;
  parameter AW = 3;

  bit   wclk, rclk;
  logic wen, ren;
  logic wrst, rrst;
  logic [DW - 1 : 0] din;
  logic wfull;
  logic rempty;
  logic [DW - 1 : 0] dout;
  logic dout_valid;

  async_fifo #(.DW(DW), .AW(AW)) i_async_fifo (.*);
  rand_data #(.DW(DW)) i_rand_data;

  initial begin
    wclk = 0;
    forever begin
      #(WCLK_PERIOD / 2) wclk = ~wclk;
    end
  end

  initial begin
    rclk = 0;
    forever begin
      #(RCLK_PERIOD / 2) rclk = ~rclk;
    end
  end

  default clocking wcb @(posedge wclk);
    default input #1step output #0;
    output wrst, wen, din;
    input wfull;
  endclocking

  clocking rcb @(posedge rclk);
    default input #1step output #0;
    output rrst, ren;
    input rempty, dout, dout_valid;
  endclocking

  initial begin
    i_rand_data = new();
    wrst <= '1;
    wen  <= '0;
    din  <= '0;
    repeat(2) @(wcb);
    wcb.wrst <= '0;
    repeat(1) @(wcb);
    repeat(12) @(wcb) begin
      wcb.wen <= '1;
      i_rand_data.randomize();
      wcb.din <= i_rand_data.data;
    end
    repeat(2) @(wcb) begin
      wcb.wen <= '0;
    end
    repeat(30) @(wcb);
    repeat(4) @(wcb) begin
      wcb.wen <= '1;
      i_rand_data.randomize();
      wcb.din <= i_rand_data.data;
    end
    ##1 wcb.wen <= '0;
    repeat(80) @(wcb);
    repeat(60) @(wcb) begin
      wcb.wen <= '1;
      i_rand_data.randomize();
      wcb.din <= i_rand_data.data;
    end

  end

  initial begin
    rrst <= '1;
    ren  <= '0;
    repeat(2) @(rcb);
    rcb.rrst <= '0;
    repeat(6) @(rcb);
    repeat(12) @(rcb) begin
      rcb.ren <= '1;
    end
    repeat(2) @(rcb) begin
      rcb.ren <= '0;
    end
    repeat(30) @(rcb);
    repeat(6) @(rcb) begin
      rcb.ren <= '1;
    end
    repeat(1) @(rcb) begin
      rcb.ren <= '0;
    end
    repeat(5) @(rcb);
    for (int i = 0; i < 60; i++) begin
      repeat(1) @(rcb) begin
        rcb.ren <= '1;
      end
      repeat(1) @(rcb) begin
        rcb.ren <= '0;
      end
    end
  end
endmodule
    
