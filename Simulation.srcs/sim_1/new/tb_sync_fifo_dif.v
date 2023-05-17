`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/17 16:35:41
// Design Name: 
// Module Name: tb_sync_fifo_dif
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_sync_fifo_dif;

  function integer clogb2;
    input [31:0] value;
    begin
      value = value - 1;
      for (clogb2 = 0; value > 0; clogb2 = clogb2 + 1) value = value >> 1;
    end
  endfunction

  // uart_rx_reg_module Parameters
  parameter PERIOD = 10;
  parameter WR_WIDTH = 8;
  parameter RD_WIDTH = 32;
  parameter DEPTH = 1024;
  localparam ADDR_WIDTH = clogb2(DEPTH);
  // uart_rx_reg_module Inputs
  reg                   clk = 0;
  reg                   rst_n = 0;
  reg                   wr_rst = 0;
  reg                   wr_en = 0;
  reg  [  WR_WIDTH-1:0] din = 0;
  reg                   rd_en = 0;

  // uart_rx_reg_module Outputs
  wire [  RD_WIDTH-1:0] dout;
  wire                  full;
  wire                  empty;
  wire [ADDR_WIDTH-1:0] fifo_cnt;


  initial begin
    forever #(PERIOD / 2) clk = ~clk;
  end

  initial begin
    #(PERIOD * 2) rst_n = 1;
    #(PERIOD * 20) wr_en = 'b1;
    din = 'h1;
    #(PERIOD * 1) din = 'h1;
    #(PERIOD * 1) din = 'h2;
    #(PERIOD * 1) din = 'h3;
    #(PERIOD * 1) din = 'h4;
    #(PERIOD * 1) din = 'h5;
    #(PERIOD * 1) din = 'h6;
    #(PERIOD * 1) din = 'h7;
    #(PERIOD * 1) din = 'h8;
    #(PERIOD * 1) din = 'h9;
    #(PERIOD * 1) din = 'ha;
    #(PERIOD * 1) din = 'hb;
    #(PERIOD * 1) din = 'hc;
    #(PERIOD * 1) din = 'hd;
    #(PERIOD * 1) din = 'he;
    #(PERIOD * 1) din = 'hf;
    wr_en = 'b0;
    #(PERIOD * 100) wr_en = 'b1;
    din = 'h0;
    #(PERIOD * 1) din = 'hf;
    #(PERIOD * 1) din = 'hf;
    wr_en = 'b0;
  end

  sync_fifo_dif #(
      .WR_WIDTH(WR_WIDTH),
      .RD_WIDTH(RD_WIDTH),
      .DEPTH   (DEPTH)
  ) u_sync_fifo_dif (
      .clk   (clk),
      .rst_n (rst_n),
      .wr_rst(wr_rst),
      .wr_en (wr_en),
      .din   (din[WR_WIDTH-1:0]),
      .rd_en (!empty),

      .dout    (dout[RD_WIDTH-1:0]),
      .full    (full),
      .empty   (empty),
      .fifo_cnt(fifo_cnt[ADDR_WIDTH-1:0])
  );


endmodule
