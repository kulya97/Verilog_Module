`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/22 16:05:56
// Design Name: 
// Module Name: spi_master_module
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


module spi_master_module #(
    parameter REG_WIDTH = 16
) (
    input                  clk,
    input                  rst_n,
    output                 SPI_CS,
    output                 SPI_MOSI,
    input                  SPI_MISO,
    output                 SPI_SCLK,
    input  [REG_WIDTH-1:0] app_din,
    input                  app_req,
    output                 app_ack
);
  wire                 fifo_rden;
  wire                 fifo_full;
  wire                 fifo_empty;
  
  wire [REG_WIDTH-1:0] fifo_dout;
  localparam ADDR_WIDTH = 128;
  syn_fifo #(
      .WIDTH(REG_WIDTH),
      .DEPTH(ADDR_WIDTH)
  ) u_syn_fifo (
      .clk  (clk),
      .rst_n(rst_n),
      .din  (app_din[REG_WIDTH-1:0]),
      .wr_en(app_req),

      .rd_en(fifo_rden),

      .dout    (fifo_dout[REG_WIDTH-1:0]),
      .full    (fifo_full),
      .empty   (fifo_empty),
      .fifo_cnt()
  );

  wire wr_ready;
  wire wr_valid;

  assign wr_valid  = !fifo_empty;
  assign fifo_rden = wr_valid && wr_ready;
  localparam CHANNEL = 1;
  spi_master_core #(
      .CHANNEL  (CHANNEL),
      .REG_WIDTH(REG_WIDTH)
  ) u_spi_master_core (
      .clk       (clk),
      .rst_n     (rst_n),
      .CPOL      (1),
      .CPHA      (1),
      .wr_channel(1),
      .SPI_MISO  (SPI_MISO),
      .SPI_CS    (SPI_CS),
      .SPI_SCLK  (SPI_SCLK),
      .SPI_MOSI  (SPI_MOSI),


      .wr_ready(wr_ready),
      .data_in (fifo_dout[REG_WIDTH-1:0]),

      .wr_valid(wr_valid),
      .data_out()
  );

endmodule
