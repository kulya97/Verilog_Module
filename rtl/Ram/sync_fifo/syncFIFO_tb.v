`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/04 01:03:50
// Design Name: 
// Module Name: syncFIFO_tb
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



module syncFIFO_tb;

  // Parameters
  localparam DATA_WIDTH = 32;
  localparam ADDR_WIDTH = 8;

  //Ports
  reg  [DATA_WIDTH-1:0] din = 0;
  reg                   wr_en = 0;
  reg                   rd_en = 0;
  reg                   clk = 1;
  reg                   rst = 1;
  wire                  full00;
  wire [DATA_WIDTH-1:0] dout00;
  wire                  empty00;
  wire                  full01;
  wire [DATA_WIDTH-1:0] dout01;
  wire                  empty01;
  wire                  full0;
  wire [DATA_WIDTH-1:0] dout0;
  wire                  empty0;
  wire                  full1;
  wire [DATA_WIDTH-1:0] dout1;
  wire                  empty1;
  wire                  full2;
  wire [DATA_WIDTH-1:0] dout2;
  wire                  empty2;
  reg  [          15:0] i;
  initial begin
    #20;
    rst = 0;
    #200;
    for (i = 0; i < 300; i = i + 1) begin
      wr_en = 1;
      din   = i;
      #10;
    end
    wr_en = 0;
    for (i = 0; i < 300; i = i + 1) begin
      rd_en = 1;
      #10;
    end
    rd_en = 0;

    for (i = 0; i < 300; i = i + 1) begin
      wr_en = 1;
      din   = i;
      #10;
    end
    wr_en = 0;
    for (i = 0; i < 300; i = i + 1) begin
      rd_en = 1;
      #10;
    end
    rd_en = 0;
  end
  syncFIFO #(
      .DATA_WIDTH(DATA_WIDTH),
      .ADDR_WIDTH(ADDR_WIDTH),
      .fifo_type ("std")
  ) syncFIFO_inst1 (
      .din         (din),
      .wr_en       (wr_en),
      .full        (full00),
      .almost_full (),
      .dout        (dout00),
      .rd_en       (rd_en),
      .empty       (empty00),
      .almost_empty(),
      .clk         (clk),
      .rst         (rst)
  );
  syncFIFO #(
      .DATA_WIDTH(DATA_WIDTH),
      .ADDR_WIDTH(ADDR_WIDTH),
      .fifo_type ("fwft")
  ) syncFIFO_inst2 (
      .din         (din),
      .wr_en       (wr_en),
      .full        (full01),
      .almost_full (),
      .dout        (dout01),
      .rd_en       (rd_en),
      .empty       (empty01),
      .almost_empty(),
      .clk         (clk),
      .rst         (rst)
  );
  sync_fifo #(
      .WIDTH(32),
      .DEPTH(256)
  ) sync_fifo_inst (
      .clk     (clk),
      .rst_n   (!rst),
      .din     (din),
      .wr_en   (wr_en),
      .rd_en   (rd_en),
      .dout    (dout0),
      .full    (full0),
      .empty   (empty0),
      .fifo_cnt()
  );
  always #5 clk = !clk;
  fifo_generator_0 your_instance_name1 (
      .clk  (clk),    // input wire clk
      .din  (din),    // input wire [31 : 0] din
      .wr_en(wr_en),  // input wire wr_en
      .rd_en(rd_en),  // input wire rd_en
      .dout (dout1),  // output wire [31 : 0] dout
      .full (full1),  // output wire full
      .empty(empty1)  // output wire empty
  );
  fifo_generator_1 your_instance_name2 (
      .clk  (clk),    // input wire clk
      .din  (din),    // input wire [31 : 0] din
      .wr_en(wr_en),  // input wire wr_en
      .rd_en(rd_en),  // input wire rd_en
      .dout (dout2),  // output wire [31 : 0] dout
      .full (full2),  // output wire full
      .empty(empty2)  // output wire empty
  );
endmodule
