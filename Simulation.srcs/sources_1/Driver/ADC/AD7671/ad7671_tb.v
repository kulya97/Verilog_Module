`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/20 15:48:11
// Design Name: 
// Module Name: ad7671_tb
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


module ad7671_tb;

  reg  CLK_UART_50M;
  reg  rstn_ad7671;
  wire FPGA_CPLD1_IO1;
  wire FPGA_CPLD0_IO2;
  wire AD7671_INVSYNC;
  wire AD7671_RDC;
  wire AD7671_EXIT;
  wire AD7671_CS;
  wire AD7671_RD;

  wire AD7671_CNVST;
  reg  AD7671_BUSY;
  reg  AD7671_SYNC;
  wire AD7671_SCLK;
  reg  AD7671_SDOUT;

  wire AD7671_valid;
  wire AD7671_datao;
  wire UART_REG;
  wire uart_ready_flag;


  initial begin
    CLK_UART_50M = 0;
    rstn_ad7671  = 1;
    AD7671_BUSY  = 0;
    AD7671_SYNC  = 0;
    AD7671_SDOUT = 1;
    #10;
    rstn_ad7671 = 0;
    #10;
    rstn_ad7671 = 1;
  end
  always @(posedge CLK_UART_50M) begin
    AD7671_BUSY <= !AD7671_CNVST;
    AD7671_SYNC <= !AD7671_CNVST;
  end

  always #1 CLK_UART_50M = ~CLK_UART_50M;

  AD7671_Module AD7671_Module0 (
      .CLK_50M      (CLK_UART_50M),
      .RST_N        (rstn_ad7671),
      .adc_reset_o  (FPGA_CPLD1_IO1),
      .adc_pd_o     (FPGA_CPLD0_IO2),
      .adc_invsync_o(AD7671_INVSYNC),
      .adc_rdc_o    (AD7671_RDC),
      .adc_exit_o   (AD7671_EXIT),
      .adc_cs_n_o   (AD7671_CS),
      .adc_rd_n_o   (AD7671_RD),
      .adc_cnvst_n_o(AD7671_CNVST),
      .adc_busy_i   (AD7671_BUSY),
      .adc_sync_i   (AD7671_SYNC),
      .adc_sclk_o   (AD7671_SCLK),
      .adc_sdout_i  (AD7671_SDOUT),
      .ui_valid_o   (AD7671_valid),
      .ui_data_o    (AD7671_datao),
      .UART_IN      (UART_REG),
      .uart_ready   (uart_ready_flag)
  );

endmodule
