`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/25 15:19:03
// Design Name: 
// Module Name: tb_sync_fifo
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


module tb_sync_fifo;

  // syn_fifo Parameters
  parameter PERIOD = 10;
  parameter WIDTH = 16;
  parameter DEPTH = 128;

  // syn_fifo Inputs
  reg              clk = 1;
  reg              rst_n = 0;
  reg  [WIDTH-1:0] din = 16'hf0f0;
  reg              wr_en = 0;
  reg              rd_en = 0;

  // syn_fifo Outputs
  wire [WIDTH-1:0] sync_dout;
  wire [WIDTH-1:0] standard_dout;
  wire [WIDTH-1:0] fwft_dout;

  wire             fwft_full;
  wire             fwft_empty;
  wire             standard_full;
  wire             standard_empty;
  wire             sync_full;
  wire             sync_empty;


  initial begin
    forever #(PERIOD / 2) clk = ~clk;

  end

  initial begin
    #(PERIOD * 2) rst_n = 1;
    #(PERIOD * 100);
    #(PERIOD * 2) din = 16'h1111;
    wr_en = 1;
    #(PERIOD) din = 16'h2222;
    wr_en = 1;
    #(PERIOD * 200) din = 16'h3333;
    wr_en = 1;
    #(PERIOD) din = 16'h4444;
    wr_en = 0;
    #(PERIOD) din = 16'h5555;
    wr_en = 0;
    #(PERIOD) din = 16'h6666;
    wr_en = 0;
    #(PERIOD * 10);
    #(PERIOD) rd_en = 1;
    #(PERIOD * 200) rd_en = 1;
    #(PERIOD) rd_en = 0;
    #(PERIOD) din = 16'h4444;
    wr_en = 1;
    #(PERIOD) din = 16'h5555;
    wr_en = 1;
    #(PERIOD) din = 16'h6666;
    wr_en = 0;
    #(PERIOD) rd_en = 1;
    #(PERIOD) rd_en = 1;

    #(PERIOD * 100) $finish;
  end
  sync_standard_fifo #(
      .WIDTH(WIDTH),
      .DEPTH(DEPTH)
  ) u_syn_fifo (
      .clk  (clk),
      .rst_n(rst_n),
      .din  (din[WIDTH-1:0]),
      .wr_en(wr_en),
      .rd_en(rd_en),

      .dout (sync_dout[WIDTH-1:0]),
      .full (sync_full),
      .empty(sync_empty)
  );
  standard_fifo u_standard_fifo (
      .clk  (clk),                       // input wire clk
      .rst  (!rst_n),
      .din  (din[WIDTH-1:0]),            // input wire [31 : 0] din
      .wr_en(wr_en),                     // input wire wr_en
      .rd_en(rd_en),                     // input wire rd_en
      .dout (standard_dout[WIDTH-1:0]),  // output wire [31 : 0] dout
      .full (standard_full),
      .empty(standard_empty)
  );

  fwft_fifo u_fwft_fifo (
      .clk  (clk),                   // input wire clk
      .rst  (!rst_n),
      .din  (din[WIDTH-1:0]),        // input wire [31 : 0] din
      .wr_en(wr_en),                 // input wire wr_en
      .rd_en(rd_en),                 // input wire rd_en
      .dout (fwft_dout[WIDTH-1:0]),  // output wire [31 : 0] dout
      .full (fwft_full),
      .empty(fwft_empty)
  );

endmodule
