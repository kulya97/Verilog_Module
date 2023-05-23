`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/22 16:53:56
// Design Name: 
// Module Name: tb_spi_master_module
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


module tb_spi_master_module;

  // spi_master_module Parameters
  parameter PERIOD = 10;
  parameter REG_WIDTH = 32;

  // spi_master_module Inputs
  reg                  clk = 0;
  reg                  rst_n = 0;
  reg                  SPI_MISO = 0;
  reg  [REG_WIDTH-1:0] app_din = 0;
  reg                  app_req = 0;

  // spi_master_module Outputs
  wire                 SPI_CS;
  wire                 SPI_MOSI;
  wire                 SPI_SCLK;
  wire                 app_ack;


  initial begin
    forever #(PERIOD / 2) clk = ~clk;
  end

  initial begin
    #(PERIOD * 200) rst_n = 1;
    #(PERIOD * 1) app_req = 1;
    app_din = 16'h0101;
    #(PERIOD * 1) app_req = 1;
    app_din = 16'h0202;
    #(PERIOD * 1) app_req = 1;
    app_din = 16'h0023;
    #(PERIOD * 1) app_req = 1;
    app_din = 16'h1024;
    #(PERIOD * 1) app_req = 0;
    app_din = 16'h0515;

  end

  spi_master_module #(
      .REG_WIDTH(REG_WIDTH)
  ) u_spi_master_module (
      .clk     (clk),
      .rst_n   (rst_n),
      .SPI_MISO(SPI_MISO),
      .app_din (app_din[REG_WIDTH-1:0]),
      .app_req (app_req),

      .SPI_CS  (SPI_CS),
      .SPI_MOSI(SPI_MOSI),
      .SPI_SCLK(SPI_SCLK),
      .app_ack (app_ack)
  );


endmodule
