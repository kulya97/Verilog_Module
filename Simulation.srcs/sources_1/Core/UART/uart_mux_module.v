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
  wire d0_valid, d1_valid, d2_valid, d3_valid;
  wire [31:0] d0_dout;
  wire [31:0] d1_dout;
  wire [31:0] d2_dout;
  wire [31:0] d3_dout;
  wire d0_rden, d1_rden, d2_rden, d3_rden;
  uart_mux_fifo d0 (
      .clk  (clk),      // input wire clk
      .din  (D0_data),  // input wire [31 : 0] din
      .wr_en(D0_en),    // input wire wr_en
      .rd_en(d0_rden),  // input wire rd_en
      .dout (d0_dout),  // output wire [31 : 0] dout
      //   .full (full),     // output wire full
      //   .empty(empty),    // output wire empty
      .valid(d0_valid)  // output wire valid
  );
  uart_mux_fifo d1 (
      .clk  (clk),      // input wire clk
      .din  (D1_data),  // input wire [31 : 0] din
      .wr_en(D1_en),    // input wire wr_en
      .rd_en(d1_rden),  // input wire rd_en
      .dout (d1_dout),  // output wire [31 : 0] dout
      //   .full (full),     // output wire full
      //   .empty(empty),    // output wire empty
      .valid(d1_valid)  // output wire valid
  );
  uart_mux_fifo d2 (
      .clk  (clk),      // input wire clk
      .din  (D2_data),  // input wire [31 : 0] din
      .wr_en(D2_en),    // input wire wr_en
      .rd_en(d2_rden),  // input wire rd_en
      .dout (d2_dout),  // output wire [31 : 0] dout
      //   .full (full),     // output wire full
      //   .empty(empty),    // output wire empty
      .valid(d2_valid)  // output wire valid
  );
  uart_mux_fifo d3 (
      .clk  (clk),      // input wire clk
      .din  (D3_data),  // input wire [31 : 0] din
      .wr_en(D3_en),    // input wire wr_en
      .rd_en(d3_rden),  // input wire rd_en
      .dout (d3_dout),  // output wire [31 : 0] dout
      //   .full (full),     // output wire full
      //   .empty(empty),    // output wire empty
      .valid(d3_valid)  // output wire valid
  );
  assign d0_rden      = d0_valid;
  assign d1_rden      = (!d0_valid) & d1_valid;
  assign d2_rden      = (!d0_valid) & (!d1_valid) & d2_valid;
  assign d3_rden      = (!d0_valid) & (!d1_valid) & (!d2_valid) & d3_valid;
  assign uart_tx_en   = d0_valid | d1_valid | d2_valid | d3_valid;
  assign uart_tx_data = d0_valid ? d0_dout : (d1_valid ? d1_dout : (d2_valid ? d2_dout : d3_dout));
  
//   wire [3:0] valid;
//   assign valid={d3_valid,d2_valid,d1_valid,d0_valid};
//   wire [4:0] rd_en;
//   always @(*) begin
//     case (valid)
//       4'b1xxx: rd_en = 4'b1000;uart_tx_en=1'b1;uart_tx_data=d0_dout;
//       4'b01xx: rd_en = 4'b0100;uart_tx_en=1'b1;uart_tx_data=d1_dout;
//       4'b001x: rd_en = 4'b0010;uart_tx_en=1'b1;uart_tx_data=d2_dout;
//       4'b0001: rd_en = 4'b0001;uart_tx_en=1'b1;uart_tx_data=d3_dout;
//       4'b0000: rd_en = 4'b0000;uart_tx_en=1'b0;uart_tx_data=d3_dout;
//       default: rd_en = 4'b0000;uart_tx_en=1'b0;uart_tx_data=d3_dout;
//     endcase
//   end
endmodule
