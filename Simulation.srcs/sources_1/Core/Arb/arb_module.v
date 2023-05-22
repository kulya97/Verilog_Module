`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/07 09:33:08
// Design Name: 
// Module Name: uart_arb_module
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


module uart_mux_module (
    input         clk,
    input         rst_n,
    input         D0_en,
    input  [31:0] D0_data,
    input         D1_en,
    input  [31:0] D1_data,
    input         D2_en,
    input  [31:0] D2_data,
    input         D3_en,
    input  [31:0] D3_data,
    output        uart_tx_en,
    output [31:0] uart_tx_data
);

  assign d0_rden      = d0_valid;
  assign d1_rden      = (!d0_valid) & d1_valid;
  assign d2_rden      = (!d0_valid) & (!d1_valid) & d2_valid;
  assign d3_rden      = (!d0_valid) & (!d1_valid) & (!d2_valid) & d3_valid;
  assign uart_tx_en   = d0_valid | d1_valid | d2_valid | d3_valid;
  assign uart_tx_data = d0_valid ? d0_dout : (d1_valid ? d1_dout : (d2_valid ? d2_dout : d3_dout));
  
  prior_arb #(
      .REQ_WIDTH(REQ_WIDTH)
  ) u_prior_arb (
      .req(req[REQ_WIDTH-1:0]),

      .gnt(gnt[REQ_WIDTH-1:0])
  );
endmodule
