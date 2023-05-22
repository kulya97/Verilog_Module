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
    parameter REG_WIDTH
) (
    input                  clk,
    input                  rst_n,
    output                 spi_cs,
    output                 spi_mosi,
    input                  spi_miso,
    output                 spi_slk,
    input  [REG_WIDTH-1:0] app_din,
    input                  app_req,
    output                 app_ack
);
endmodule
