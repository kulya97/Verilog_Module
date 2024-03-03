timeunit 1ns; timeprecision 1ps;

class rand_data #(
    int W = 4
);
  rand bit [W - 1 : 0] data;
endclass

module sync_fifo_tb;
  parameter FIFO_PTR = 3;
  parameter FIFO_WIDTH = 4;
  parameter AW = 3;
  parameter DW = 4;
  parameter shortreal PERIOD = 4.0;

  bit                clk;
  logic              rst;
  logic              wen;
  //  logic [FIFO_WIDTH - 1 : 0] din;
  logic [DW - 1 : 0] din;
  logic              ren;
  logic              full;
  logic              empty;
  //  logic [FIFO_PTR : 0] room_avail;
  //  logic [FIFO_PTR : 0] data_avail;
  logic [    AW : 0] room_avail;
  logic [    AW : 0] data_avail;
  //  logic [FIFO_WIDTH - 1 : 0] dout;
  logic [DW - 1 : 0] dout;
  logic              dout_valid;

  //sync_fifo_v2 #(.FIFO_PTR(FIFO_PTR), .FIFO_WIDTH(FIFO_WIDTH))
  //i_sync_fifo (.*);
  sync_fifo_v2 #(
      .AW(AW),
      .DW(DW)
  ) i_sync_fifo (
      .*
  );

  rand_data #(.W(FIFO_WIDTH)) i_rand_data;

  initial begin
    clk = 0;
    forever begin
      #(PERIOD / 2) clk = ~clk;
    end
  end

  default clocking cb @(posedge clk);
    default input #1step output #0;
    output rst, wen, din, ren;
    input full, empty, room_avail, data_avail, dout, dout_valid;
  endclocking

  initial begin
    i_rand_data = new();
    rst <= '1;
    wen <= '0;
    ren <= '0;
    din <= '0;
    repeat (2) @(cb);
    cb.rst <= '0;
    repeat (1) @(cb);
    for (int i = 0; i < 4; i++) begin
      ##1 cb.wen <= '1;
      i_rand_data.randomize();
      cb.din <= i_rand_data.data;
    end
    repeat (2)
    @(cb) begin
      cb.wen <= '0;
    end
    for (int i = 0; i < 10; i++) begin
      ##1 cb.wen <= '1;
      i_rand_data.randomize();
      cb.din <= i_rand_data.data;
    end
    ##1 cb.wen <= '0;
    for (int k = 0; k < 8; k++) begin
      ##1 cb.ren <= '1;
      cb.wen <= '0;
    end
    for (int i = 0; i < 4; i++) begin
      ##1 cb.wen <= '1;
      i_rand_data.randomize();
      cb.din <= i_rand_data.data;
      cb.ren <= '0;
    end
    for (int k = 0; k < 4; k++) begin
      ##1 cb.wen <= '1;
      i_rand_data.randomize();
      cb.din <= i_rand_data.data;
      cb.ren <= '1;
    end
    for (int k = 0; k < 2; k++) begin
      ##1 cb.wen <= '0;
      cb.ren <= '1;
    end
    repeat (2)
    @(cb) begin
      cb.ren <= '0;
    end
    for (int k = 0; k < 2; k++) begin
      ##1 cb.wen <= '0;
      cb.ren <= '1;
    end
    repeat (2)
    @(cb) begin
      cb.ren <= '0;
    end
    for (int k = 0; k < 16; k++) begin
      ##1 cb.wen <= '1;
      i_rand_data.randomize();
      cb.din <= i_rand_data.data;
      ##2 cb.ren <= '1;
    end
    repeat (4) @(cb);
    $stop;
  end
endmodule




