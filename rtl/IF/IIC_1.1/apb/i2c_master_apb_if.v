`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/02/22 00:11:08
// Design Name: 
// Module Name: i2c_master_apb_if
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


module i2c_master_apb_if #(
    parameter               APB_ABIT   = 32,
    parameter               APB_DBIT   = 32,
    parameter         [6:0] SLAVE_ADDR = 7'b1010000,      //EEPROM从机地址
    parameter integer       CLK_FREQ   = 26'd50_000_000,  //模块输入的时钟频率
    parameter integer       I2C_FREQ   = 18'd250_000,     //IIC_SCL的时钟频率
    parameter integer       WR_BITS    = 8'd1,
    parameter integer       RD_BITS    = 8'd1
) (
    input                      apb_clk,
    input                      apb_rstn,
    //--
    input                      i_apb_psel,
    input                      i_apb_penable,
    input                      i_apb_pwrite,
    input       [APB_ABIT-1:0] i_apb_paddr,
    input       [APB_DBIT-1:0] i_apb_pwdata,
    //--
    input       [         2:0] i_apb_prot,     //APB4 sign unused  000
    input       [         3:0] i_apb_pstrb,    //APB3 sign
    //--
    output wire                o_apb_pready,   //APB3 sign
    output wire [APB_DBIT-1:0] o_apb_prdata,
    output                     o_apb_slverr    //APB3 sign unused
);

  i2c_master_module #(
      .SLAVE_ADDR(SLAVE_ADDR),
      .CLK_FREQ(CLK_FREQ),
      .I2C_FREQ(I2C_FREQ),
      .WR_BITS(WR_BITS),
      .RD_BITS(RD_BITS)
  ) i2c_master_module_inst (
      .clk           (apb_clk),
      .rst_n         (apb_rstn),
      .i_i2c_wvalid  (i_i2c_wvalid),
      .i_i2c_wready  (i_i2c_wready),
      .i_cmd_bit_ctrl(i_cmd_bit_ctrl),
      .i_cmd_rh_wl   (i_cmd_rh_wl),
      .i_i2c_addr    (i_i2c_addr),
      .i_i2c_wdata   (i_i2c_wdata),
      .o_i2c_rdata   (o_i2c_rdata),
      .o_i2c_rvalid  (o_i2c_rvalid),
      .i2c_scl       (i2c_scl),
      .i2c_sda       (i2c_sda),
      .o_i2c_done    (o_i2c_done),
      .o_i2c_ack     (o_i2c_ack),
      .o_i2c_busy    (o_i2c_busy)
  );
endmodule
