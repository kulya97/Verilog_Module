`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/04 10:12:41
// Design Name: 
// Module Name: sc2110_genout_module
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


module sc2110_genout_module (
    input             pclk_a,
    input             rst_n,
    input             i_fvld_a,
    input             i_lvld_a,
    input             i_dvld_a,
    input      [11:0] i_data_a,
    input             pclk_b,
    output reg        o_fvld_b,
    output            o_lvld_b,
    output            o_dvld_b,
    output     [11:0] o_data_b
);
  //--------------------------------------------------------
  wire        fifo_rst;
  wire        wr_clk;
  wire        rd_clk;
  wire [11:0] din;
  wire        wr_en;
  wire        rd_en;
  wire [11:0] dout;
  wire        empty;
  wire        full;
  wire        wr_rst_busy;
  wire        rd_rst_busy;
  //
  wire        w_dvld_a;
  //
  reg  [47:0] lvld_b;

  //--------------------------------------------------------
  assign w_dvld_a = i_fvld_a && i_lvld_a && i_dvld_a;
  assign wr_clk   = pclk_a;
  assign rd_clk   = pclk_b;
  assign din      = i_data_a;
  assign wr_en    = w_dvld_a;

  assign rd_en    = lvld_b[15] && !empty;
  assign o_data_b = dout;

  assign o_dvld_b = rd_en;
  assign o_lvld_b = rd_en;
  //--------------------------------------------------------
  always @(posedge pclk_b, negedge rst_n) begin
    if (!rst_n) o_fvld_b <= 1'b0;
    else o_fvld_b <= i_fvld_a;
  end
  //--------------------------------------------------------
  always @(posedge pclk_b, negedge rst_n) begin
    if (!rst_n) lvld_b[47:0] <= 48'b0;
    else lvld_b[47:0] <= {lvld_b[46:0], i_lvld_a};
  end
  //--------------------------------------------------------
  //-- rst
  assign fifo_rst = (!rst_n) | (!i_fvld_a);
  async_fifo_32x12b async_fifo_32x12b_inst (
      .rst        (fifo_rst),     // input wire rst
      .wr_clk     (wr_clk),       // input wire wr_clk
      .rd_clk     (rd_clk),       // input wire rd_clk
      .din        (din),          // input wire [11 : 0] din
      .wr_en      (wr_en),        // input wire wr_en
      .rd_en      (rd_en),        // input wire rd_en
      .dout       (dout),         // output wire [11 : 0] dout
      .full       (full),         // output wire full
      .empty      (empty),        // output wire empty
      .wr_rst_busy(wr_rst_busy),  // output wire wr_rst_busy
      .rd_rst_busy(rd_rst_busy)   // output wire rd_rst_busy
  );

endmodule
