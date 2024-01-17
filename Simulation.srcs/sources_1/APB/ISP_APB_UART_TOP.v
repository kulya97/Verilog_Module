`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/17 16:51:36
// Design Name: 
// Module Name: ISP_APB_UART_TOP
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


module ISP_APB_UART_TOP #(
    parameter APB_DBIT = 32,
    parameter APB_ABIT = 32
) (
    input                       i_uart_rx,
    output                      o_uart_tx,
`ifdef APB4
    output     [           2:0] o_apb_prot,    //APB4 sign unused  000
    output     [APB_DBIT/8-1:0] o_apb_strb,    //APB4 sign unused
`endif
    //-- apb3 if
    input                       i_apb_clk,
    input                       i_apb_rstn,
    output reg [  APB_ABIT-1:0] o_apb_addr,
    output reg                  o_apb_write,
    output reg                  o_apb_selx,
    output reg                  o_apb_enable,
    output reg [  APB_DBIT-1:0] o_apb_wdata,
    input      [  APB_DBIT-1:0] i_apb_rata,
    input                       i_apb_ready,
    input                       i_apb_slverr


);

  APB_Master_Core #(
      .APB_DBIT(APB_DBIT),
      .APB_ABIT(APB_ABIT),
      .RD_FLAG (00),
      .WR_FLAG (11)
  ) APB_Master_Core_inst (
      .i_cmd_vld    (i_cmd_vld),
      .o_cmd_ready  (o_cmd_ready),
      .i_cmd_rw     (i_cmd_rw),
      .i_cmd_addr   (i_cmd_addr),
      .i_cmd_wdata  (i_cmd_wdata),
      .o_cmd_rd_data(o_cmd_rd_data),
`ifdef APB4
      .o_apb_prot   (o_apb_prot),     //APB4 sign unused  000
      .o_apb_strb   (o_apb_strb),     //APB4 sign 
`endif
      .i_apb_clk    (i_apb_clk),
      .i_apb_rstn   (i_apb_rstn),
      .o_apb_addr   (o_apb_addr),
      .o_apb_write  (o_apb_write),
      .o_apb_selx   (o_apb_selx),
      .o_apb_enable (o_apb_enable),
      .o_apb_wdata  (o_apb_wdata),
      .i_apb_rata   (i_apb_rata),
      .i_apb_ready  (i_apb_ready),
      .i_apb_slverr (i_apb_slverr)
  );

  uart_reg_rx_module_1 your_instance_name (
      .clk          (i_apb_clk),      // input wire clk
      .rst_n        (i_apb_rstn),     // input wire rst_n
      .uart_rx_port (i_uart_rx),      // input wire uart_rx_port
      .uart_rx_data (uart_rx_data),   // output wire [65 : 0] uart_rx_data
      .uart_rx_ready(uart_rx_ready),  // input wire uart_rx_ready
      .uart_rx_valid(uart_rx_valid)   // output wire uart_rx_valid
  );
endmodule
