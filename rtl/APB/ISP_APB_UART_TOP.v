`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NJUST
// Engineer: huangwenjie
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
    //-- UI PORT
    input                   i_init_en,
    output                  o_init_done,
    //-- UART
    input                   i_uart_rx,
    output                  o_uart_tx,
    output [           2:0] o_apb_prot,    //APB4 sign unused  000
    output [APB_DBIT/8-1:0] o_apb_strb,    //APB4 sign unused
    input                   i_apb_clk,
    input                   i_apb_rstn,
    output [  APB_ABIT-1:0] o_apb_addr,
    output                  o_apb_write,
    output                  o_apb_selx,
    output                  o_apb_enable,
    output [  APB_DBIT-1:0] o_apb_wdata,
    input  [  APB_DBIT-1:0] i_apb_rdata,
    input                   i_apb_ready,
    input                   i_apb_slverr
);
  /********************************************************/
  //-- cfg
  wire        cfg_valid;
  wire        cfg_ready;
  wire [71:0] cfg_data;
  wire        cfg_init_done;
  //-- uart rx
  wire        uart_ready;
  wire        uart_valid;
  wire [71:0] uart_data;
  //-- apb master
  wire        apb_cmd_vld;
  wire        apb_cmd_ready;

  wire [31:0] apb_cmd_rdata;
  wire [71:0] apb_cmd_data;
  /********************************************************/
  assign apb_cmd_data = cfg_init_done ? uart_data : cfg_data;
  assign apb_cmd_vld  = i_init_en && (cfg_valid || uart_valid);

  assign cfg_ready    = i_init_en && !cfg_init_done && apb_cmd_ready;
  assign uart_ready   = i_init_en && cfg_init_done && apb_cmd_ready;
  assign o_init_done  = cfg_init_done;
  /********************************************************/
  APB_Master_Core #(
      .APB_DBIT(APB_DBIT),
      .APB_ABIT(APB_ABIT),
      .CMD_DBIT(8),
      .RD_FLAG (8'h00),
      .WR_FLAG (8'hff)
  ) APB_Master_Core_inst (
      .i_cmd_vld   (apb_cmd_vld),
      .o_cmd_ready (apb_cmd_ready),
      .i_cmd_data  (apb_cmd_data),
      .o_cmd_rdata (apb_cmd_rdata),
      .o_apb_prot  (o_apb_prot),     //APB4 sign unused  000
      .o_apb_strb  (o_apb_strb),     //APB4 sign 
      .i_apb_clk   (i_apb_clk),
      .i_apb_rstn  (i_apb_rstn),
      .o_apb_addr  (o_apb_addr),
      .o_apb_write (o_apb_write),
      .o_apb_selx  (o_apb_selx),
      .o_apb_enable(o_apb_enable),
      .o_apb_wdata (o_apb_wdata),
      .i_apb_rdata (i_apb_rdata),
      .i_apb_ready (i_apb_ready),
      .i_apb_slverr(i_apb_slverr)
  );
  /********************************************************/
  ISP_APB_REG_CFG #(
      .APB_DBIT(APB_DBIT),
      .APB_ABIT(APB_ABIT),
      .CMD_DBIT(8)
  ) ISP_APB_REG_CFG_inst (
      .i_clk      (i_apb_clk),
      .i_rstn     (i_apb_rstn),
      .o_valid    (cfg_valid),
      .i_ready    (cfg_ready),
      .o_data     (cfg_data),
      .o_init_done(cfg_init_done)
  );
  /********************************************************/
  uart_reg_rx_module #(
      .CLK_FRE   (10),       //Mhz
      .BPS       (1000000),  //uart bps
      .IDLE_CYCLE(20),       //idle time
      .REG_WIDTH (72)
  ) your_instance_name (
      .clk          (i_apb_clk),   // input wire clk
      .rst_n        (i_apb_rstn),  // input wire rst_n
      .uart_rx_en   (1),
      .uart_rx_port (i_uart_rx),   // input wire uart_rx_port
      .uart_rx_data (uart_data),   // output wire [71 : 0] uart_rx_data
      .uart_rx_ready(uart_ready),  // input wire uart_rx_ready
      .uart_rx_valid(uart_valid)   // output wire uart_rx_valid
  );
endmodule
